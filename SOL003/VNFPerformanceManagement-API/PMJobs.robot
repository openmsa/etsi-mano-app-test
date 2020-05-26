*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           OperatingSystem
Library           String
Resource          environment/pmJobs.txt
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library           MockServerLibrary

*** Test Cases ***
GET all VNF Performance Monitoring Jobs
    [Documentation]    Test ID: 7.3.4.1.1
    ...    Test title: GET all VNF Performance Monitoring Jobs
    ...    Test objective: The objective is to test the retrieval of all the available VNF performance monitoring jobs and perform a JSON schema and content validation of the collected jobs data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Performance Monitoring Jobs
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body Does Not Contain reports

GET VNF Performance Monitoring Jobs with attribute-based filter
    [Documentation]    Test ID: 7.3.4.1.2
    ...    Test title: GET all VNF Performance Monitoring Jobs with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF performance monitoring jobs using attribute-based filter, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested attribute-based filter

GET all VNF Performance Monitoring Jobs with all_fields attribute selector
    [Documentation]    Test ID: 7.3.4.1.3
    ...    Test title: GET all VNF Performance Monitoring Jobs with all_fields attribute selector
    ...    Test objective: The objective is to test the retrieval of all VNF performance monitoring jobs all_fields attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued all_fileds selector
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested all_fields selector

GET all VNF Performance Monitoring Jobs with exclude_default attribute selector
    [Documentation]    Test ID: 7.3.4.1.4
    ...    Test title: GET all VNF Performance Monitoring Jobs with exclude_default attribute selector
    ...    Test objective: The objective is to test the retrieval of all VNF performance monitoring jobs exclude_default attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued exclude_default selector
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested exclude_default selector

GET all VNF Performance Monitoring Jobs with fields attribute selector
    [Documentation]    Test ID: 7.3.4.1.5
    ...    Test title: GET all VNF Performance Monitoring Jobs with fields attribute selector
    ...    Test objective: The objective is to test the retrieval of all VNF performance monitoring jobs fields attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued fields selector
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM supports the use of exclude_fields attribute selector
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested fields selector

GET all VNF Performance Monitoring Jobs with exclude_fields attribute selector
    [Documentation]    Test ID: 7.3.4.1.6
    ...    Test title: GET all VNF Performance Monitoring Jobs with exclude_fields attribute selector
    ...    Test objective: The objective is to test the retrieval of all VNF performance monitoring jobs exclude_fields attribute selector, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued exclude_fields selector
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM supports the use of exclude_fields attribute selector
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJobs
    Check HTTP Response Body PmJobs Matches the requested exclude_fields selector

GET VNF Performance Monitoring Jobs with invalid attribute-based filter
    [Documentation]    Test ID: 7.3.4.1.7
    ...    Test title: GET VNF Performance Monitoring Jobs with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF performance monitoring jobs fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET VNF Performance Monitoring Jobs with invalid resource endpoint
    [Documentation]    Test ID: 7.3.4.1.8
    ...    Test title: GET VNF Performance Monitoring Jobs with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF performance monitoring jobs fails when using invalid resource endpoint
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Performance Monitoring Jobs with invalid resource endpoint
    Check HTTP Response Status Code Is    404

Create new VNF Performance Monitoring Job
    [Documentation]    Test ID: 7.3.4.1.9
    ...    Test title:  Create a new VNF Performance Monitoring Job
    ...    Test objective: The objective is to test the creation of a new VNF performance monitoring job and perform the JSON schema validation of the returned job data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Job is successfully created on the VNFM
    Send Post Request Create new VNF Performance Monitoring Job
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   PmJob
    Check Postcondition PmJob Exists

PUT all VNF Performance Monitoring Jobs - Method not implemented
    [Documentation]    Test ID: 7.3.4.1.10
    ...    Test title: PUT all VNF Performance Monitoring Jobs - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF Performance Monitoring Jobs
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all VNF Performance Monitoring Jobs
    Check HTTP Response Status Code Is    405
    
PATCH all VNF Performance Monitoring Jobs - (Method not implemented)
    [Documentation]    Test ID: 7.3.4.1.11
    ...    Test title: PATCH all VNF Performance Monitoring Jobs - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF Performance Monitoring Jobs
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all VNF Performance Monitoring Jobs
    Check HTTP Response Status Code Is    405
    
DELETE all VNF Performance Monitoring Jobs - Method not implemented
    [Documentation]    Test ID: 7.3.4.1.12
    ...    Test title: DELETE all VNF Performance Monitoring Jobs - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to update VNF Performance Monitoring Jobs
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all VNF Performance Monitoring Jobs
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Monitoring Jobs Exist
    
GET all VNF Performance Monitoring Jobs as Paged Response
    [Documentation]    Test ID: 7.3.4.1.13
    ...    Test title: GET all VNF Performance Monitoring Jobs as Paged Response
    ...    Test objective: The objective is to test the retrieval of all the available VNF performance monitoring jobs as Paged Response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Performance Monitoring Jobs
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
GET VNF Performance Monitoring Jobs - Bad Request Response too Big
    [Documentation]    Test ID: 7.3.4.1.14
    ...    Test title: GET VNF Performance Monitoring Jobs - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of VNF performance monitoring jobs fails because response is too big, and perform the JSON schema validation of the failed operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNF.
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Performance Monitoring Jobs
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails
    
*** Keywords ***
GET all VNF Performance Monitoring Jobs
    Log    Trying to get all PM Jobs present in the VNFM
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with attribute-based filter
    Log    Trying to get all PM Jobs present in the VNFM, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${POS_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with all_fields attribute selector
    Log    Trying to get all PM Jobs present in the VNFM, using 'all_fields' filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with exclude_default attribute selector
    Log    Trying to get all VNF Packages present in the VNFM, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with fields attribute selector
    Log    Trying to get all VNF Packages present in the VNFM, using filter params
    Pass Execution If    ${FIELD_USAGE} == 0    Skipping test as VNFM is not supporting 'fields'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with exclude_fields attribute selector
    Log    Trying to get all VNF Packages present in the VNFM, using filter params
    Pass Execution If    ${FIELD_USAGE} == 0    Skipping test as VNFM is not supporting 'fields'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with invalid attribute-based filter
    Log    Trying to get all PM Jobs present in the VNFM, using an erroneous filter param
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${NEG_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Performance Monitoring Jobs with invalid resource endpoint    
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_job    # wrong URI /pm_job instead of /pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post Request Create new VNF Performance Monitoring Job
    Log    Creating a new PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/CreatePmJobRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for all VNF Performance Monitoring Jobs 
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PATCH Request for all VNF Performance Monitoring Jobs 
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all VNF Performance Monitoring Jobs 
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Performance Monitoring Jobs Exist
    Log    Checking that Pm Job still exists
    GET all VNF Performance Monitoring Jobs
    
Check Postcondition PmJob Exists
    Log    Checking that Pm Job exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmJob
    
Check HTTP Response Body PmJobs Matches the requested exclude_fields selector
    Log    Checking that reports element is missing
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Should Be Empty    ${reports}
    Log    Checking that reports element is missing
    ${criteria}=    Get Value From Json    ${response['body']}    $..criteria
    Should Be Empty    ${criteria}
    Log    Reports element is empty as expected

Check HTTP Response Body PmJobs Matches the requested fields selector
    Log    Trying to validate criteria schema
    ${criteria}=    Get Value From Json    ${response['body']}    $..criteria
    Validate Json    criteria.schema.json    ${criteria}
    Log    Validation for criteria schema OK
    Log    Trying to validate criteria schema
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Validate Json    reports.schema.json    ${reports[0]}
    Log    Validation for reports schema OK
    
Check HTTP Response Body PmJobs Matches the requested exclude_default selector
    Log    Checking that reports element is missing
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Should Be Empty    ${reports}
    Log    Reports element is empty as expected

Check HTTP Response Body PmJobs Matches the requested all_fields selector
    Log    Trying to validate criteria schema
    ${criteria}=    Get Value From Json    ${response['body']}    $..criteria
    Validate Json    criteria.schema.json    ${criteria}
    Log    Validation for criteria schema OK
    Log    Trying to validate criteria schema
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Validate Json    reports.schema.json    ${reports[0]}
    Log    Validation for reports schema OK
    Log    Validating _links schema
    ${links}=    Get Value From Json    ${response['body']}    $.._links
    Validate Json    links.schema.json    ${links[0]}
    Log    Validation for _links schema OK
    
Check HTTP Response Body PmJobs Matches the requested Attribute-Based Filter 
    Log    Checking that attribute-based filter is matched
    @{words} =  Split String    ${POS_FILTER}       ,${SEPERATOR} 
    Should Be Equal As Strings    ${response['body'][0]['objectInstanceIds']}    @{words}[1]

Check HTTP Response Body Does Not Contain reports
    Log    Checking that field element is missing
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Should Be Empty    ${reports}
    Log    Reports element is empty as expected
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response['status']}    ${status} 
    Log    Status code validated
    
Check HTTP Response Status Code Is 40x  
    Should Contain Any    ${response['status']}    401    403
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response.headers}    $..Link
    Should Not Be Empty    ${linkURL}