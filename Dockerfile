FROM quay.io/keycloak/keycloak:26.6.1

USER root

COPY providers/thakacreations.keycloak-2fa-sms-authenticator.jar /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build

USER 1000