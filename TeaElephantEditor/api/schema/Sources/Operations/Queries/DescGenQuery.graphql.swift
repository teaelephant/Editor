// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DescGenQuery: GraphQLQuery {
  public static let operationName: String = "descGen"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query descGen($name: String!) { generateDescription(name: $name) }"#
    ))

  public var name: String

  public init(name: String) {
    self.name = name
  }

  public var __variables: Variables? { ["name": name] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("generateDescription", String.self, arguments: ["name": .variable("name")]),
    ] }

    /// Generate description for tea with ai.
    public var generateDescription: String { __data["generateDescription"] }
  }
}
