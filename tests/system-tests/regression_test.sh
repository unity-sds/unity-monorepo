#
# Order matters here!
#

if [[ -z $BASE_TEST_DIR ]]; then
    export BASE_TEST_DIR="`pwd`"
fi

#
# Test Application Catalog
#
# Test Algorithm registration and retreiveal from the catalog
# behave -q ${BASE_TEST_DIR}/features/application_catalog/catalog.feature

# Test the capability to publish application packages conforming to the published OGC Best Practice
# behave -q ${BASE_TEST_DIR}/features/application_catalog/OGC_validations.feature

# Package an Application
#  behave -q ${BASE_TEST_DIR}/features/apgs/packaging.feature -t test --no-capture

#
# Test U-SPS
#
# Run the package* in airflow
# behave -q ${BASE_TEST_DIR}/features/sps/cwl.feature -t test

## Run the pacakge via ogc
## behave -q ${BASE_TEST_DIR}/features/sps/wpst.feature -t test

#
# U-DS Tests after Application executes successfully
#
# Test the ingestion of data in S3 - this should be taken care of when running the package in Airflow. 
# behave -q ${BASE_TEST_DIR}/features/data_catalog/ingest_with_required_metadata.feature

# The data catalog shall return search results in STAC (SpatioTemporal Asset Catalogs) format
behave -q ${BASE_TEST_DIR}/features/data_catalog/stac.feature -D STAC_SCHEMA_FILE=${STAC_SCHEMA_FILE} --no-capture

# Ensure granules can be found by their parent collections
behave -q ${BASE_TEST_DIR}/features/data_catalog/parent_collections.feature -t test --no-capture

# Test DAPA APIs
behave -q ${BASE_TEST_DIR}/features/data_catalog/dapa.feature -t test --no-capture
