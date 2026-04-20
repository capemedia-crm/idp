FROM quay.io/keycloak/keycloak:26.3.3

USER root


COPY providers/thakacreations.keycloak-2fa-sms-authenticator.jar /opt/keycloak/providers/

# Install minimal Python (portable approach)
COPY docker/python /opt/python


COPY scripts/ssm-bootstrap.sh /opt/keycloak/bin/ssm-bootstrap.sh

RUN chmod +x /opt/keycloak/bin/ssm-bootstrap.sh \
    && chown -R 1000:0 /opt/keycloak \
    && chmod -R g+rwX /opt/keycloak

USER 1000

ENTRYPOINT ["/opt/keycloak/bin/ssm-bootstrap.sh"]