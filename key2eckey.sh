#!/bin/bash

if [ "$1" = "" ]; then
  echo "This scripts converts a genertic private key file (in the PEM format)"
  echo "contatining an EC (elliptic curve) private key into the EC-specific encoding of the same"
  echo "private key (also in the PEM format)."
  echo "The EC-specific encoding is the enconding containing both"
  echo "the \"-----BEGIN EC PARAMETERS-----\" section and"
  echo "the \"-----BEGIN EC PRIVATE KEY-----\" section."
  echo ""
  echo "Usage: $0 ec-key-file"
  exit
fi

export KEY_FILE=$1
export ECKEY_FILE=${KEY_FILE%.*}.eckey

export oid_line=`openssl ec -in $KEY_FILE -noout -text|grep "ASN1 OID"`
# e.g., "ASN1 OID: prime256v1"

# parsing oid_line into line_parts:
IFS=' ' read -ra line_parts <<< "$oid_line"

if [ -z "$line_parts" ]; then
  echo Not an EC key.
  exit
fi

export oid="${line_parts[-1]}"

echo "Writing EC params..."
openssl ecparam -out $ECKEY_FILE -name $oid
echo "Writing EC private key..."
openssl ec -outform PEM -in $KEY_FILE >> $ECKEY_FILE
