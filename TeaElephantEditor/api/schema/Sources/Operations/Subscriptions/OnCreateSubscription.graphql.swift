// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class OnCreateSubscription: GraphQLSubscription {
  public static let operationName: String = "onCreate"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription onCreate { onCreateTea { __typename id name type description } }"#
    ))

  public init() {}

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Subscription }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("onCreateTea", OnCreateTea.self),
    ] }

    public var onCreateTea: OnCreateTea { __data["onCreateTea"] }

    /// OnCreateTea
    ///
    /// Parent Type: `Tea`
    public struct OnCreateTea: TeaElephantSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Tea }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("type", GraphQLEnum<TeaElephantSchema.Type_Enum>.self),
        .field("description", String.self),
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var type: GraphQLEnum<TeaElephantSchema.Type_Enum> { __data["type"] }
      public var description: String { __data["description"] }
    }
  }
}
