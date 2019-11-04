#!/usr/bin/env bash
set -e

#  build a new cert
./scripts/setup_dev_mtls.sh

profile_uaa=""

if [ "x$UAA_URL" != "x" ]; then
	profile_uaa=",dev-uaa"
	cat <<EOF > src/main/resources/application-dev-uaa.yml
auth_server:
  url: ${UAA_URL}
  internal_url: ${UAA_INTERNAL_URL:-"~"}
security:
  oauth2:
    enabled: true
EOF

fi

java \
  -Djava.security.egd=file:/dev/urandom \
  -Dspring.profiles.active=dev,dev-h2 \
  -Djavax.net.ssl.trustStore=src/test/resources/auth_server_trust_store.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -Djdk.tls.ephemeralDHKeySize=4096 \
  -Djdk.tls.namedGroups="secp384r1" \
  -Djava.security.egd=file:/dev/urandom \
  -jar ./applications/credhub-api/build/libs/credhub.jar "$@"
