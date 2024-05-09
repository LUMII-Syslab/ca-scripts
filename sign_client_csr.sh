#!/bin/bash

set -Eeo pipefail
#
# Signs the given CSR (certificate signing request) provided by a 3rd party for client authentication.
# The signed .crt will be validated by, e.g., HAProxy by checking that the public key of the given client
# has been signed by our CA.
#
# Script arguments: ca-name signing-request.csr
#   (no spaces or special symbols in ca-name, please!)
#
# Copyright (c) Institute of Mathematics and Computer Science, University of Latvia
# Licence: MIT
# Contributors:
#   Sergejs Kozlovics, 2022-2024

export PATH=/usr/bin:$PATH
export DIR=$(dirname $0)

if [ "$2" = "" ]; then
  echo Usage: $0 ca-name signing-request.csr
  echo "  (no spaces or special symbols in ca-name, please!)"
  exit
fi
export CA_NAME=$1
export CLIENT_CSR=$2
source $DIR/_vars.sh
source $CA_VARS

mkdir -p `dirname ${CLIENT_CSR}`
mkdir -p `dirname ${CLIENT_CRT}`

echo "Signing the client CSR $CLIENT_CSR -> $CLIENT_CRT..."
${OQS_OPENSSL} x509 -req -in ${CLIENT_CSR} -out ${CLIENT_CRT} -CA ${CA_CRT} -CAkey ${CA_KEY} -CAcreateserial -days $CLIENT_DAYS ${OQS_OPENSSL_FLAGS} -sha256
