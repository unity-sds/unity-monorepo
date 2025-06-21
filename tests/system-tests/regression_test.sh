#
# Order matters here!
#

#
# Test Application Catalog
#
# Test Algorithm registration and retreiveal from the catalog
# behave -q features/application_catalog/catalog.feature

# Test the capability to publish application packages conforming to the published OGC Best Practice
# behave -q features/application_catalog/OGC_validations.feature

# Package an Application
#  behave -q features/apgs/packaging.feature -t test --no-capture

#
# Test U-SPS
#
# Run the package* in airflow
behave -q features/sps/cwl.feature -t test

## Run the pacakge via ogc
## behave -q features/sps/wpst.feature -t test

#
# U-DS Tests after Application executes successfully
#
# Test the ingestion of data in S3 - this should be taken care of when running the package in Airflow. 
# behave -q features/data_catalog/ingest_with_required_metadata.feature

# The data catalog shall return search results in STAC (SpatioTemporal Asset Catalogs) format
behave -q features/data_catalog/stac.feature --no-capture

# Ensure granules can be found by their parent collections
behave -q features/data_catalog/parent_collections.feature -t test --no-capture

# Test DAPA APIs
behave -q features/data_catalog/dapa.feature -t test --no-capture
