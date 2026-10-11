// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct UpdateTagMutation: GraphQLMutation {
  public static let operationName: String = "updateTag"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation updateTag($id: ID!, $name: String!, $color: String!) { updateTag(id: $id, name: $name, color: $color) { __typename id name color } }"#
    ))

  public var id: ID
  public var name: String
  public var color: String

  public init(
    id: ID,
    name: String,
    color: String
  ) {
    self.id = id
    self.name = name
    self.color = color
  }

  @_spi(Unsafe) public var __variables: Variables? { [
    "id": id,
    "name": name,
    "color": color
  ] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("updateTag", UpdateTag.self, arguments: [
        "id": .variable("id"),
        "name": .variable("name"),
        "color": .variable("color")
      ]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateTagMutation.Data.self
    ] }

    public var updateTag: UpdateTag { __data["updateTag"] }

    /// UpdateTag
    ///
    /// Parent Type: `Tag`
    nonisolated public struct UpdateTag: TeaElephantSchema.SelectionSet {
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
        UpdateTagMutation.Data.UpdateTag.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var color: String { __data["color"] }
    }
  }
}
