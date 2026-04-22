FROM quay.io/keycloak/keycloak:26.3.3

USER root

COPY providers/thakacreations.keycloak-2fa-sms-authenticator.jar /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build

USER 1000