*** Settings ***
Resource   environment/variables.txt 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Documentation    This resource represents an individual grant. The client can use this resource to read the grant.
...    It is determined by means outside the scope of the present document, such as configuration or policy,
...    how long an individual grant is available.

*** Variables ***
${response}    {}

*** Test Cases ***
POST Individual Grant - Method not implemented
    [Documentation]    Test ID: 7.3.2.2.1
    ...    Test title: POST Individual Grant - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.2.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post individual Grant
    Check HTTP Response Status Code Is    405

GET an individual grant - Successful
    [Documentation]    Test ID: 7.3.2.2.2
    ...    Test title: GET an individual grant - Successful
    ...    Test objective: The objective is to successfully request a grant for a particular VNF lifecycle operation 
    ...    Pre-conditions: The  grant information is available to the VNFM
    ...    Reference: clause 9.4.3.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get individual grant
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    grant
    
GET an individual grant - Process ongoing
    [Tags]    no-synchronous-mode
    [Documentation]    Test ID: 7.3.2.2.3
    ...    Test title: GET an individual grant - Process ongoing
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation when process is ongoing and no grant is avaliable yet
    ...    Pre-conditions: The process of creating the grant is ongoing, no grant is available yet.
    ...    Reference: clause 9.4.3.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get individual grant
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    grant
    
GET an individual grant - grant rejected
    [Tags]    no-synchronous-mode
    [Documentation]    Test ID: 7.3.2.2.4
    ...    Test title: GET an individual grant - grant rejected
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation when grant is rejected
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.3.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get individual grant
    Check HTTP Response Status Code Is    403
	Check HTTP Response Body Json Schema Is    ProblemDetails

PUT an individual grant - Method not implemented
    [Documentation]    Test ID: 7.3.2.2.5
    ...    Test title: PUT an individual grant - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.3.3.3 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT individual Grant
    Check HTTP Response Status Code Is    405

PATCH an individual grant - Method not implemented
    [Documentation]    Test ID: 7.3.2.2.6
    ...    Test title: PATCH an individual grant - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.3.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Patch individual Grant
    Check HTTP Response Status Code Is    405
    
DELETE an individual grant - Method not implemented
    [Documentation]    Test ID: 7.3.2.2.7
    ...    Test title: DELETE an individual grant - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to for Life cycle operation granting  
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.3.3.5 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Delete individual Grant
    Check HTTP Response Status Code Is    405

*** Keywords ***    
Get individual grant
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Check resource existence
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200
    
Post individual Grant
    log    Trying to read an individual grant
    Pass Execution If    ${SYNC_MODE} == 1   Skipping. Synchronous mode is supported    
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Put individual Grant
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Patch individual Grant
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Delete individual Grant
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    ${body}=    Output    response
    Set Suite Variable    &{response}    ${body}
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response[0]['body']}
