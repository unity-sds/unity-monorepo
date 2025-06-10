Feature: MDPS_2_REQ-4
  We are able to submit a CWL document for processing to the EMS/ADES. Once executed, we check for status and to
  ensure processing completes successfully. Once processing completes, we check the data catalog for success.
  This particular workflow is setup to test the autocatalogging feature of stage_out.



  @develop @test
  Scenario Outline: The SPS shall be capable of executing CWL workflows - execution
      Given I authenticate with Unity Services
      And the cwl_dag workflow is currently deployed in airflow
      And I provide the required workflow inputs for <workflow_name>
      When I request a run of <workflow_name> from <workflow_url>
      Then the workflow is executed successfully
      And the workflow successfully completes
      And the workflow data shows up in the data catalog

      Examples:
      | workflow_url | workflow_name   |
      | http://awslbdockstorestack-lb-1429770210.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fdockstore.org%2Fmike-gangl%2Funity-example-application/versions/5/PLAIN-CWL/descriptor/%2Fworkflow.cwl  | unity-example-application |
