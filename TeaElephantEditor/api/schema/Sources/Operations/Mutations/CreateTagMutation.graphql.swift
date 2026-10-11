// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CreateTagMutation: GraphQLMutation {
  public static let operationName: String = "createTag"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation createTag($name: String!, $color: String!, $category: ID!) { createTag(name: $name, color: $color, category: $category) { __typename id name color } }"#
    ))

  public var name: String
  public var color: String
  public var category: ID

  public init(
    name: String,
    color: String,
    category: ID
  ) {
    self.name = name
    self.color = color
    self.category = category
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "name": name,
    "color": color,
    "category": category
  ] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("createTag", CreateTag.self, arguments: [
        "name": .variable("name"),
        "color": .variable("color"),
        "category": .variable("category")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CreateTagMutation.Data.self
    ] }

    public var createTag: CreateTag { __data["createTag"] }

    /// CreateTag
    ///
    /// Parent Type: `Tag`
    nonisolated public struct CreateTag: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tag }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("color", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CreateTagMutation.Data.CreateTag.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var color: String { __data["color"] }
    }
  }
}
