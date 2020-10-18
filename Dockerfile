FROM ubnt/unms:1.2.7
MAINTAINER Westin Miller "equinoxscripts@gmail.com"

ENV UNMS_RABBITMQ_USER="" \
	UNMS_RABBITMQ_PASS=""

COPY config.js.patch \
	 device_rpc_transport.js.patch \
	 message_hub_index.js.patch \
	 notification_hub_plugin.js.patch /tmp/

# Use sed at the end because there's something weird with busybox patch
RUN patch /home/app/unms/config.js /tmp/config.js.patch \
	&& patch /home/app/unms/lib/device-rpc/transport.js /tmp/device_rpc_transport.js.patch \
	&& patch /home/app/unms/lib/message-hub/index.js /tmp/message_hub_index.js.patch \
	&& patch /home/app/unms/lib/notification-hub/plugin.js /tmp/notification_hub_plugin.js.patch \
	&& sed -i 's/amqp:\/\/${config.host}:${config.port}/amqp:\/\/${config.user}:${config.pass}@${config.host}:${config.port}/' /home/app/unms/lib/ws/messaging.js \
	&& sed -i 's/await checkCrm/\/\/ await checkCrm/' /home/app/unms/lib/dal/setup.js \
	&& sed -i 's/node cli\/check-crm-db.js/echo skip_crm_check/' /home/app/unms/package.json \
	&& sed -i "s/NOT p.proisagg/p.prokind != 'a'/" /home/app/unms/lib/dal/setup.js \
	&& sed -i "s/NOT p.proiswindow/p.prokind != 'w'/" /home/app/unms/lib/dal/setup.js \
	&& sed -i "s/config.siridb.user.account/config.siridb.user.username/" /home/app/unms/lib/ws/register.js

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]

CMD ["index.js"]
