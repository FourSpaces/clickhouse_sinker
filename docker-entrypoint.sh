#!/usr/bin/env sh

set -eux

export TZ=${TZ:-UTC}

CONFIG_DIR="${CONFIG_DIR:-/config}"
TASK_DIR="${CONFIG_DIR}/tasks"
CPUNUM=${CPUNUM:-1}
IP_HTTP=${IP_HTTP:-"0.0.0.0"}
PORT_HTTP=${PORT_HTTP:-${PORT0:-2112}}
HTTP_ADDR=${HTTP_ADDR:-"${IP_HTTP}:${PORT_HTTP}"}
CONSUL_ADDR=${CONSUL_ADDR:-"http://127.0.0.1:8500"}
CONFIG=${CONFIG}
TASK=${TASK}

install -d "${CONFIG_DIR}"
install -d "${TASK_DIR}"

dict_to_json() {
  cat - | tr "'" '"' | sed 's/True/true/g' | sed 's/False/false/g'
}

cat <<EOF | dict_to_json >"${CONFIG_DIR}/config.json"
${CONFIG}
EOF

cat <<EOF | dict_to_json >"${TASK_DIR}/task.json"
${TASK}
EOF

exec /usr/local/bin/clickhouse_sinker \
  -conf "${CONFIG_DIR}" \
  -cpunum "${CPUNUM}" \
  -http-addr "${HTTP_ADDR}" \
  -consul-addr "${CONSUL_ADDR}"
