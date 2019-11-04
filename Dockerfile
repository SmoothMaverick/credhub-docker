FROM openjdk:8
COPY ./credhub /usr/src/credhub
COPY ./credhub-acceptance-tests /usr/src/acceptance/src/github.com/cloudfoundry-incubator/credhub-acceptance-tests
ENV GOPATH /usr/src/acceptance
WORKDIR /usr/src/credhub

RUN "./scripts/setup_dev_mtls.sh"
RUN ["./gradlew", "--no-daemon", "assemble"]

RUN /bin/mkdir -p /usr/src/credhub/src/test/resources/
RUN cp ./applications/credhub-api/src/test/resources/auth_server_trust_store.jks /usr/src/credhub/src/test/resources/

COPY ./entrypoint.sh /usr/src/credhub/entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
