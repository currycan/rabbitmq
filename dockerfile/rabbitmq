FROM rabbitmq:3.7.14-management

LABEL maintainer "Platform/IIBU <zhangzhitao@fmsh.com.cn>"
LABEL base="rabbitmq:3.7-management"

RUN set -ex && \
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

ARG PROM_VER=v3.7.2.5

RUN set -ex && \
    buildDeps=" \
        wget \
        unzip \
    " && \
    plugins=( \
        accept-0.3.5.ez \
        prometheus-4.2.2.ez \
        prometheus_cowboy-0.1.7.ez \
        prometheus_httpd-2.1.10.ez \
        prometheus_process_collector-1.4.3.ez \
        prometheus_rabbitmq_exporter-3.7.2.5.ez \
    ) && \
    enable_plugins=( \
        rabbitmq_federation \
        rabbitmq_federation_management \
        rabbitmq_shovel \
        rabbitmq_shovel_management \
        rabbitmq_sharding \
        prometheus_rabbitmq_exporter \
        rabbitmq_peer_discovery_k8s \
    ) && \
    apt-get update && \
    apt-get install -y ${buildDeps} --no-install-recommends && \
    wget --no-check-certificate -O /usr/local/bin/cluster_entrypoint.sh https://raw.githubusercontent.com/currycan/rabbitmq/master/source/rabbitmq/cluster_entrypoint.sh && \
    chmod +x /usr/local/bin/cluster_entrypoint.sh && \
    wget --no-check-certificate -O /usr/local/bin/docker-entrypoint.sh https://raw.githubusercontent.com/currycan/rabbitmq/master/source/rabbitmq/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    wget --no-check-certificate -O /usr/local/bin/rabbitmq-dump-queue https://raw.githubusercontent.com/currycan/rabbitmq/master/source/rabbitmq/rabbitmq-dump-queue && \
    chmod +x /usr/local/bin/rabbitmq-dump-queue && \
    for plugin in ${plugins[@]};do \
    wget --no-check-certificate -P /opt/rabbitmq/plugins/ \
        https://github.com/deadtrickster/prometheus_rabbitmq_exporter/releases/download/${PROM_VER}/${plugin};\
    done && \
    apt-get purge -y --auto-remove $buildDeps && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    for enable_plugin in ${enable_plugins[@]};do \
        rabbitmq-plugins enable --offline ${enable_plugin}; \
    done

# ENV TZ=Asia/Shanghai \
#     RABBITMQ_NODE_IP_ADDRESS=0.0.0.0 \
#     RABBITMQ_NODE_PORT=5672 \
#     RABBITMQ_SASL_LOGS=/var/lib/rabbitmq/logs \
#     RABBITMQ_LOG_BASE=/var/lib/rabbitmq/logs \
#     # RABBITMQ_LOGS=/var/lib/rabbitmq/logs/RABBITMQ_NODENAME.log \
#     RABBITMQ_DEFAULT_USER=user \
#     RABBITMQ_DEFAULT_PASS=password \
#     RABBITMQ_DEFAULT_VHOST=/

ENTRYPOINT ["cluster_entrypoint.sh","docker-entrypoint.sh"]

EXPOSE 4369 5671 5672 15672 25672 5670
CMD ["rabbitmq-server"]
