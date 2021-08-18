#!/bin/bash
here=$(realpath "$0")
here=$(dirname "$here")
cd "$here"
PENTAHO_SERVER_EE="8.3.0.0-371"
PENTAHO_SERVER_LICENSES="2020"
PIR_PLUGIN_EE="8.3.0.0-371"
PAZ_PLUGIN_EE="8.3.0.0-371"
PDD_PLUGIN_EE="8.3.0.0-371"
PDI_EE_CLIENT="8.3.0.0-371"
MYSQL_CONNECTOR_VERSION="8.0.25"
MARIADB_CONNECTOR_VERSION="2.2.6"
ARKCASE_PRE_AUTH_VERSION="4-1.1.1"
rm -rf artifacts
mkdir artifacts
echo "Downloading  Pentaho EE artifacts version  $Pentaho_Version"
aws s3 cp --recursive  s3://arkcase-container-artifacts/ark_pentaho_ee/  artifacts/
