# Order matters here!
# Package an Application
behave features/apgs/packaging.feature -t test --no-capture
# Run the package* in airflow
behave features/sps/cwl.feature -t test
# Run the pacakge via ogc
# behave features/sps/wpst.feature -t test
