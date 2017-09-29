#!/bin/bash
set -eu

ZOO_CFG_FILE="${ZOO_CONF_DIR}/zookeeper.properties"
ZOO_CFG_TMPL_FILE="${ZOO_CFG_FILE}.tmpl"

: ${zk_myid:=1}
: ${zk_tick_time:=2000}
: ${zk_init_limit:=5}
: ${zk_sync_limit:=2}
: ${zk_max_client_cnxns:=0}
: ${zk_servers:=localhost}
: ${ZOO_CFG_TMPL_URL:=""}

export zk_myid
export zk_tick_time
export zk_init_limit
export zk_sync_limit
export zk_max_client_cnxns

# Set Zookeeper ID
echo $zk_myid > "${ZOO_DATA_DIR}/myid"

# Substitute internal ZK config template, if given a URL
if [ ! -z "${ZOO_CFG_TMPL_URL}" ]; then
  echo "[zk] Downloading ZK config template from ${ZOO_CFG_TMPL_URL}"
  set +e
  curl --location --silent --insecure --outout "${ZOO_CFG_TMPL_FILE}"
  if [ $? -ne 0 ]; then
    echo "[zk] Failed to download ${ZOO_CFG_TMPL_URL}, exiting"
    exit 1
  fi
  set -e
fi

# Append server block to yml serving as context
# generating a ZK config from the provided ZK config template
# (cannot easily 'template' our yml :( )
append_servers_to_yml () {
  if [[ "x$zk_servers" = "x" ]] || [[ "x$zk_servers" = "xlocalhost" ]]; then 
    echo "[zk] No additional servers given, running in standalone mode."
    return 
  fi
  local config_yml="$1"
  # trim whitespace & split into array
  local servers
  IFS="," servers=(`echo "${zk_servers}" | tr -d " "`)
  echo "servers:" >> "${config_yml}"
  for server in ${servers[@]}; do
    echo "  - ${server}" >> "${config_yml}"
  done
}

# Store config vars in a YML file and generate ZK config from template + YML
cat > "/tmp/vars.yml" <<EOF
tick_time: ${zk_tick_time}
init_limit: ${zk_init_limit}
sync_limit: ${zk_sync_limit}
data_dir: ${ZOO_DATA_DIR}
data_log_dir: ${ZOO_DATA_LOG_DIR}
# disable cap on connections from one IP (for dev)
max_client_connections: ${zk_max_client_cnxns}
myid: ${zk_myid}
EOF
append_servers_to_yml "/tmp/vars.yml"

echo "[zk] Going to generate config from the following vars:"

gotpl "${ZOO_CFG_TMPL_FILE}" > "${ZOO_CFG_FILE}" < "/tmp/vars.yml"

if [[ "$#" -ne "0" ]]; then
  echo "[zk] Arguments given, running command..."
  exec $*
else
  # Start ZooKeeper
  echo "[zk] starting ZooKeeper. Remember you can telnet to ZK via the client port"
  echo "[zk] supported client commands: wchs, stat, stmk, conf, ruok, mntr, srvr, envi, srst, isro, dump, gtmk, crst, cons"
  ZOOCFG="zookeeper.properties" ZOOCFGDIR="${ZOO_CONF_DIR}" exec "${ZOO_BASE_DIR}/bin/zkServer.sh" start-foreground
fi