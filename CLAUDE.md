# Editor development guidance

Start with [README.md](README.md) for product scope, setup, source layout and
commands. This is the macOS administrative client; the iOS app and Go backend
are separate repositories.

## Build and verification

Use `TeaElephantEditor.xcworkspace` and the shared `TeaElephantEditor` scheme.
The app's deployment target is macOS 26.6. Apollo's generated package requires
a Swift 6.1+ compiler; the app currently uses Swift 5 language mode.

```sh
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditor \
  -configuration Debug -destination "platform=macOS,arch=$(uname -m)" \
  -derivedDataPath .build/DerivedData build
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditorTests \
  -destination "platform=macOS,arch=$(uname -m)" test
```

`script/build_and_run.sh` stops every process named `TeaElephantEditor` before
building. Preserve the user's running app and unsaved state: prefer a separate
build and launch by exact bundle path when an existing session must stay open.
The unit scheme excludes the separate UI-test target.

## Architecture and behaviour to preserve

- `Table` owns `ListManager`; `DetailController` owns `DetailManager` with
  `@StateObject`. Form fields belong to `Detail` view state.
- `DetailManager.save` creates a draft once, adopts the returned ID, then
  updates that ID on subsequent saves. It owns description generation and its
  loading/error state, including generation for unsaved drafts.
- `TagsSelectManager` performs tag assignment/removal and triggers a detail
  refresh. Read the displayed tags from the refreshed detail; preserve edited
  form fields during that refresh.
- `ListManager` handles five subscriptions: create, update, delete, tag add and
  tag remove. Preserve the actual drink type and tag colours. Late update/tag
  events must not restore deleted rows or overwrite newer unrelated fields.
- `TagsEditor.Controller` owns stable managers. Search tasks are cancellable
  and discard stale results; clearing category selection clears both displayed
  tags and the category used for creation.
- Managers publish on `MainActor` and accept an optional Apollo client for
  injection. Keep network errors visible; only validated successful responses
  may set saved state or complete an operation.

## Network and GraphQL

`Network.swift` defines HTTP `https://tea-elephant.com/v2/query` and WebSocket
`wss://tea-elephant.com/v2/query`. HTTP uses `RequestChainNetworkTransport`;
subscriptions use `WebSocketTransport`, combined with `SplitNetworkTransport`.
Apollo stores its normalised cache in memory. Use `.CacheFirst` for normal
loads and `.NetworkOnly` for explicit refreshes and description generation.

`ApolloClientExtension.swift` supplies fetch/mutation/subscription adapters and
`validatedData()`. Check GraphQL errors as well as transport failures. Do not
infer success merely from a response's non-nil data. Cancel subscriptions when
their owner is released.

The codegen JSON's localhost endpoint is for schema introspection, not runtime
configuration. Regenerate after operation/schema changes:

```sh
./apollo-ios-cli generate --path TeaElephantEditor/apollo-codegen-config.json
git diff -- TeaElephantEditor/api/schema
```

Apollo and its CLI are pinned to 2.4.0. Generated sources live in
`TeaElephantEditor/api/schema/Sources`. Keep operation paths explicit in the
configuration so generation also works inside ignored worktree directories.
See [codegen instructions](APOLLO_CODEGEN_INSTRUCTIONS.md) and
[dependency maintenance](docs/DEPENDENCIES.md).

## Authentication and test boundaries

`AdminAuth` signs ES256 JWTs from a Keychain private key. HTTP requests carry a
Bearer token; WebSocket authorization belongs to `connection_init`. Follow
[SETUP_ADMIN_AUTH.md](SETUP_ADMIN_AUTH.md) for the actual storage contract and
the limitations of the legacy import helper.

Use `EditorTestTransport` for manager regression tests. Avoid changing
production transports to mocks. UI writes need an isolated fixture or a
controlled backend; a successful build is not a live smoke test. Never log or
commit private keys or JWTs.

For distribution, follow [release instructions](docs/RELEASES.md). Keep source
publication, successful upload, Apple processing and tester access as separate
verified steps.
