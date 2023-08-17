// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class OnDeleteSubscription: GraphQLSubscription {
  public static let operationName: String = "onDelete"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription onDelete { onDeleteTea }"#
    ))

  public init() {}

  public struct Data: TeaElephantSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { TeaElephantSchema.Objects.Subscription }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("onDeleteTea", TeaElephantSchema.ID.self),
    ] }

    public var onDeleteTea: TeaElephantSchema.ID { __data["onDeleteTea"] }
  }
}
