// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AddTagMutation: GraphQLMutation {
  public static let operationName: String = "addTag"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation addTag($tea: ID!, $tag: ID!) { addTagToTea(teaID: $tea, tagID: $tag) { __typename id } }"#
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
      .field("addTagToTea", AddTagToTea.self, arguments: [
        "teaID": .variable("tea"),
        "tagID": .variable("tag")
      ]),
    ] }

    public var addTagToTea: AddTagToTea { __data["addTagToTea"] }

    /// AddTagToTea
    ///
    /// Parent Type: `Tea`
    public struct AddTagToTea: TeaElephantSchema.SelectionSet {
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
