import XCTest
import Apollo
import TeaElephantSchema
import SwiftUI
@testable import TeaElephantEditor

@MainActor
final class EditorRegressionTests: XCTestCase {
    private var input: TeaData {
        TeaData(name: "Fixture", type: GraphQLEnum(.coffee), description: "Fixture description")
    }
    private var tag: Tag {
        Tag(id: "tag-1", name: "Yunnan", color: "#FFFF0000", category: TagCategory(id: "category-1", name: "Origin"))
    }
    private var client: ApolloClient!
    private func use(_ transport: EditorTestTransport) {
        client = ApolloClient(networkTransport: transport, store: ApolloStore())
    }
    private func expectFailure(_ operation: () async throws -> Void) async {
        do {
            try await operation()
            XCTFail("Failed write must propagate its error")
        } catch {}
    }
    private func waitUntil(_ predicate: () -> Bool) async throws {
        for _ in 0..<200 {
            if predicate() { return }
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        XCTFail("Audit fixture did not deliver expected response")
    }
    func testCreatePromotesDraftToPersistedID() async throws {
        let transport = EditorTestTransport()
        use(transport)
        let manager = DetailManager("", client: client)
        try await manager.create(input)
        XCTAssertEqual(manager.detail?.ID, "created-1", "Fixture confirms mutation really succeeded")
        XCTAssertEqual(manager.id, "created-1", "Created ID must become the manager's mutation target")
        XCTAssertEqual(transport.recordedGetIDs, ["created-1"], "Reload must use the returned ID")
    }
    func testRepeatedSaveOfCreatedRecordDoesNotCreateAnother() async throws {
        let transport = EditorTestTransport()
        use(transport)
        let manager = DetailManager("", client: client)
        try await manager.create(input)
        try await manager.create(input)
        XCTAssertEqual(transport.recordedOperations.filter { $0 == "create" }.count, 1,
                       "Second Save of a persisted draft must update its record")
        XCTAssertEqual(transport.recordedUpdateIDs, ["created-1"])
        XCTAssertEqual(manager.id, "created-1")
    }
    func testUpdateTransportFailureDoesNotShowSaved() async throws {
        use(EditorTestTransport(failure: .transport))
        let manager = DetailManager("tea-1", client: client)
        await expectFailure { try await manager.update(input) }
        XCTAssertNotNil(manager.error)
        XCTAssertFalse(manager.saved, "Failed mutation must not display the success checkmark")
    }
    func testCreateTransportFailureDoesNotShowSaved() async throws {
        use(EditorTestTransport(failure: .transport))
        let manager = DetailManager("", client: client)
        await expectFailure { try await manager.create(input) }
        XCTAssertNotNil(manager.error)
        XCTAssertFalse(manager.saved, "Failed creation must not display the success checkmark")
    }
    func testGraphQLUpdateFailureIsVisible() async throws {
        use(EditorTestTransport(failure: .graphQL))
        let manager = DetailManager("tea-1", client: client)
        await expectFailure { try await manager.update(input) }
        XCTAssertNotNil(manager.error, "GraphQL rejection must reach the alert state")
    }
    func testGraphQLCreateFailureIsVisible() async throws {
        use(EditorTestTransport(failure: .graphQL))
        let manager = DetailManager("", client: client)
        await expectFailure { try await manager.create(input) }
        XCTAssertNotNil(manager.error, "GraphQL rejection must reach the alert state")
    }
    func testDeleteTransportFailureIsVisible() async throws {
        use(EditorTestTransport(failure: .transport))
        let manager = DetailManager("tea-1", client: client)
        await manager.loadData(forceReload: true)
        await expectFailure { try await manager.delete() }
        XCTAssertNotNil(manager.error, "Deletion failure must be shown")
    }
    func testDeleteSuccessClearsRecord() async throws {
        let transport = EditorTestTransport()
        use(transport)
        let manager = DetailManager("tea-1", client: client)
        await manager.loadData(forceReload: true)
        XCTAssertNotNil(manager.detail)
        try await manager.delete()
        XCTAssertTrue(transport.recordedOperations.contains("delete"))
        XCTAssertNil(manager.detail, "Deleted data must not remain editable")
    }
    func testTagMutationFailureIsVisible() async throws {
        use(EditorTestTransport(failure: .transport))
        let manager = TagsSelectManager("tea-1", client: client)
        await manager.addTag(tag)
        XCTAssertNotNil(manager.error, "Failed tag write must reach the alert state")
    }
    func testRemovingTagRefreshesDisplayedRecord() async throws {
        let transport = EditorTestTransport()
        use(transport)
        let detail = DetailManager("tea-1", client: client)
        await detail.loadData(forceReload: true)
        XCTAssertEqual(detail.detail?.tags.count, 1)
        await detail.tagsManager.removeTag(tag)
        let verification = DetailManager("tea-1", client: client)
        await verification.loadData(forceReload: true)
        XCTAssertEqual(verification.detail?.tags.count, 0, "Fixture confirms server state changed")
        XCTAssertEqual(detail.detail?.tags.count, 0, "Visible record must reflect a successful tag removal")
    }
    func testSubscriptionUpdatePreservesTypeAndTagIndicators() async throws {
        use(EditorTestTransport(event: .update))
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { manager.list.first?.name == "Changed by subscription" }
        XCTAssertEqual(manager.list.first?.type, .coffee, "Subscription payload says coffee")
        XCTAssertEqual(manager.list.first?.tags.count, 1, "Metadata must not be discarded by an unrelated update")
    }
    func testSubscriptionCreateUsesActualType() async throws {
        use(EditorTestTransport(event: .create))
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { manager.list.contains { $0.ID == "tea-2" } }
        XCTAssertEqual(manager.list.first { $0.ID == "tea-2" }?.type, .coffee)
    }
    func testTagAdditionSubscriptionUpdatesIndicators() async throws {
        use(EditorTestTransport(event: .addTag))
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { manager.list.first?.tags.count == 1 }
        XCTAssertEqual(manager.list.first?.tags.map(\.id), ["tag-1"])
        XCTAssertEqual(manager.list.first?.type, .coffee)
    }

    func testTagRemovalSubscriptionUpdatesIndicators() async throws {
        use(EditorTestTransport(event: .removeTag))
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { manager.list.first?.tags.isEmpty == true }
        XCTAssertEqual(manager.list.first?.tags.count, 0)
        XCTAssertEqual(manager.list.first?.type, .coffee)
    }

    func testDelayedTagEventPreservesNewerNameAndType() async throws {
        let transport = EditorTestTransport(event: .tagAfterUpdate)
        use(transport)
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { manager.list.first?.name == "Changed by subscription" }
        await transport.gate.open()
        try await waitUntil { manager.list.first?.tags.first?.color == "#FF00FF00" }
        XCTAssertEqual(manager.list.first?.name, "Changed by subscription")
        XCTAssertEqual(manager.list.first?.type, .herb)
    }

    func testDelayedTagEventDoesNotRestoreDeletedRecord() async throws {
        let transport = EditorTestTransport(event: .tagAfterDelete)
        use(transport)
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { !manager.list.contains { $0.ID == "tea-1" } }
        await transport.gate.open()
        try await waitUntil { transport.recordedOperations.contains("delayedEventReleased") }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertFalse(manager.list.contains { $0.ID == "tea-1" })
    }

    func testDelayedTeaUpdateDoesNotRestoreDeletedRecord() async throws {
        let transport = EditorTestTransport(event: .updateAfterDelete)
        use(transport)
        let manager = ListManager(client: client)
        await manager.loadData(forceReload: true)
        try await waitUntil { !manager.list.contains { $0.ID == "tea-1" } }
        await transport.gate.open()
        try await waitUntil { transport.recordedOperations.contains("delayedEventReleased") }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertFalse(manager.list.contains { $0.ID == "tea-1" })
    }

    func testOlderCategorySearchCannotOverwriteNewerResult() async throws {
        let transport = EditorTestTransport()
        use(transport)
        let manager = TagsEditor.CategoryManager(client: client)
        try await waitUntil { manager.categories.first?.name == "Origin" }
        manager.setName("old")
        try await waitUntil { transport.recordedOperations.filter { $0 == "tagCategories" }.count == 2 }
        manager.setName("new")
        try await waitUntil { manager.categories.first?.name == "new" }
        await transport.gate.open()
        try await waitUntil { transport.recordedOperations.contains("oldCategoryResponse") }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(manager.name, "new", "User's latest search remains new")
        XCTAssertEqual(manager.categories.first?.name, "new", "Stale response must not replace current search results")
    }
    func testMissingRecordHasVisibleTerminalState() async throws {
        use(EditorTestTransport())
        let manager = DetailManager("missing", client: client)
        await manager.loadData(forceReload: true)
        XCTAssertNil(manager.detail)
        XCTAssertNotNil(manager.error, "Not-found response must terminate the loading screen with feedback")
    }
}

@MainActor
final class EditorEdgeCaseTests: XCTestCase {
    func testColorHexHandlesGrayscaleAndTransparency() {
        XCTAssertEqual(Color(nsColor: NSColor(calibratedWhite: 1, alpha: 1)).hex(), "#FFFFFFFF")
        XCTAssertEqual(Color(nsColor: NSColor(calibratedWhite: 0, alpha: 1)).hex(), "#FF000000")
        XCTAssertNotEqual(Color.gray.hex(), "#FFFFFFFF", "System gray must resolve instead of silently becoming white")
        XCTAssertEqual(Color(hex: "#00336699").hex(), "#00336699")
        XCTAssertEqual(Color(hex: "#80336699").hex(), "#80336699")
    }

    func testClearingCategoryClearsTagsAndCreationCategory() async throws {
        let client = ApolloClient(networkTransport: EditorTestTransport(), store: ApolloStore())
        let manager = TagsEditor.Manager(client: client)
        manager.setCategory(TagCategory(id: "category-1", name: "Origin"))
        for _ in 0..<200 where manager.tags.isEmpty {
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        XCTAssertEqual(manager.tags.count, 1)
        manager.setCategory(nil)
        XCTAssertNil(manager.category)
        XCTAssertEqual(manager.model.category, "")
        XCTAssertTrue(manager.tags.isEmpty)
        XCTAssertNil(manager.error)
    }

    func testDraftDescriptionGenerationUsesNetworkAndFinishes() async {
        let transport = EditorTestTransport(description: "Generated locally")
        let client = ApolloClient(networkTransport: transport, store: ApolloStore())
        let manager = DetailManager("", client: client)
        let text = await manager.generateDescription(name: "Draft coffee")
        XCTAssertEqual(text, "Generated locally")
        XCTAssertFalse(manager.isGenerating)
        XCTAssertNil(manager.error)
        XCTAssertEqual(transport.recordedOperations.filter { $0 == "descGen" }.count, 1)
        XCTAssertTrue(manager.id.isEmpty)
    }

    func testEmptyDescriptionGenerationFinishesWithVisibleError() async {
        let client = ApolloClient(networkTransport: EditorTestTransport(), store: ApolloStore())
        let manager = DetailManager("", client: client)
        let text = await manager.generateDescription(name: "Draft coffee")
        XCTAssertNil(text)
        XCTAssertFalse(manager.isGenerating)
        XCTAssertNotNil(manager.error)
    }

    func testColdLoadTransportFailureTerminatesLoadingAndCanRetry() async {
        let client = ApolloClient(networkTransport: EditorTestTransport(), store: ApolloStore())
        let manager = DetailManager("broken", client: client)
        await manager.loadData(forceReload: true)
        XCTAssertFalse(manager.isLoading)
        XCTAssertTrue(manager.loadFailed)
        XCTAssertNotNil(manager.error)
        await manager.loadData(forceReload: true)
        XCTAssertFalse(manager.isLoading)
        XCTAssertFalse(manager.loadFailed)
        XCTAssertEqual(manager.detail?.ID, "broken")
        XCTAssertNil(manager.error)
    }
}

@MainActor
final class EditorFailurePathTests: XCTestCase {
    func testDescriptionTransportFailureFinishesWithVisibleError() async {
        let client = ApolloClient(networkTransport: EditorTestTransport(descriptionFailure: .transport), store: ApolloStore())
        let manager = DetailManager("", client: client)
        let description = await manager.generateDescription(name: "Draft")
        XCTAssertNil(description)
        XCTAssertFalse(manager.isGenerating)
        XCTAssertNotNil(manager.error)
    }

    func testDescriptionGraphQLFailureFinishesWithVisibleError() async {
        let client = ApolloClient(networkTransport: EditorTestTransport(descriptionFailure: .graphQL), store: ApolloStore())
        let manager = DetailManager("", client: client)
        let description = await manager.generateDescription(name: "Draft")
        XCTAssertNil(description)
        XCTAssertFalse(manager.isGenerating)
        XCTAssertNotNil(manager.error)
    }

    func testTagGraphQLFailuresKeepDisplayedTagsAndShowErrors() async {
        let client = ApolloClient(networkTransport: EditorTestTransport(failure: .graphQL), store: ApolloStore())
        let detail = DetailManager("tea-1", client: client)
        await detail.loadData(forceReload: true)
        guard let tag = detail.detail?.tags.first else { return XCTFail("Missing fixture tag") }
        await detail.tagsManager.removeTag(tag)
        XCTAssertNotNil(detail.tagsManager.error)
        XCTAssertEqual(detail.detail?.tags.count, 1)
        XCTAssertFalse(detail.tagsManager.isMutating)
        detail.tagsManager.error = nil
        await detail.tagsManager.addTag(tag)
        XCTAssertNotNil(detail.tagsManager.error)
        XCTAssertEqual(detail.detail?.tags.count, 1)
        XCTAssertFalse(detail.tagsManager.isMutating)
    }

    func testDeleteGraphQLFailurePreservesEditableRecord() async {
        let client = ApolloClient(networkTransport: EditorTestTransport(failure: .graphQL), store: ApolloStore())
        let manager = DetailManager("tea-1", client: client)
        await manager.loadData(forceReload: true)
        do {
            try await manager.delete()
            XCTFail("Rejected deletion must throw")
        } catch {}
        XCTAssertNotNil(manager.error)
        XCTAssertFalse(manager.deleted)
        XCTAssertFalse(manager.isDeleting)
        XCTAssertEqual(manager.detail?.ID, "tea-1")
    }

    func testAddingTagRefreshesDisplayedRecord() async throws {
        let client = ApolloClient(networkTransport: EditorTestTransport(), store: ApolloStore())
        let detail = DetailManager("tea-1", client: client)
        await detail.loadData(forceReload: true)
        let tag = try XCTUnwrap(detail.detail?.tags.first)
        await detail.tagsManager.removeTag(tag)
        XCTAssertEqual(detail.detail?.tags.count, 0)
        await detail.tagsManager.addTag(tag)
        XCTAssertEqual(detail.detail?.tags.map(\.id), ["tag-1"])
        XCTAssertNil(detail.tagsManager.error)
    }
}
