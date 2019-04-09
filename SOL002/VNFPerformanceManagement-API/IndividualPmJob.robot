*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/IndividualPmJob.txt
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET individual VNF Performance Job
    [Documentation]    Test ID: 6.3.3.2.1
    ...    Test title: Get individual VNF Performance Job
    ...    Test objective: The objective is to test the retrieval of an individual VNF performance monitoring job and perform a JSON schema and content validation of the collected job data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: section 6.4.3.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual VNF Performance Job
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmJob
    Check HTTP Response Body Pm Job Identifier matches the requested Pm Job

GET individual VNF Performance Job with invalid resource identifier
    [Documentation]    Test ID: 6.3.3.2.2
    ...    Test title: Get individual VNF Performance Job with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF performance monitoring job fails when using an invalid resource identifier, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: section 6.4.3.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual VNF Performance Job with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

DELETE Individual VNF Performance Job
    [Documentation]    Test ID: 6.3.3.2.3
    ...    Test title: Delete Individual VNF Performance Job
    ...    Test objective: The objective is to test the deletion of an individual VNF performance monitoring job
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: section 6.4.3.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Job is no more available in the VNFM    
    Send Delete request for individual VNF Performance Job
    Check HTTP Response Status Code Is    204
    Check Postcondition VNF Pm Job is Deleted

DELETE Individual VNF Performance Job with invalid resource identifier
    [Documentation]    Test ID: 6.3.3.2.4
    ...    Test title: Delete individual VNF Performance Job with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual VNF performance monitoring job fails when using an invalid resource identifier, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: section 6.4.3.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Delete request for individual VNF Performance Job with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Individual VNF Performance Job - Method not implemented
    [Documentation]    Test ID: 6.3.3.2.5
    ...    Test title: POST Individual VNF Performance Job - method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF Performance Monitoring Job
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: section 6.4.3.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Job is not created on the VNFM
    Send Post request for individual VNF Performance Job
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Job is not Created

PUT Individual VNF Performance Job - Method not implemented
    [Documentation]    Test ID: 6.3.3.2.6
    ...    Test title: PUT Individual VNF Performance Job - method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing VNF Performance Monitoring Job
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: section 6.4.3.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Job is not modified by the operation
    Send Put request for individual VNF Performance Job
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Job is Unmodified (Implicit)

PATCH Individual VNF Performance Job - Method not implemented
    [Documentation]    Test ID: 6.3.3.2.7
    ...    Test title: PATCH Individual VNF Performance Job - method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing new VNF Performance Monitoring Job
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: section 6.4.3.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Job is not modified by the operation
    Send Patch request for individual VNF Performance Job
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Job is Unmodified (Implicit)
    
*** Keywords ***
GET individual VNF Performance Job
    Log    Trying to get a Pm Job present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET individual VNF Performance Job with invalid resource identifier  
    Log    Trying to perform a negative get, using erroneous PM Job identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual VNF Performance Job
    Log    Trying to delete an existing PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Delete request for individual VNF Performance Job with invalid resource identifier
    Log    Trying to perform a negative delete, using erroneous PM Job identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual VNF Performance Job    
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${newPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Put request for individual VNF Performance Job    
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Patch request for individual VNF Performance Job    
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Performance Job is not Created
    Log    Trying to get a new Pm Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${newPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Check Postcondition VNF Performance Job is Unmodified (Implicit)
    Log    Check Postcondition VNF PM job is not modified
    GET individual VNF Performance Job
    Log    Check Response matches original VNF Pm Job
    ${pmJob}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origresponse['body']['id']}    ${pmJob.id}
    Should Be Equal    ${origresponse['body']['criteria']}    ${pmJob.criteria}
    Should Be Equal    ${origresponse['body']['_links']}    ${pmJob._links}

Check Postcondition VNF Pm Job is Deleted
    Log    Check Postcondition
    GET individual VNF Performance Job
    Check HTTP Response Status Code Is    404

Check HTTP Response Body Pm Job Identifier matches the requested Pm Job
    Log    Going to validate Pm Job info retrieved
    Should Be Equal    ${response['body']['id']}    ${pmJobId} 
    Log    Pm Job identifier as expected
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response['status']}    ${status} 
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

