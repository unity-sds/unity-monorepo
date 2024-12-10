# Order matters here!
# Package an Application
#  behave features/apgs/packaging.feature -t test --no-capture
# Run the package* in airflow
# behave features/sps/cwl.feature -t test
# Run the pacakge via ogc
# behave features/sps/wpst.feature -t test

behave features/data_catalog/stac.feature -D COLLECTION_ID=${STAC_COLLECTION_ID} -D STAC_SCHEMA_FILE=${STAC_SCHEMA_FILE} -D TESTRAIL=${USE_TESTRAIL}
