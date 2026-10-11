import Foundation
import Apollo
import ApolloAPI

struct AuthInterceptor: HTTPInterceptor {
    private let tokenProvider: @Sendable () -> String?

    init(tokenProvider: @escaping @Sendable () -> String? = { AdminAuth.generateAdminJWT() }) {
        self.tokenProvider = tokenProvider
    }

    func intercept(request: URLRequest, next: NextHTTPInterceptorFunction) async throws -> HTTPResponse {
        var request = request
        if let token = tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return try await next(request)
    }
}

struct AuthInterceptorProvider: InterceptorProvider {
    func httpInterceptors<Operation: GraphQLOperation>(for operation: Operation) -> [any HTTPInterceptor] {
        [AuthInterceptor()] + DefaultInterceptorProvider.shared.httpInterceptors(for: operation)
    }
}
