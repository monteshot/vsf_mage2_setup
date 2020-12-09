#!/usr/bin/env bash
# =========================================================================
#   Local configuration template.
#   Copy this file to `./cfg.local.sh`.
# =========================================================================
# System
export NODE_TLS_REJECT_UNAUTHORIZED=0
# Magento
export MAGE_HOST="magento24.loc"
export MAGE_URL_REST="https://${MAGE_HOST}/rest"
export MAGE_URL_IMG="https://${MAGE_HOST}/media/catalog/product"
# VSF frontend
export PROJECT_NAME="${MAGE_HOST}"
export VSF_FRONT_SERVER_IP="127.0.0.1"
export VSF_FRONT_SERVER_PORT="3100"
export VSF_FRONT_WEB_HOST="front.vsf.${MAGE_HOST}"
export VSF_FRONT_WEB_PROTOCOL="https"

# VSF API
export VSF_API_SERVER_IP="127.0.0.1"
export VSF_API_SERVER_PORT="3130"
export VSF_API_WEB_HOST="api.vsf.${MAGE_HOST}"
export VSF_API_WEB_PROTOCOL="https"

# Redis
export REDIS_HOST="127.0.0.1"
export REDIS_PORT="6379"
export REDIS_DB="0"

# Elasticsearch
export ES_HOST="127.0.0.1"
export ES_PORT="9200"
export ES_API_VERSION="7.2"
export ES_URL="http://${ES_HOST}:${ES_PORT}"
export ES_INDEX_NAME="vue_demo_magento_mnt"

# Magento API access
export MAGE_API_CONSUMER_KEY="psr5qsw5dqccaqkcd9g6un26u0t4gt23"
export MAGE_API_CONSUMER_SECRET="i0hoqr37lyys38ikft34l9siy8odsqlw"
export MAGE_API_ACCESS_TOKEN="708bb87l7jyrvy4dxhqn7tsd40ang8rf"
export MAGE_API_ACCESS_TOKEN_SECRET="v3znn14fhtj7majjwopysnkke8mgnsll"
