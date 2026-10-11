# Dependency maintenance

The dependency audit on 2026-10-11 uses stable upstream tags:

| Package | Version |
| --- | --- |
| Apollo iOS and Apollo CLI | 2.4.0 |
| Regex | 1.2.0 |

The generated schema package pins Apollo to exactly 2.4.0. Apollo 2.4 requires Swift 6.1 or newer and macOS 12 or newer. The app's existing deployment settings are retained.

`apollo-ios-cli` installs the pinned official release into `.build/apollo-cli/2.4.0`, verifies the archive's SHA-256, and reuses the local executable. Set `APOLLO_CLI_CACHE_DIR` to use another cache directory.

Generate from the committed schema snapshot:

```sh
./apollo-ios-cli generate --path TeaElephantEditor/apollo-codegen-config.json
```

Add `--fetch-schema` only when the configured local backend is running and an intentional schema refresh is required. Existing GraphQL operations, including tag/category mutations, are preserved during SDK regeneration.

Build and run the unit suite through the dedicated shared test scheme:

```sh
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditorTests \
  -destination 'platform=macOS' test
```

UI tests use the existing separate target and are not included in this unit-test scheme.

The shared `TeaElephantEditor` application scheme supports reproducible builds
without personal Xcode settings. Build and launch locally with:

```sh
./script/build_and_run.sh --verify
```

The Codex Run action uses the same script. It supports `--debug`, `--logs`, and
`--telemetry`; `EDITOR_CONFIGURATION` selects Debug or Release,
`EDITOR_DERIVED_DATA` changes the build directory, and
`EDITOR_SOURCE_PACKAGES_DIR` reuses a resolved package cache. All workspace
lockfiles contain the current Apollo and Regex dependency graph.

HTTP requests retain admin JWT authorization from the existing Keychain provider. WebSocket authorization is included in `connection_init`; queries and mutations use HTTP and subscriptions use WebSocket. Network callbacks update UI state on MainActor, and cancelling a task stops its subscription.
