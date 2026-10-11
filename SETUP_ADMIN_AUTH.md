# Editor admin authentication

Editor uses a dedicated ECDSA P-256 key to authorize catalogue administration.
The private key stays on the Mac; the backend verifies JWTs with the matching
public key. A mobile user's Apple sign-in token does not grant admin access.

Building the app and running the injected unit tests do not require this key.
A new TestFlight installation is not automatically provisioned with one.

## Backend prerequisite

Have an authorized operator generate or provide the admin keypair and configure
the server's `ADMIN_PUBLIC_KEY_PATH`. The backend's
[key setup guide](https://github.com/teaelephant/TeaElephantMemory/blob/master/docs/ADMIN_KEYS_SETUP.md)
describes that side of provisioning. Use the public key corresponding to the
existing private key; deploying an unrelated new public key will invalidate
the currently provisioned clients.

Keep the PEM private key outside the repository and app bundle. Do not paste
it into source, build settings, command arguments, logs or issue reports.

## Keychain contract

The current loader in
[AdminAuth.swift](TeaElephantEditor/AdminAuth.swift) queries this item:

| Property | Required representation |
| --- | --- |
| Keychain class | `kSecClassGenericPassword` |
| Label | `com.teaelephant.editor.adminkey` |
| Value data | Raw bytes of `P256.Signing.PrivateKey.x963Representation` |
| App access group | `$(AppIdentifierPrefix)com.teaelephant.editor`, declared in the app entitlements |

The loader reconstructs the key with
`P256.Signing.PrivateKey(x963Representation:)`. A PEM string, a base64-encoded
string or an imported `kSecClassKey` object is not the expected value.

Provision this binary generic-password item through a trusted, appropriately
signed setup tool or local debug provisioning that can access the app's
Keychain group. When converting an existing P-256 PEM with CryptoKit, the value
to store is:

```swift
let key = try P256.Signing.PrivateKey(pemRepresentation: privateKeyPEM)
let valueData = key.x963Representation
```

The code above describes conversion only; it does not install the item. The app
currently has no provisioning screen or supported standalone setup command.
Use the maintainer's provisioning process for a fresh Mac and confirm that
`AdminAuth.loadPrivateKeyFromKeychain()` succeeds from the signed app without
printing the returned key.

### Limitation of the legacy importer

`AdminAuth.importPrivateKeyFromPEM` writes a `kSecClassKey` item, while
`loadPrivateKeyFromKeychain` reads a `kSecClassGenericPassword` item. They do
not currently form a working import/load round trip. Likewise, `security
import` or importing a PEM through Keychain Access only creates a key object;
changing its label does not convert it to the binary password item above.

Do not use the old importer as a fresh-install setup recipe or grant all
applications access to a private key. Provision only the intended editor or
setup tool. This guide documents the current implementation; it does not
change the app's import code.

## Request flow

1. `AdminAuth.generateAdminJWT()` loads the Keychain value and signs a JWT with
   ES256 and a raw `R || S` signature.
2. `AuthInterceptor` adds `Authorization: Bearer <jwt>` to HTTP requests when
   generation succeeds.
3. `Network` includes the JWT under `Authorization` in the WebSocket
   `connection_init` payload when creating the subscription transport.
4. The backend validates the token and enforces administration privileges for
   protected mutations.

The current JWT contains `admin=true`, issuer `TeaElephantEditor`, audience
`tea-elephant-api`, issuance time, a not-before time 60 seconds earlier,
24-hour expiry and a UUID `jti`. Its header contains `alg=ES256` and `typ=JWT`;
it **omits `kid`** and therefore depends on the backend's default admin key.

HTTP generates a token per intercepted request. The WebSocket payload is
created with its transport; do not assume that reconnecting automatically
generates a new token after expiry or key rotation. Restart/recreate the
transport after provisioning changes and validate subscriptions separately.

## Verification and troubleshooting

Use a controlled backend for a create/update/delete smoke test, with a known
disposable entry. Check both an HTTP mutation and a live subscription. Success
in the unit suite verifies the injected transport path, not live Keychain or
server access.

| Symptom | Check |
| --- | --- |
| `Failed to load private key from Keychain` or `-25300` | The item exists in the generic-password class, has the exact label and is visible to the signed app |
| `-34018` | Signing entitlements and Keychain access-group prefix match the provisioned item |
| Invalid key data | Value data is raw P-256 X9.63 private-key bytes, not PEM/base64 text |
| Admin mutation rejected | Matching server public key, default key selection, JWT claims and system clock |
| Reads work but writes fail | Public catalogue reads do not prove administrative authorization |
| Subscription authorization fails after a change | Recreate the WebSocket transport and verify its current token separately |

For rotation, coordinate client provisioning and backend verification before
replacing the default key. The current client does not select a versioned
`kid`; changing that strategy requires a reviewed client/server code change.
