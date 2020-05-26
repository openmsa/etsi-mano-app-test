*** Settings ***

Resource    environment/variables.txt

Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST API Version - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.1
    ...    Test title: POST API version - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.1 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    POST API Version
	Check HTTP Response Status Code Is    405
    
GET API Version
    [Documentation]    Test ID: 5.3.1.10.2
    ...    Test title: GET API Version
    ...    Test objective: The objective is to test that GET method successfully return ApiVersionInformation
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.2 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET API Version
	Check HTTP Response Status Code Is    200
	Check HTTP Response Body Json Schema Is    ApiVersionInformation

PUT API Version - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.3
    ...    Test title: PUT API Version - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.3 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT API Version
	Check HTTP Response Status Code Is    405

PATCH API Version - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.4
    ...    Test title: PATCH API Version - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.4 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH API Version
	Check HTTP Response Status Code Is    405
    
DELETE API Version - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.5
    ...    Test title: DELETE API Version - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.5 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE API Version
	Check HTTP Response Status Code Is    405
	
POST API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.6
    ...    Test title: POST API version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.1 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    POST API Version
	Check HTTP Response Status Code Is    405
    
GET API Version with apiMajorVerion
    [Documentation]    Test ID: 5.3.1.10.7
    ...    Test title: GET API Version with apiMajorVerion
    ...    Test objective: The objective is to test that GET method successfully return ApiVersionInformation
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.2 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET API Version
	Check HTTP Response Status Code Is    200
	Check HTTP Response Body Json Schema Is    ApiVersionInformation

PUT API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.8
    ...    Test title: PUT API Version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.3 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT API Version
	Check HTTP Response Status Code Is    405

PATCH API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.9
    ...    Test title: PATCH API Version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.4 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH API Version
	Check HTTP Response Status Code Is    405
    
DELETE API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 5.3.1.10.10
    ...    Test title: DELETE API Version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 9.3.3.3.5 - ETSI GS NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE API Version
	Check HTTP Response Status Code Is    405

*** Keywords ***
POST API Version
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
GET API Version
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PUT API Version
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PATCH API Version
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
DELETE API Version
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
POST API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
GET API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PUT API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PATCH API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
DELETE API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT_JSON}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated 

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK