# Docker JBoss BPMS

Before build this docker image it's necessary put in this directory the files **jboss-eap-7.0.0.zip** and **jboss-eap-7.0.7-patch.zip**, **jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip** and **jboss-bpmsuite-6.4.5-patch.zip**, you can download the file at [Red Hat JBoss Enterprise Application Platform](https://access.redhat.com/products/red-hat-jboss-enterprise-application-platform/) and [Red Hat JBoss BPM Suite](https://access.redhat.com/products/red-hat-jboss-bpm-suite/)

Clone
---
```bash
git clone https://github.com/fabricads/docker-bpms
```

Build docker image
---
```bash
docker build -t redhat/bpms:6.4.5 docker-bpms
```

Run docker container
---
```bash
docker run -d --name redhat-bpms -p 8080:8080 -p 9990:9990 redhat/bpms:6.4.5
```

Browser
---
Go to [Business Central](https://localhost:8080/business-central) 


To share your local server to internet install [ngrok](https://ngrok.com/) and run ```ngrok http 8000```
