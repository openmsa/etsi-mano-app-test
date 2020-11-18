*** Settings ***
Resource   environment/variables.txt 
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This resource represents grants. The client can use this resource to obtain permission
...     from the NFVO to perform a particular VNF lifecycle operation.

*** Variables ***
${response}    {}
${retry}   2 min
${polling}    10 sec

*** Test Cases ***
Requests a grant for a particular VNF lifecycle operation - Synchronous mode
    [Documentation]    Test ID: 7.3.2.1.1
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Synchronous mode
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation and perform a JSON schema validation on the returned grant data structure
    ...    Pre-conditions: 
    ...    Reference: Clause 9.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO can decide immediately what to respond to a grant request
    ...    Post-Conditions: The grant information is available to the VNFM.
    Send Request Grant Request in Synchronous mode
    Check HTTP Response Status Code Is    201
    Check Operation Occurrence Id existence 
    Check HTTP Response Body Json Schema Is    grant


Requests a grant for a particular VNF lifecycle operation - Asynchronous mode
    [Documentation]    Test ID: 7.3.2.1.2
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Asynchronous mode
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation and perform a JSON schema validation on the returned grant data structure
    ...    Pre-conditions: 
    ...    Reference: Clause 9.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO can not decide immediately what to respond to a grant request
    ...    Post-Conditions: The grant information is available to the VNFM.
    Send Request Grant Request in Asynchronous mode
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id existence 
    Check HTTP Response Body Json Schema Is    grant
    Wait for individual grant successful notification 

Requests a grant for a particular VNF lifecycle operation - Forbidden 
    [Documentation]    Test ID: 7.3.2.1.3
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Forbidden 
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation and the grant is rejected
    ...    Pre-conditions: none
    ...    Reference: Clause 9.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Request for a new Grant Forbiden Operation
    Check HTTP Response Status Code Is    403
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET Grants - Method not implemented
    [Documentation]    Test ID: 7.3.2.1.4
    ...    Test title: GET Grants - Method not implemented
    ...    Test objective: The objective is to test that GET method is not allowed for Life cycle operation granting 
    ...    Pre-conditions: none
    ...    Reference: Clause 9.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions:   none
    Get Grants
    Check HTTP Response Status Code Is    405
    
PUT Grants - Method not implemented
     [Documentation]    Test ID: 7.3.2.1.5
    ...    Test title: PUT Grants - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed for Life cycle operation granting 
    ...    Pre-conditions: none
    ...    Reference: Clause 9.4.2.3.3 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Put Grants
    Check HTTP Response Status Code Is    405
    
PATCH Grants - Method not implemented
    [Documentation]    Test ID: 7.3.2.1.6
    ...    Test title: PATCH Grants - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: Clause 9.4.2.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Patch Grants
    Check HTTP Response Status Code Is    405
    
DELETE Grants - Method not implemented
    [Documentation]    Test ID: 7.3.2.1.7
    ...    Test title: DELETE Grants - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: Clause 9.4.2.3.5 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions:  resources are not deleted
    Delete Grants
    Check HTTP Response Status Code Is    405
    Get an individual grant - Successful
    
*** Keywords ***
Wait for individual grant successful notification
    Wait Until Keyword Succeeds    ${retry}   ${polling}    Get an individual grant - Successful
Send Request Grant Request in Synchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 0    The Granting process is asynchronous mode. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
    
Send Request Grant Request in Asynchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 1    The Granting process is synchronous mode. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
    
Send Request for a new Grant Forbiden Operation   
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Log    The grant request should be rejected
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRejectedRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
   
Send Request Grant Request
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}    allow_redirects=false
    ${resp}    Output    response
    ${result}=    evaluate    json.loads(json.dumps(${resp}))    json
    Log  ${result}
    Set Suite Variable    ${response}    ${result}
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
    Log    Status code validated

Check Operation Occurrence Id existence 
    ${occId}=    Get Value From Json    ${response['headers']}    $..Location
    Should Not Be Empty    ${occId}

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    
Get an individual grant - Successful
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${response['headers']['Location']}
    Log    Validate Status code
    Integer    response status    200
    
Get Grants
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
    
Put Grants
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
    
Patch Grants
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
    
    
Delete Grants
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/grants
    ${body}=    Output    response
    Set Suite Variable    ${response}    ${body}
    
    
