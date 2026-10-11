// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct GetQuery: GraphQLQuery {
  public static let operationName: String = "get"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query get($id: ID!) { tea(id: $id) { __typename id name description type tags { __typename id name color category { __typename id name } } } }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  @_spi(Unsafe) public var __variables: Variables? { ["id": id] }

  nonisolated public struct Data: TeaElephantSchema.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("tea", Tea?.self, arguments: ["id": .variable("id")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      GetQuery.Data.self
    ] }

    /// Get information about tea by id.
    public var tea: Tea? { __data["tea"] }

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
        .field("description", String.self),
        .field("type", GraphQLEnum<TeaElephantSchema.Type_Enum>.self),
        .field("tags", [Tag].self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetQuery.Data.Tea.self
      ] }

      public var id: TeaElephantSchema.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var description: String { __data["description"] }
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
          .field("name", String.self),
          .field("color", String.self),
          .field("category", Category.self),
        ] }
        @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetQuery.Data.Tea.Tag.self
        ] }

        public var id: TeaElephantSchema.ID { __data["id"] }
        public var name: String { __data["name"] }
        public var color: String { __data["color"] }
        public var category: Category { __data["category"] }

        /// Tea.Tag.Category
        ///
        /// Parent Type: `TagCategory`
        nonisolated public struct Category: TeaElephantSchema.SelectionSet {
          @_spi(Unsafe) public let __data: DataDict
          @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

          @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { TeaElephantSchema.Objects.TagCategory }
          @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", TeaElephantSchema.ID.self),
            .field("name", String.self),
          ] }
          @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetQuery.Data.Tea.Tag.Category.self
          ] }

          public var id: TeaElephantSchema.ID { __data["id"] }
          public var name: String { __data["name"] }
        }
      }
    }
  }
}
