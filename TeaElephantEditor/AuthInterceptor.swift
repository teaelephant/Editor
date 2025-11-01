//
//  AuthInterceptor.swift
//  TeaElephantEditor
//
//  Custom Apollo interceptor to add admin JWT to requests
//

import Foundation
import Apollo
import ApolloAPI

class AuthInterceptor: ApolloInterceptor {
    var id: String = "AuthInterceptor"

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        // Generate admin JWT
        if let jwt = AdminAuth.generateAdminJWT() {
            request.addHeader(name: "Authorization", value: "Bearer \(jwt)")
        } else {
            print("Warning: Failed to generate admin JWT, proceeding without authentication")
        }

        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion
        )
    }
}

// Custom interceptor provider that includes our AuthInterceptor
class AuthInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)

        // Insert our AuthInterceptor before the network request interceptor
        // The default interceptors include CacheReadInterceptor, NetworkFetchInterceptor, etc.
        // We want to add headers before the network request is made
        if let networkFetchIndex = interceptors.firstIndex(where: { $0 is NetworkFetchInterceptor }) {
            interceptors.insert(AuthInterceptor(), at: networkFetchIndex)
        } else {
            // If we can't find NetworkFetchInterceptor, just prepend it
            interceptors.insert(AuthInterceptor(), at: 0)
        }

        return interceptors
    }
}
