*** Settings ***
Resource   environment/variables.txt 
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This resource represents grants. The client can use this resource to obtain permission
...     from the NFVO to perform a particular VNF lifecycle operation.

*** Variables ***
${response}    {}

*** Test Cases ***
Requests a grant for a particular VNF lifecycle operation - Synchronous mode
    [Documentation]    Test ID: 7.3.2.1.1
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Synchronous mode
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation  and perform a JSON schema validation on the returned grant data structure
    ...    Pre-conditions: 
    ...    Reference: section 9.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The NFVO can decide immediately what to respond to a grant request
    ...    Post-Conditions: The grant information is available to the VNFM.
    Send Request Grant Request in Synchronous mode
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    grant

Requests a grant for a particular VNF lifecycle operation - Asynchronous mode
    [Documentation]    Test ID: 7.3.2.1.2
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Asynchronous mode
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation 
    ...    Pre-conditions: 
    ...    Reference: section 9.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The NFVO can not decide immediately what to respond to a grant request
    ...    Post-Conditions: The grant information is available to the VNFM.
    Send Request Grant Request in Asynchronous mode
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    grant
    Wait Until Keyword Succeeds    2 min   10 sec    Get an individual grant - Successful

Request a new Grant - Forbidden
    [Documentation]    Test ID: 7.3.2.1.3
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Forbidden 
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation and check the content of the problem details data structure returned
    ...    Pre-conditions: The grant should not be accorded
    ...    Reference: section 9.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Send Request a new Grant Forbiden
    Check HTTP Response Status Code Is    403
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET Grants - Method not implemented
    [Documentation]    Test ID: 7.3.2.1.4
    ...    Test title: GET Grants - Method not implemented
    ...    Test objective: The objective is to test that GET method is not allowed to for Life cycle operation granting 
    ...    Pre-conditions: none
    ...    Reference: section 9.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:   none
    Get Grants
    Check HTTP Response Status Code Is    405
    
PUT Grants - Method not implemented
     [Documentation]    Test ID: 7.3.2.1.5
    ...    Test title: PUT Grants - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to for Life cycle operation granting 
    ...    Pre-conditions: none
    ...    Reference: section 9.4.2.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Put Grants
    Check HTTP Response Status Code Is    405
    
PATCH Grants - Method not implemented
    [Documentation]    Test ID: 7.3.2.1.6
    ...    Test title: PATCH Grants - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: section 9.4.2.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Patch Grants
    Check HTTP Response Status Code Is    405
    
DELETE Grants - Method not implemented
    [Documentation]    Test ID: 7.3.2.1.7
    ...    Test title: DELETE Grants - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: section 9.4.2.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Delete Grants
    Check HTTP Response Status Code Is    405
    
*** Keywords ***
Send Request Grant Request in Synchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 0    The Granting process is asynchronous mode. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Send Request Grant Request in Asynchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 1    The Granting process is synchronous mode. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Send Request a new Grant Forbiden    
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Log    The grant request should be rejected
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRejectedRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal as Strings   ${response[0]['status_code']}    ${expected_status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response[0]['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK
    
Get an individual grant - Successful
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${response[0]['headers']['Location']}
    Log    Validate Status code
    Integer    response status    200
    ${result}=    Output    response body
    Validate Json    grant.schema.json    ${result}
    Log    Validation OK
    
Get Grants
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Put Grants
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Patch Grants
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
    
Delete Grants
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
    