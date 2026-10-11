// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct DescGenQuery: GraphQLQuery {
  public static let operationName: String = "descGen"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query descGen($name: String!) { generateDescription(name: $name) }"#
    ))

  public var name: String

  public init(name: String) {
    self.name = name
  }

  @_spi(Unsafe) public var __variables: Variables? { ["name": name] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("generateDescription", String.self, arguments: ["name": .variable("name")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DescGenQuery.Data.self
    ] }

    /// Generate description for tea with ai.
    public var generateDescription: String { __data["generateDescription"] }
  }
}
