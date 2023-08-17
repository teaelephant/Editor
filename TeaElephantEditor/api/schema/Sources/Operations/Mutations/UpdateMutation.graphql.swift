// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateMutation: GraphQLMutation {
  public static let operationName: String = "update"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation update($id: ID!, $tea: TeaData!) { updateTea(id: $id, tea: $tea) { __typename id name description type } }"#
    ))

  public var id: ID
  public var tea: TeaData

  public init(
    id: ID,
    tea: TeaData
  ) {
    self.id = id
    self.tea = tea
  }

  public var __variables: Variables? { [
    "id": id,
    "tea": tea
  ] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateTea", UpdateTea.self, arguments: [
        "id": .variable("id"),
        "tea": .variable("tea")
      ]),
    ] }

    public var updateTea: UpdateTea { __data["updateTea"] }

    /// UpdateTea
    ///
    /// Parent Type: `Tea`
    public struct UpdateTea: TeaElephantSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Tea }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("description", String.self),
        .field("type", GraphQLEnum<TeaElephantSchema.Type_Enum>.self),
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var description: String { __data["description"] }
      public var type: GraphQLEnum<TeaElephantSchema.Type_Enum> { __data["type"] }
    }
  }
}
