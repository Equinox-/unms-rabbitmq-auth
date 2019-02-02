FROM ubnt/unms:latest
MAINTAINER Westin Miller "equinoxscripts@gmail.com"

ENV UNMS_RABBITMQ_USER="" \
	UNMS_RABBITMQ_PASS=""

COPY config.js.patch plugin.js.patch /tmp/

RUN patch /home/app/unms/config.js /tmp/config.js.patch \
	&& patch /home/app/unms/lib/message-hub/plugin.js /tmp/plugin.js.patch \
	&& rm /tmp/config.js.patch /tmp/plugin.js.patch

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]

CMD ["npm start"]