# Admin Authentication Setup Guide

This guide walks you through setting up admin authentication for TeaElephantEditor.

## Overview

The client has been configured to:
1. Load admin private key from macOS Keychain
2. Generate JWT tokens with proper claims (iss, aud, iat, nbf, exp, jti, admin, kid)
3. Automatically add `Authorization: Bearer <jwt>` header to all GraphQL requests
4. Support both HTTP (queries/mutations) and WebSocket (subscriptions) authentication

## One-Time Setup: Import Private Key to Keychain

### Prerequisites

You should have already:
1. Generated the admin key pair on the server side (see `ADMIN_AUTH.md`)
2. Deployed the server with the admin public key
3. Saved `admin_private_key.pem` securely (never commit to git!)

### Option 1: Using Security Command Line Tool (Recommended)

```bash
# Import the private key into your login keychain
security import /path/to/admin_private_key.pem \
  -k ~/Library/Keychains/login.keychain-db \
  -T /Applications/TeaElephantEditor.app \
  -T /usr/bin/security

# Set the key to be accessible without prompting
# Find the key first
security find-key -a "com.teaelephant.editor.adminkey"

# Or use Keychain Access.app to set access control
open -a "Keychain Access"
# Then search for "com.teaelephant.editor.adminkey"
# Double-click → Access Control → Select "Allow all applications to access this item"
```

### Option 2: Programmatic Import (From the App)

You can also add a one-time setup function in your app. Add this to your app initialization code:

```swift
// One-time setup - only run this once to import the key
func setupAdminKey() {
    guard let pemPath = Bundle.main.path(forResource: "admin_private_key", ofType: "pem"),
          let pemData = try? Data(contentsOf: URL(fileURLWithPath: pemPath)) else {
        print("Could not load admin_private_key.pem from bundle")
        return
    }

    do {
        try AdminAuth.importPrivateKeyFromPEM(pemData: pemData)
        print("Admin key imported successfully!")
    } catch {
        print("Failed to import admin key: \(error)")
    }
}
```

**Important:** After importing, remove the PEM file from your app bundle to ensure it's not distributed!

### Option 3: Manual Import via Keychain Access

1. Open **Keychain Access.app**
2. Select **Login** keychain
3. Go to **File → Import Items...**
4. Select your `admin_private_key.pem` file
5. After import, find the key in the list (it may be named differently)
6. Right-click → Get Info
7. Set **Label** to: `com.teaelephant.editor.adminkey`
8. Go to **Access Control** tab
9. Select "Allow all applications to access this item" (or add TeaElephantEditor specifically)

## Verification

Once the key is imported, verify it works:

1. Build and run TeaElephantEditor
2. Check the console for any JWT generation errors
3. Try creating or updating a tea/tag (any admin mutation)
4. If you get authentication errors, check:
   - The key is properly imported (search in Keychain Access)
   - The key label matches exactly: `com.teaelephant.editor.adminkey`
   - The server has the corresponding public key configured
   - The server's `kid` in validation matches the client's `kid` in JWT header ("admin-key-v1")

## How It Works

### JWT Generation

The `AdminAuth` class:
1. Loads the ECDSA P-256 private key from Keychain
2. Creates JWT header with ES256 algorithm and key ID
3. Creates JWT claims with proper fields:
   - `admin: true` - marks this as an admin token
   - `iss: "TeaElephantEditor"` - issuer
   - `aud: "tea-elephant-api"` - audience
   - `iat` - issued at timestamp
   - `nbf` - not before (1 minute ago for clock skew)
   - `exp` - expires in 24 hours
   - `jti` - unique JWT ID (UUID)
4. Signs the JWT with the private key using SHA256
5. Returns base64URL-encoded JWT

### Request Flow

1. **HTTP Requests** (queries/mutations):
   - `AuthInterceptor` intercepts all Apollo requests
   - Calls `AdminAuth.generateAdminJWT()` to get fresh JWT
   - Adds `Authorization: Bearer <jwt>` header
   - Request proceeds to server

2. **WebSocket Connections** (subscriptions):
   - `Network.swift` generates JWT when creating WebSocket connection
   - Adds `Authorization: Bearer <jwt>` header to WebSocket handshake
   - Server validates JWT on connection establishment

### Server Validation

The server (see `ADMIN_AUTH.md` in server repo):
1. Receives request with JWT in Authorization header
2. Parses JWT and validates signature using admin public key
3. Validates algorithm (ES256 only), issuer, audience, expiration, etc.
4. Checks `admin: true` claim
5. If valid, sets `AdminPrincipal` in context
6. Resolvers check `RequireAdmin()` for protected operations

## Troubleshooting

### "Failed to load private key from Keychain"

- **Problem:** Key not found in Keychain
- **Solution:**
  - Check Keychain Access.app → Login → Keys
  - Search for "com.teaelephant.editor.adminkey"
  - If not found, import the key using one of the methods above

### "keychain lookup failed: -25300" (errSecItemNotFound)

- **Problem:** Key not found with specified label
- **Solution:**
  - The key might be imported with a different label
  - Find the key in Keychain Access and update its label to `com.teaelephant.editor.adminkey`

### "keychain lookup failed: -34018"

- **Problem:** Keychain access denied
- **Solution:**
  - Open Keychain Access
  - Find the key and double-click it
  - Go to Access Control tab
  - Add TeaElephantEditor.app or select "Allow all applications"

### Server returns "Admin authentication required" error

- **Problem:** JWT validation failed on server
- **Possible causes:**
  1. **Key mismatch:** Private key on client doesn't match public key on server
     - Regenerate both keys and deploy together
  2. **Clock skew:** Client and server times are off by more than 5 minutes
     - Check system time on both client and server
  3. **Expired token:** Token is older than 24 hours (unlikely since we generate fresh tokens)
  4. **Wrong kid:** Client sends "admin-key-v1" but server expects different key ID
     - Check server logs for which `kid` it's looking for
     - Update `AdminAuth.generateAdminJWT()` to use correct `kid`
  5. **Server not configured:** Public key not mounted or auth middleware not enabled
     - Check server deployment and logs

### JWT signature is invalid

- **Problem:** Signature verification fails
- **Possible causes:**
  1. Wrong hash algorithm - ensure we're using SHA256 (currently used in code)
  2. Wrong signature format - ensure we're using rawRepresentation (currently used)
  3. Key format mismatch - ensure P-256 curve is used on both sides

## Key Rotation

To rotate the admin key (e.g., if compromised):

1. Generate new key pair: `admin_private_key_v2.pem` and `admin_public_key_v2.pem`
2. Mount new public key on server (keep old one for transition period)
3. Update server to accept both `admin-key-v1` and `admin-key-v2` in `kid` header
4. Deploy server
5. Import new private key to Keychain (can coexist with old key using different labels)
6. Update `AdminAuth.generateAdminJWT()` to use `"admin-key-v2"` in header
7. Test with new key
8. After grace period (e.g., 30 days), remove old key from server

## Security Notes

- ✅ Private key is stored in macOS Keychain (encrypted by OS)
- ✅ JWT tokens expire after 24 hours (auto-regenerated on each request)
- ✅ Tokens include `jti` for future revocation support
- ✅ Signature uses ECDSA P-256 (ES256) - industry standard
- ✅ Server validates issuer, audience, expiration, and not-before claims
- ❌ **Never** commit `admin_private_key.pem` to version control
- ❌ **Never** hardcode the private key in source code
- ❌ **Never** share the private key via insecure channels (email, Slack, etc.)

## Next Steps

After setup is complete, you should be able to:
- ✅ Create new teas
- ✅ Update existing teas
- ✅ Delete teas
- ✅ Create/update/delete tags and categories
- ✅ Use AI description generation
- ✅ Receive real-time subscription updates

All operations now require valid admin authentication!
