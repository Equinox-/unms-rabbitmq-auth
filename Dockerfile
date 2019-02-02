FROM ubnt/unms:0.13.2
MAINTAINER Westin Miller "equinoxscripts@gmail.com"

ENV UNMS_RABBITMQ_USER="" \
	UNMS_RABBITMQ_PASS=""

COPY config.js.patch \
	 device_rpc_transport.js.patch \
	 message_hub_index.js.patch \
	 notification_hub_plugin.js.patch \
	 ws_messaging.js.patch /tmp/

RUN patch /home/app/unms/config.js /tmp/config.js.patch \
	&& patch /home/app/unms/lib/device-rpc/transport.js /tmp/device_rpc_transport.js.patch \
	&& patch /home/app/unms/lib/message-hub/index.js /tmp/message_hub_index.js.patch \
	&& patch /home/app/unms/lib/notification-hub/plugin.js /tmp/notification_hub_plugin.js.patch \
	&& patch /home/app/unms/lib/ws/messaging.js /tmp/ws_messaging.js.patch

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]

CMD ["npm start"]