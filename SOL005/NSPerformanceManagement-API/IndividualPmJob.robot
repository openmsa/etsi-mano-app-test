*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/IndividualPmJob.txt
Resource          NSPerformanceManagementKeywords.robot
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
GET individual NS Performance Job
    [Documentation]    Test ID: 5.3.4.2.1
    ...    Test title: Get individual NS Performance Job
    ...    Test objective: The objective is to test the retrieval of an individual NS Performance monitoring job and perform a JSON schema and content validation of the collected job data structure
    ...    Pre-conditions: A NS instance is instantiated. One or more NS Performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.3.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual NS Performance Job
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJob
    Check HTTP Response Body Pm Job Identifier matches the requested Pm Job

GET individual NS Performance Job with invalid resource identifier
    [Documentation]    Test ID: 5.3.4.2.2
    ...    Test title: Get individual NS Performance Job with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual NS Performance monitoring job fails when using an invalid resource identifier, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A NS instance is instantiated. One or more NS Performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.3.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual NS Performance Job with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

DELETE Individual NS Performance Job with invalid resource identifier
    [Documentation]    Test ID: 5.3.4.2.3
    ...    Test title: Delete individual NS Performance Job with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual NS Performance monitoring job fails when using an invalid resource identifier
    ...    Pre-conditions: A NS instance is instantiated. One or more NS Performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Delete request for individual NS Performance Job with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual NS Performance Job - Method not implemented
    [Documentation]    Test ID: 5.3.4.2.4
    ...    Test title: POST Individual NS Performance Job - method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NS Performance Monitoring Job
    ...    Pre-conditions: A NS instance is instantiated
    ...    Reference: clause 7.4.3.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Post request for individual NS Performance Job
    Check HTTP Response Status Code Is    405

PUT Individual NS Performance Job - Method not implemented
    [Documentation]    Test ID: 5.3.4.2.5
    ...    Test title: PUT Individual NS Performance Job - method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing NS Performance Monitoring Job
    ...    Pre-conditions: A NS instance is instantiated. One or more NS Performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.3.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put request for individual NS Performance Job
    Check HTTP Response Status Code Is    405

PATCH Individual NS Performance Job - Method not implemented
    [Documentation]    Test ID: 5.3.4.2.6
    ...    Test title: PATCH Individual NS Performance Job - method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing new NS Performance Monitoring Job
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 6.4.3.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch request for individual NS Performance Job
    Check HTTP Response Status Code Is    405

DELETE Individual NS Performance Job
    [Documentation]    Test ID: 5.3.4.2.7
    ...    Test title: Delete Individual NS Performance Job
    ...    Test objective: The objective is to test the deletion of an individual NS Performance monitoring job
    ...    Pre-conditions: A NS instance is instantiated. One or more NS Performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance Job is no more available in the NFVO    
    Send Delete request for individual NS Performance Job
    Check HTTP Response Status Code Is    204
    Check Postcondition NS Pm Job is Deleted