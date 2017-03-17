#!/bin/bash
# init kafka init script
#
WORKDIR=/usr/hdp/current/kafka-broker
TOPIC_CMD="${WORKDIR}/bin/kafka-topics.sh --zookeeper zk1.inter.htyunwang.com:2181"
REPLICATION=2
PARTITION=24
pushd $WORKDIR
${TOPIC_CMD} --create --replication-factor ${REPLICATION} --partitions ${PARTITION} --topic "crawler.category.meta"
${TOPIC_CMD} --create --replication-factor ${REPLICATION} --partitions ${PARTITION} --topic "crawler.company.meta"
${TOPIC_CMD} --create --replication-factor ${REPLICATION} --partitions ${PARTITION} --topic "crawler.companycategory.meta"
${TOPIC_CMD} --create --replication-factor ${REPLICATION} --partitions ${PARTITION} --topic "crawler.companycert.meta"
${TOPIC_CMD} --create --replication-factor ${REPLICATION} --partitions ${PARTITION} --topic "crawler.index"
${TOPIC_CMD} --create --replication-factor ${REPLICATION} --partitions ${PARTITION} --topic "crawler.product.meta"
popd
