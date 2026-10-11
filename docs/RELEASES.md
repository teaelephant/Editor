# Editor releases

Use the `TeaElephantEditor` scheme to distribute the macOS application through
TestFlight. Its bundle ID is `xax.TeaElephantEditor`.

Before archiving, increment the build number in both application build
configurations and run the unit suite:

```sh
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditorTests \
  -destination 'platform=macOS' test
```

Build a universal Release archive with the existing Xcode developer account:

```sh
xcodebuild -workspace TeaElephantEditor.xcworkspace -scheme TeaElephantEditor \
  -configuration Release -destination 'generic/platform=macOS' \
  -archivePath .build/TeaElephantEditor.xcarchive -allowProvisioningUpdates archive
```

After publishing the validated source revision, upload the archive:

```sh
xcodebuild -exportArchive -archivePath .build/TeaElephantEditor.xcarchive \
  -exportOptionsPlist ci/testflight-exportoptions.plist \
  -exportPath .build/testflight -allowProvisioningUpdates
```

An App Store Connect app record for this bundle ID must exist before upload.
Confirm Apple has processed the build under the app's TestFlight tab. An
accepted upload alone does not confirm the build is available to testers.

`ITSAppUsesNonExemptEncryption` is false: authentication uses system CryptoKit
signing, and HTTPS/WebSocket security uses the operating system's networking
implementation. Reassess this declaration if the app adds encryption outside
these uses. See [Apple’s export compliance guidance](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations).
