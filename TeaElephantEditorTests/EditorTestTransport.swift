import Foundation
import Apollo
@_spi(Unsafe) import ApolloAPI
import TeaElephantSchema

// Only the external transport is replaced; managers and Apollo parsing remain real.
final class EditorTestTransport: NetworkTransport, SubscriptionNetworkTransport, @unchecked Sendable {
    enum Failure { case none, transport, graphQL }
    enum Event { case none, update, create, addTag, removeTag, tagAfterUpdate, tagAfterDelete, updateAfterDelete }
    private let lock = NSLock()
    private var operations: [String] = []
    private var getIDs: [String] = []
    private var updateIDs: [String] = []
    private var removed = false
    private var tagPresent = true
    let failure: Failure
    let event: Event
    let description: String
    let descriptionFailure: Failure
    let gate = EditorTestGate()

    init(failure: Failure = .none, event: Event = .none, description: String = "", descriptionFailure: Failure = .none) {
        self.descriptionFailure = descriptionFailure
        self.description = description
        self.failure = failure
        self.event = event
        self.tagPresent = event != .addTag
    }
    var recordedOperations: [String] {
        lock.lock(); defer { lock.unlock() }; return operations
    }
    var recordedGetIDs: [String] {
        lock.lock(); defer { lock.unlock() }; return getIDs
    }
    var recordedUpdateIDs: [String] {
        lock.lock(); defer { lock.unlock() }; return updateIDs
    }
    private func recordUpdate(_ id: String) {
        lock.lock(); defer { lock.unlock() }; updateIDs.append(id)
    }
    private func record(_ operation: String, id: String? = nil) {
        lock.lock(); defer { lock.unlock() }
        operations.append(operation)
        if let id { getIDs.append(id) }
    }
    private func setRemoved() {
        lock.lock(); defer { lock.unlock() }; removed = true
    }
    private func setTagPresent(_ present: Bool) {
        lock.lock(); defer { lock.unlock() }; tagPresent = present
    }
    private func snapshot() -> (removed: Bool, tagPresent: Bool) {
        lock.lock(); defer { lock.unlock() }; return (removed, tagPresent)
    }
    private func category(_ name: String = "Origin") -> [String: Any] {
        ["__typename": "TagCategory", "id": "category-1", "name": name,
         "tags": [["__typename": "Tag", "id": "tag-1", "name": "Yunnan", "color": "#FFFF0000"]]]
    }
    private func tea(name: String = "Fixture coffee", id: String = "tea-1") -> [String: Any] {
        ["__typename": "Tea", "id": id, "name": name, "type": "coffee", "description": "Fixture description",
         "tags": snapshot().tagPresent ? [["__typename": "Tag", "id": "tag-1", "name": "Yunnan", "color": "#FFFF0000", "category": category()]] : []]
    }
    private func response<Operation: GraphQLOperation>(_ operation: Operation, data: [String: Any]) -> AsyncThrowingStream<GraphQLResponse<Operation>, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    if let query = operation as? TagCategoriesQuery, query.name == "old" {
                        await gate.wait()
                    }
                    if let query = operation as? TagCategoriesQuery, query.name == "old" {
                        record("oldCategoryResponse")
                    }
                    if ((event == .tagAfterUpdate || event == .tagAfterDelete) && Operation.operationName == "onAddTag") ||
                        (event == .updateAfterDelete && Operation.operationName == "onUpdate") {
                        await gate.wait()
                        record("delayedEventReleased")
                    }
                    let parsed = try await Operation.Data(data: data, variables: operation.__variables)
                    continuation.yield(GraphQLResponse(data: parsed, extensions: nil, errors: nil, source: .server, dependentKeys: nil))
                    continuation.finish()
                } catch { continuation.finish(throwing: error) }
            }
            continuation.onTermination = { @Sendable _ in task.cancel() }
        }
    }
    func send<Query: GraphQLQuery>(query: Query, fetchBehavior: FetchBehavior, requestConfiguration: RequestConfiguration) throws -> AsyncThrowingStream<GraphQLResponse<Query>, Error> {
        record(Query.operationName, id: (query as? GetQuery)?.id)
        if query is DescGenQuery {
            if descriptionFailure == .transport { throw URLError(.networkConnectionLost) }
            if descriptionFailure == .graphQL {
                return AsyncThrowingStream { continuation in
                    continuation.yield(GraphQLResponse(data: nil, extensions: nil, errors: [GraphQLError(["message": "Description rejected"])], source: .server, dependentKeys: nil))
                    continuation.finish()
                }
            }
        }
        let body: [String: Any]
        switch query {
        case is ListQuery: body = ["teas": [tea(), tea(name: "Missing fixture record", id: "missing"), tea(name: "Broken fixture record", id: "broken")]]
        case let get as GetQuery:
            if get.id == "broken" && recordedGetIDs.filter({ $0 == "broken" }).count == 1 {
                throw URLError(.networkConnectionLost)
            }
            body = ["tea": get.id.isEmpty || get.id == "missing" || snapshot().removed ? NSNull() : tea(id: get.id) as Any]
        case let categories as TagCategoriesQuery:
            body = ["tagsCategories": [category(categories.name.isEmpty ? "Origin" : categories.name)]]
        case is TagsQuery, is TagsMetaQuery: body = ["tagsCategories": [category()]]
        case is DescGenQuery: body = ["generateDescription": description]
        default: throw URLError(.unsupportedURL)
        }
        return response(query, data: body)
    }
    func send<Mutation: GraphQLMutation>(mutation: Mutation, requestConfiguration: RequestConfiguration) throws -> AsyncThrowingStream<GraphQLResponse<Mutation>, Error> {
        record(Mutation.operationName)
        if failure == .transport { throw URLError(.networkConnectionLost) }
        if failure == .graphQL {
            return AsyncThrowingStream { continuation in
                continuation.yield(GraphQLResponse(data: nil, extensions: nil, errors: [GraphQLError(["message": "Mutation rejected"])], source: .server, dependentKeys: nil))
                continuation.finish()
            }
        }
        let body: [String: Any]
        switch mutation {
        case is CreateMutation: body = ["newTea": ["__typename": "Tea", "id": "created-1"]]
        case let update as UpdateMutation:
            recordUpdate(update.id)
            body = ["updateTea": tea(name: "Updated fixture", id: update.id)]
        case let deletion as DeleteMutation: setRemoved(); body = ["deleteTea": deletion.id]
        case let add as AddTagMutation: setTagPresent(true); body = ["addTagToTea": ["__typename": "Tea", "id": add.tea]]
        case let removal as RemoveTagMutation: setTagPresent(false); body = ["deleteTagFromTea": ["__typename": "Tea", "id": removal.tea]]
        case is CreateTagMutation: body = ["createTag": ["__typename": "Tag", "id": "tag-new", "name": "New", "color": "#FFFF0000"]]
        case is CreateTagCategoryMutation: body = ["createTagCategory": category("New")]
        default: throw URLError(.unsupportedURL)
        }
        return response(mutation, data: body)
    }
    func send<Subscription: GraphQLSubscription>(subscription: Subscription, fetchBehavior: FetchBehavior, requestConfiguration: RequestConfiguration) throws -> SubscriptionStream<GraphQLResponse<Subscription>> {
        record(Subscription.operationName)
        let body: [String: Any]?
        if (event == .update || event == .tagAfterUpdate || event == .updateAfterDelete) && subscription is OnUpdateSubscription {
            var updated = tea(name: "Changed by subscription")
            if event == .tagAfterUpdate { updated["type"] = "herb" }
            body = ["onUpdateTea": updated]
        } else if event == .create && subscription is OnCreateSubscription {
            body = ["onCreateTea": tea(name: "Created by subscription", id: "tea-2")]
        } else if event == .addTag && Subscription.operationName == "onAddTag" {
            setTagPresent(true)
            body = ["onAddTagToTea": tea()]
        } else if event == .removeTag && Subscription.operationName == "onRemoveTag" {
            setTagPresent(false)
            body = ["onDeleteTagFromTea": tea()]
        } else if (event == .tagAfterUpdate || event == .tagAfterDelete) && Subscription.operationName == "onAddTag" {
            var oldTea = tea()
            oldTea["tags"] = [["__typename": "Tag", "id": "tag-1", "name": "Yunnan", "color": "#FF00FF00", "category": category()]]
            body = ["onAddTagToTea": oldTea]
        } else if (event == .tagAfterDelete || event == .updateAfterDelete) && subscription is OnDeleteSubscription {
            body = ["onDeleteTea": "tea-1"]
        } else { body = nil }
        let stream: AsyncThrowingStream<GraphQLResponse<Subscription>, Error>
        if let body { stream = response(subscription, data: body) }
        else { stream = AsyncThrowingStream { $0.finish() } }
        return SubscriptionStream(stream: stream, stateProvider: { .active })
    }
}

actor EditorTestGate {
    private var continuation: CheckedContinuation<Void, Never>?
    private var opened = false
    func wait() async {
        if opened { return }
        await withCheckedContinuation { continuation = $0 }
    }
    func open() {
        opened = true
        continuation?.resume()
        continuation = nil
    }
}
