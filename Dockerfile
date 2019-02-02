FROM ubnt/unms:0.13.2
MAINTAINER Westin Miller "equinoxscripts@gmail.com"

ENV UNMS_RABBITMQ_USER="" \
	UNMS_RABBITMQ_PASS=""

COPY config.js.patch msg_index.js.patch /tmp/

RUN patch /home/app/unms/config.js /tmp/config.js.patch \
	&& patch /home/app/unms/lib/message-hub/index.js /tmp/msg_index.js.patch \
	&& rm /tmp/config.js.patch /tmp/msg_index.js.patch

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]

CMD ["npm start"]