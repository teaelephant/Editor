//
//  Network.swift
//  TeaElephantEditor
//
//  Created by Andrew Khasanov on 16.01.2021.
//

import Foundation
import Apollo
import ApolloWebSocket

@MainActor
class Network {
    static let shared = Network()

    private(set) lazy var store = ApolloStore()

    /// A web socket transport to use for subscriptions
    private lazy var webSocketTransport: WebSocketTransport = {
        WebSocketTransport(
            urlSession: URLSession.shared,
            store: store,
            endpointURL: URL(string: "wss://tea-elephant.com/v2/query")!,
            configuration: .init(
                reconnectionInterval: 0.5,
                connectingPayload: AdminAuth.generateAdminJWT().map { ["Authorization": "Bearer \($0)"] }
            )
        )
    }()

    /// An HTTP transport to use for queries and mutations
    private lazy var normalTransport: RequestChainNetworkTransport = {
        let url = URL(string: "https://tea-elephant.com/v2/query")!
        return RequestChainNetworkTransport(
            urlSession: URLSession.shared,
            interceptorProvider: AuthInterceptorProvider(),
            store: store,
            endpointURL: url
        )
    }()

    /// A split network transport to allow the use of both of the above
    /// transports through a single `NetworkTransport` instance.
    private lazy var splitNetworkTransport = SplitNetworkTransport(
            queryTransport: normalTransport,
            mutationTransport: normalTransport,
            subscriptionTransport: webSocketTransport
    )

    private(set) lazy var apollo = ApolloClient(networkTransport: splitNetworkTransport, store: store)
}
