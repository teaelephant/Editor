//
//  ApolloClientExtension.swift
//  ApolloClientExtension
//
//  Created by Andrew Khasanov on 29.08.2021.
//

import Foundation
import Apollo
import TeaElephantSchema

@available(macOS 12.0.0, *)
extension ApolloClient {
    public func fetchAsync<Query: GraphQLQuery>(query: Query,cachePolicy: CachePolicy = .default,contextIdentifier: UUID? = nil) async -> Result<GraphQLResult<Query.Data>, Error> {
        await withCheckedContinuation{ continuation in
            self.fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: .global(qos: .background)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func performAsync<Mutation: GraphQLMutation>(mutation: Mutation, publishResultToStore: Bool = true, queue: DispatchQueue = .main) async -> Result<GraphQLResult<Mutation.Data>, Error> {
        await withCheckedContinuation{ continuation in
            self.perform(mutation: mutation, publishResultToStore: publishResultToStore, queue: queue) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
