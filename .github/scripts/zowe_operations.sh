#!/bin/bash

LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck || true

zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive
