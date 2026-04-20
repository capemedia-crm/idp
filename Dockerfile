FROM quay.io/keycloak/keycloak:26.3.3

USER root

RUN microdnf install -y jq awscli && microdnf clean all

COPY providers/thakacreations.keycloak-2fa-sms-authenticator.jar /opt/keycloak/providers/
COPY docker/ssm-bootstrap.sh /opt/keycloak/bin/ssm-bootstrap.sh

RUN chmod +x /opt/keycloak/bin/ssm-bootstrap.sh \
    && chown -R 1000:0 /opt/keycloak \
    && chmod -R g+rwX /opt/keycloak

# Optional but recommended for faster startup
RUN /opt/keycloak/bin/kc.sh build

USER 1000

ENTRYPOINT ["/opt/keycloak/bin/ssm-bootstrap.sh"]