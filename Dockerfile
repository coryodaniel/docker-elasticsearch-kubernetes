FROM quay.io/coryodaniel/elasticsearch:6.3.0
MAINTAINER pjpires@gmail.com

# Override config, otherwise plug-in install will fail
COPY config /elasticsearch/config

# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery

# Kubernetes requires swap is turned off, so memory lock is redundant
ENV MEMORY_LOCK false
