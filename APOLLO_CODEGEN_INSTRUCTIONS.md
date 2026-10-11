# Apollo code generation

The editor uses Apollo iOS 2.4.0 and the matching CLI. The repository's
`apollo-ios-cli` wrapper downloads the pinned official release, checks its
SHA-256, and caches the executable under `.build/apollo-cli/2.4.0`.

Generate Swift operations from the committed schema snapshot:

```sh
./apollo-ios-cli generate --path TeaElephantEditor/apollo-codegen-config.json
```

Generated operations are committed under
`TeaElephantEditor/api/schema/Sources/Operations/`. The generated package pins
Apollo to exactly 2.4.0.

Tag and category operations include:

- `UpdateTagMutation.graphql.swift`
- `DeleteTagMutation.graphql.swift`
- `UpdateTagCategoryMutation.graphql.swift`
- `DeleteTagCategoryMutation.graphql.swift`

After regeneration, inspect the diff and run the unit suite:

```sh
git diff -- TeaElephantEditor/api/schema
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditorTests \
  -destination 'platform=macOS' test
```

Add `--fetch-schema` only when the configured backend is available and a schema
refresh is intended. The SDK update uses the committed schema and GraphQL
operations. See [dependency maintenance](docs/DEPENDENCIES.md) for package
versions and the local build workflow.
