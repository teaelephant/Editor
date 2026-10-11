// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct ListQuery: GraphQLQuery {
  public static let operationName: String = "list"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query list { teas { __typename id name type tags { __typename id color } } }"#
    ))

  public init() {}

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("teas", [Tea].self),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      ListQuery.Data.self
    ] }

    /// Get information about teas.
    public var teas: [Tea] { __data["teas"] }

    /// Tea
    ///
    /// Parent Type: `Tea`
    nonisolated public struct Tea: TeaElephantSchema.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tea }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", TeaElephantSchema.ID.self),
        .field("name", String.self),
        .field("type", GraphQLEnum<TeaElephantSchema.Type_Enum>.self),
        .field("tags", [Tag].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ListQuery.Data.Tea.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var type: GraphQLEnum<TeaElephantSchema.Type_Enum> { __data["type"] }
      public var tags: [Tag] { __data["tags"] }

      /// Tea.Tag
      ///
      /// Parent Type: `Tag`
      nonisolated public struct Tag: TeaElephantSchema.SelectionSet {
        @_spi(Unsafe) public let __data: DataDict
        @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

        @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Tag }
        @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", TeaElephantSchema.ID.self),
          .field("color", String.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ListQuery.Data.Tea.Tag.self
        ] }

        public var id: TeaElephantSchema.ID { __data["id"] }
        public var color: String { __data["color"] }
      }
    }
  }
}
