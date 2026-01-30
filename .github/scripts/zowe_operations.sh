#!/bin/bash
set -e

echo "========================================"
echo " Zowe Operations Script Started"
echo "========================================"

# Convert username to lowercase (USS paths are lowercase)
LOWERCASE_USERNAME=$(echo "$ZOWE_ZOSMF_USER" | tr '[:upper:]' '[:lower:]')

USS_BASE="/z/$LOWERCASE_USERNAME/cobolcheck"

echo "Using USS directory: $USS_BASE"

# ---------------------------------------
# 1. Check if USS directory exists
# ---------------------------------------
if zowe zos-files list uss-files "$USS_BASE" \
  --host "$ZOWE_ZOSMF_HOST" \
  --port "$ZOWE_ZOSMF_PORT" \
  --user "$ZOWE_ZOSMF_USER" \
  --password "$ZOWE_ZOSMF_PASSWORD" \
  --reject-unauthorized true >/dev/null 2>&1
then
  echo "USS directory already exists."
else
  echo "USS directory does not exist. Creating it..."
  zowe zos-files create uss-directory "$USS_BASE" \
    --host "$ZOWE_ZOSMF_HOST" \
    --port "$ZOWE_ZOSMF_PORT" \
    --user "$ZOWE_ZOSMF_USER" \
    --password "$ZOWE_ZOSMF_PASSWORD" \
    --reject-unauthorized true
fi

# ---------------------------------------
# 2. Upload COBOL Check directory
# ---------------------------------------
echo "Uploading COBOL Check files to USS..."

zowe zos-files upload dir-to-uss "./cobol-check" "$USS_BASE" \
  --recursive \
  --host "$ZOWE_ZOSMF_HOST" \
  --port "$ZOWE_ZOSMF_PORT" \
  --user "$ZOWE_ZOSMF_USER" \
  --password "$ZOWE_ZOSMF_PASSWORD" \
  --reject-unauthorized true

# ---------------------------------------
# 3. Verify upload
# ---------------------------------------
echo "Verifying USS upload..."

zowe zos-files list uss-files "$USS_BASE" \
  --host "$ZOWE_ZOSMF_HOST" \
  --port "$ZOWE_ZOSMF_PORT" \
  --user "$ZOWE_ZOSMF_USER" \
  --password "$ZOWE_ZOSMF_PASSWORD" \
  --reject-unauthorized true

echo "========================================"
echo " Zowe Operations Script Completed"
echo "========================================"
