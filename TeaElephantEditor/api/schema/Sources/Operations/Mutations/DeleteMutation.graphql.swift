// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DeleteMutation: GraphQLMutation {
  public static let operationName: String = "delete"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation delete($id: ID!) { deleteTea(id: $id) }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("deleteTea", TeaElephantSchema.ID.self, arguments: ["id": .variable("id")]),
    ] }

    public var deleteTea: TeaElephantSchema.ID { __data["deleteTea"] }
  }
}
