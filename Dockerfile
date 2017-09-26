FROM anapsix/alpine-java
VOLUME /tmp
EXPOSE 9999 9990 8080 8787
ENV JBOSS_USER=jbossAdmin JBOSS_PASS=redhat99 USER_ADMIN_NAME=bpmsAdmin USER_ADMIN_GROUP=admin,rest-all,kie-server,rest-client USER_ADMIN_PASS=redhat99 USER1_NAME=joao USER1_GROUP=comercial,user USER1_PASS=joao123 USER2_NAME=maria USER2_GROUP=infra,user USER2_PASS=maria123 USER2_NAME=jose USER2_GROUP=dev,user USER2_PASS=jose123
WORKDIR /tmp
COPY *.zip *.cli /tmp/

RUN unzip -q /tmp/jboss-eap-7.0.0.zip -d /opt && \
    ln -s /opt/jboss-eap-7.0 /opt/jboss-eap && \
    # Do not use patch > 7.0.5, see https://issues.jboss.org/browse/RHBPMS-4769.
    # /opt/jboss-eap/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-7.0.7-patch.zip" && \
    unzip -o -q /tmp/jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip -d /opt && \
    unzip -o -q /tmp/jboss-bpmsuite-6.4.5-patch.zip -d /tmp && \
    # Necessary execute command inside patch directory.
    cd /tmp/jboss-bpmsuite-6.4.5-patch && \
    ./apply-updates.sh /opt/jboss-eap-7.0 eap7.x && \
    /opt/jboss-eap/bin/jboss-cli.sh --file=/tmp/config.cli && \
    sed -i 's/#controllerUser=/controllerUser=/g' /opt/jboss-eap/standalone/configuration/application-roles.properties && \
    sed -i 's/#controllerUser=/controllerUser=/g' /opt/jboss-eap/standalone/configuration/application-users.properties && \
    rm -fr /opt/jboss-eap/standalone/configuration/standalone_xml_history/current && \
    /opt/jboss-eap/bin/add-user.sh -u "$JBOSS_USER" -p "$JBOSS_PASS" && \
    /opt/jboss-eap/bin/add-user.sh -a -u "$USER_ADMIN_NAME" -p "$USER_ADMIN_PASS" -g "$USER_ADMIN_GROUP" && \
    /opt/jboss-eap/bin/add-user.sh -a -u "$USER1_NAME" -p "$USER1_PASS" -g "$USER1_GROUP" && \
    /opt/jboss-eap/bin/add-user.sh -a -u "$USER2_NAME" -p "$USER2_PASS" -g "$USER2_GROUP"

CMD /opt/jboss-eap/bin/standalone.sh -Djboss.bind.address.management=0.0.0.0 -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.unsecure=0.0.0.0 --debug
