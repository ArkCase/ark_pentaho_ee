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
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/pentaho-server-ee-${PENTAHO_SERVER_EE}-dist.zip" artifacts/
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/pentaho-server-licenses-${PENTAHO_SERVER_LICENSES}.zip" artifacts/
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/pir-plugin-ee-${PIR_PLUGIN_EE}-dist.zip" artifacts/
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/paz-plugin-ee-${PAZ_PLUGIN_EE}-dist.zip" artifacts/
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/pdd-plugin-ee-${PDD_PLUGIN_EE}-dist.zip" artifacts/
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/pdi-ee-client-${PDI_EE_CLIENT}-dist.zip" artifacts/
aws s3 cp  "s3://arkcase-container-artifacts/ark_pentaho_ee/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/arkcase-preauth-springsec-v${ARKCASE_PRE_AUTH_VERSION}-bundled.jar" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/expect-script.exp" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/expect-script-paz.exp" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/expect-script-pdd.exp" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/expect-script-pdi.exp" artifacts/
aws s3 cp "s3://arkcase-container-artifacts/ark_pentaho_ee/expect-script-pir.exp" artifacts/
