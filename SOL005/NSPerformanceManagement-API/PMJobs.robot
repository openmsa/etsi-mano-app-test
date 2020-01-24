*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          NSPerformanceManagementKeywords.robot
Library           JSONLibrary
Library           OperatingSystem
Resource          environment/pmJobs.txt
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           MockServerLibrary

*** Test Cases ***
GET all NS Performance Monitoring Jobs
    [Documentation]    Test ID: 5.3.4.1.1
    ...    Test title: GET all NS Performance Monitoring Jobs
    ...    Test objective: The objective is to test the retrieval of all the available NS performance monitoring jobs and perform a JSON schema and content validation of the collected jobs data structure
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all NS Performance Monitoring Jobs
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Do Not Contain reports

GET NS Performance Monitoring Jobs with attribute-based filter
    [Documentation]    Test ID: 5.3.4.1.2
    ...    Test title: GET all NS Performance Monitoring Jobs with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of NS performance monitoring jobs using attribute-based filter, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested attribute-based filter

GET all NS Performance Monitoring Jobs with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.4.1.3
    ...    Test title: GET all NS Performance Monitoring Jobs with "all_fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all NS performance monitoring jobs "all_fields" attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued "all_fileds" selector
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested all_fields selector

GET all NS Performance Monitoring Jobs with "exclude_default" attribute selector
    [Documentation]    Test ID: 5.3.4.1.4
    ...    Test title: GET all NS Performance Monitoring Jobs with "exclude_default" attribute selector
    ...    Test objective: The objective is to test the retrieval of all NS performance monitoring jobs "exclude_default" attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued "exclude_default" selector
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested exclude_default selector

GET all NS Performance Monitoring Jobs with "include" attribute selector
    [Documentation]    Test ID: 5.3.4.1.5
    ...    Test title: GET all NS Performance Monitoring Jobs with "include" attribute selector
    ...    Test objective: The objective is to test the retrieval of all NS performance monitoring jobs "include" attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued "include" selector
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the use of "include" attribute selector
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with include attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested include selector

GET all NS Performance Monitoring Jobs with "exclude" attribute selector
    [Documentation]    Test ID: 5.3.4.1.6
    ...    Test title: GET all NS Performance Monitoring Jobs with exclude_fields attribute selector
    ...    Test objective: The objective is to test the retrieval of all NS performance monitoring jobs "exclude" attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued "exclude" selector
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the use of "exclude" attribute selector
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with exclude attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested exclude selector

GET NS Performance Monitoring Jobs with invalid attribute-based filter
    [Documentation]    Test ID: 5.3.4.1.7
    ...    Test title: GET NS Performance Monitoring Jobs with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of NS performance monitoring jobs fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET NS Performance Monitoring Jobs with invalid resource endpoint
    [Documentation]    Test ID: 5.3.4.1.8
    ...    Test title: GET NS Performance Monitoring Jobs with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of NS performance monitoring jobs fails when using invalid resource endpoint
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET NS Performance Monitoring Jobs with invalid resource endpoint
    Check HTTP Response Status Code Is    404

Create new NS Performance Monitoring Job
    [Documentation]    Test ID: 5.3.4.1.9
    ...    Test title:  Create a new NS Performance Monitoring Job
    ...    Test objective: The objective is to test the creation of a new NS performance monitoring job and perform the JSON schema validation of the returned job data structure
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance Job is successfully created on the NFVO
    Send Post Request Create new NS Performance Monitoring Job
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   PmJob
    Check Postcondition PmJob Exists

PUT all NS Performance Monitoring Jobs - Method not implemented
    [Documentation]    Test ID: 5.3.4.1.10
    ...    Test title: PUT all NS Performance Monitoring Jobs - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify NS Performance Monitoring Jobs
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all NS Performance Monitoring Jobs
    Check HTTP Response Status Code Is    405
    
PATCH all NS Performance Monitoring Jobs - Method not implemented
    [Documentation]    Test ID: 5.3.4.1.11
    ...    Test title: PATCH all NS Performance Monitoring Jobs - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update NS Performance Monitoring Jobs
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all NS Performance Monitoring Jobs
    Check HTTP Response Status Code Is    405
    
DELETE all NS Performance Monitoring Jobs - Method not implemented
    [Documentation]    Test ID: 5.3.4.1.12
    ...    Test title: DELETE all NS Performance Monitoring Jobs - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete NS Performance Monitoring Jobs
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: clause 7.4.2.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance Monitoring Jobs are not deleted by the failed operation
    Send PATCH Request for all NS Performance Monitoring Jobs
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Performance Monitoring Jobs Exist
