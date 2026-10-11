#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-run}"
case "$MODE" in
    run|--debug|--logs|--telemetry|--verify) ;;
    *)
        echo "usage: $0 [run|--debug|--logs|--telemetry|--verify]" >&2
        exit 2
        ;;
esac

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="TeaElephantEditor"
BUNDLE_ID="xax.TeaElephantEditor"
CONFIGURATION="${EDITOR_CONFIGURATION:-Debug}"
DERIVED_DATA="${EDITOR_DERIVED_DATA:-$ROOT_DIR/.build/run}"
BUILD_ARGS=(
    -workspace "$ROOT_DIR/TeaElephantEditor.xcworkspace"
    -scheme "$APP_NAME"
    -configuration "$CONFIGURATION"
    -destination 'platform=macOS'
    -derivedDataPath "$DERIVED_DATA"
)

if [[ -n "${EDITOR_SOURCE_PACKAGES_DIR:-}" ]]; then
    BUILD_ARGS+=(
        -clonedSourcePackagesDirPath "$EDITOR_SOURCE_PACKAGES_DIR"
        -disableAutomaticPackageResolution
    )
fi

pkill -x "$APP_NAME" >/dev/null 2>&1 || true
xcodebuild "${BUILD_ARGS[@]}" build

APP_BUNDLE="$DERIVED_DATA/Build/Products/$CONFIGURATION/$APP_NAME.app"
APP_BINARY="$APP_BUNDLE/Contents/MacOS/$APP_NAME"
test -x "$APP_BINARY"

case "$MODE" in
    run)
        /usr/bin/open -n "$APP_BUNDLE"
        ;;
    --debug)
        lldb -- "$APP_BINARY"
        ;;
    --logs)
        /usr/bin/open -n "$APP_BUNDLE"
        /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
        ;;
    --telemetry)
        /usr/bin/open -n "$APP_BUNDLE"
        /usr/bin/log stream --info --style compact --predicate "subsystem == \"$BUNDLE_ID\""
        ;;
    --verify)
        /usr/bin/open -n "$APP_BUNDLE"
        for attempt in {1..10}; do
            sleep 1
            if pgrep -x "$APP_NAME" >/dev/null; then
                echo "Running $APP_BUNDLE"
                exit 0
            fi
        done
        echo "$APP_NAME did not start" >&2
        exit 1
        ;;
esac
