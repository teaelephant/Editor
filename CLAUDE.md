# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TeaElephantEditor is a macOS SwiftUI application for managing tea, coffee, and herb records. It connects to a GraphQL backend at tea-elephant.com for CRUD operations, real-time subscriptions, and AI-powered description generation.

## Build and Run

Use the shared application scheme in the workspace. The local entrypoint builds and launches the app:

```bash
# Open in Xcode
open TeaElephantEditor.xcworkspace

# Or build from command line
./script/build_and_run.sh --verify

# Run tests
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditorTests \
  -destination 'platform=macOS' test
```

## GraphQL Code Generation

The project uses Apollo iOS 2.4.0 and its matching CLI for GraphQL operations. Generated Swift code is in `TeaElephantEditor/api/schema/Sources/`.

To regenerate GraphQL code after schema changes:

```bash
# The wrapper downloads and verifies the pinned CLI release when needed.
./apollo-ios-cli generate --path TeaElephantEditor/apollo-codegen-config.json
```

GraphQL files are organized as:
- `TeaElephantEditor/api/queries/*.graphql` - Query operations
- `TeaElephantEditor/api/mutations/*.graphql` - Mutation operations
- `TeaElephantEditor/api/subscriptions/*.graphql` - Subscription operations
- `TeaElephantEditor/api/schema.json` - Committed GraphQL schema snapshot

## Architecture

### Network Layer

The app uses a singleton `Network` class (Network.swift:12) with:
- HTTP transport for queries/mutations via `RequestChainNetworkTransport`
- WebSocket transport for real-time subscriptions via `WebSocketTransport`
- `SplitNetworkTransport` combining both transports
- Apollo client with local cache via `ApolloStore`

Base URLs:
- GraphQL HTTP: `https://tea-elephant.com/v2/query`
- GraphQL WebSocket: `wss://tea-elephant.com/v2/query`

### Apollo Extensions

`ApolloClientExtension.swift` provides async/await wrappers:
- `fetchAsync()` - Returns `AsyncThrowingStream<GraphQLResponse<Query>, Error>` with `FetchBehavior` support
- `performAsync()` - Returns async `Result` containing a typed mutation response
- `subscribeAsync()` - Returns a cancellable task and delivers subscription responses on MainActor

### Manager Pattern

The app follows a Manager/Controller/View pattern with ObservableObject managers:

**ListManager** (TeaElephantEditor/Managers/List.swift:16)
- Manages the tea list with `@Published var list: [TeaListElement]`
- `loadData()` fetches teas via `ListQuery`
- `subscribeOnChange()` sets up three subscriptions (onCreate, onUpdate, onDelete) for real-time updates
- Updates list in-place when subscriptions fire

**DetailManager** (TeaElephantEditor/Managers/DetailManager.swift:14)
- Manages individual tea details with `@Published var detail: TeaDataWithID?`
- `loadData()` fetches tea via `GetQuery(id:)`
- `update()` performs `UpdateMutation`
- `create()` performs `CreateMutation`
- `delete()` performs `DeleteMutation`
- Shows saved state via `@Published var saved: Bool`

**TagsEditor.Manager** (TeaElephantEditor/TagsEditor/Manager.swift:11)
- Manages tags filtered by category
- `loadData()` fetches tags via `TagsQuery(name:category:)`
- `createTag()` creates new tags with color
- Tag colors are stored as hex strings

**TagsEditor.CategoryManager** (TeaElephantEditor/TagsEditor/Manager.swift:73)
- Manages tag categories
- `loadData()` fetches via `TagCategoriesQuery(name:)`
- `createCategory()` creates new categories

### Data Models

**TeaDataWithID** (TeaElephantEditor/Models/TeaInfo.swift:17)
- Full tea record with ID, name, type, description, tags

**TeaListElement** (TeaElephantEditor/Models/TeaInfo.swift:25)
- Lightweight list item with ID, name, type, tags (minimal tag data)

**TeaType enum** (TeaElephantEditor/Models/TeaInfo.swift:10)
- Enum matching GraphQL Type: tea, coffee, herb, other

**Tag** (TeaElephantEditor/Models/Tag.swift)
- Full tag with id, name, color (hex), category

### View Architecture

**Table** (TeaElephantEditor/Views/Table.swift:11)
- Main list view using `ListManager`
- NavigationView with links to DetailController for each tea
- Refresh button calls `loadData(forceReload: true)`
- Plus button navigates to `DetailController(id: "")` for new teas
- Link to TagsEditor.Controller

**DetailController** (TeaElephantEditor/Controllers/Detail.swift:8)
- Controller wrapping Detail view
- Creates `DetailManager(id)`
- Handles empty id ("") as create mode, non-empty as edit mode
- Shows ProgressView while loading

**Detail** (TeaElephantEditor/Views/DetailView.swift:12)
- Form for editing tea: name, type, description, tags
- "Generate description" button calls AI generation via `TagsSelectManager.generateDescription(name:)` which uses `DescGenQuery`
- Save button calls `update()` callback, shows checkmark animation on success
- Delete button calls `delete()` callback

**TagsEditor.Controller/View** (TeaElephantEditor/TagsEditor/)
- Separate editor for managing tags and categories
- Uses TagsEditor.Manager and CategoryManager

### AI Description Generation

The app includes AI-powered description generation:
- Query: `descGen(name:String!): String` (TeaElephantEditor/api/queries/descGen.graphql)
- Called from Detail view when user clicks "Generate description"
- Managed by `TagsSelectManager.generateDescription(name:)`
- Shows loading state while generating

## Important Notes

- Minimum app deployment target: macOS 26.6; Apollo itself supports macOS 12 or newer
- GraphQL operations are strongly typed via Apollo codegen
- Real-time updates happen automatically via WebSocket subscriptions
- Fetch behavior is `.CacheFirst` by default, `.NetworkOnly` for force reload, or `.CacheAndNetwork` for cached and refreshed responses
- Perform updates to published UI state on MainActor
