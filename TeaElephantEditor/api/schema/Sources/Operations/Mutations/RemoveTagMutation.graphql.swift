// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RemoveTagMutation: GraphQLMutation {
  public static let operationName: String = "removeTag"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation removeTag($tea: ID!, $tag: ID!) { deleteTagFromTea(teaID: $tea, tagID: $tag) { __typename id } }"#
    ))

  public var tea: ID
  public var tag: ID

  public init(
    tea: ID,
    tag: ID
  ) {
    self.tea = tea
    self.tag = tag
  }

  public var __variables: Variables? { [
    "tea": tea,
    "tag": tag
  ] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("deleteTagFromTea", DeleteTagFromTea.self, arguments: [
        "teaID": .variable("tea"),
        "tagID": .variable("tag")
      ]),
    ] }

    public var deleteTagFromTea: DeleteTagFromTea { __data["deleteTagFromTea"] }

    /// DeleteTagFromTea
    ///
    /// Parent Type: `Tea`
    public struct DeleteTagFromTea: TeaElephantSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Tea }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
    }
  }
}
