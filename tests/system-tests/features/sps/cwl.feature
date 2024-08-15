Feature: MDPS_2_REQ-4
  The science processing platform shall allow execution of workflows conforming to the Common Workflow Language (CWL) specification

#  Scenario Outline: The SPS shall be capable of executing CWL workflows - deployment
#      Given the <project_name> <workflow_name> workflow is currently undeployed
#      And the application packages for the workflow are well-formed and published to the application catalog
#      When I request a run of <workflow_name>
#      And I provide the required workflow inputs
#      Then the HTTP response contains a status code of 201
#      And the HTTP response body contains a DeploymentResult
#
#      Examples:
#      | project_name | workflow_name     |
#      | sbg-dev      | unity-SBG-preprocess |
#      | sbg-dev |  L1B |
#      | sbg-dev |  L2 |
  @develop @test
  Scenario Outline: The SPS shall be capable of executing CWL workflows - execution
      Given the cwl_dag workflow is currently deployed in airflow
      And I provide the required workflow inputs for <workflow_name>
      When I request a run of <workflow_name> from <workflow_url>
      Then the workflow is executed successfully
      And the workflow successfully completes

      Examples:
      | workflow_url | workflow_name   |
      | http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-example-application/versions/5/PLAIN-CWL/descriptor/%2Fworkflow.cwl  | unity-example-applications |
