*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST API Version - Method not implemented
    [Documentation]    Test ID: 7.3.4.9.1
    ...    Test title: POST API version - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.1 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    POST API Version
	Check HTTP Response Status Code Is    405
    
GET API Version
    [Documentation]    Test ID: 7.3.4.9.2
    ...    Test title: GET API Version
    ...    Test objective: The objective is to test that GET method successfully return ApiVersionInformation
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.17.3.2 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET API Version
	Check HTTP Response Status Code Is    200
	Check HTTP Response Body Json Schema Is    ApiVersionInformation

PUT API Version - Method not implemented
    [Documentation]    Test ID:7.3.4.9.3
    ...    Test title: PUT API Version - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.3 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT API Version
	Check HTTP Response Status Code Is    405

PATCH API Version - Method not implemented
    [Documentation]    Test ID: 7.3.4.9.4
    ...    Test title: PATCH API Version - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.4 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH API Version
	Check HTTP Response Status Code Is    405
    
DELETE API Version - Method not implemented
    [Documentation]    Test ID: 7.3.4.9.5
    ...    Test title: DELETE API Version - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.5 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE API Version
	Check HTTP Response Status Code Is    405
	
POST API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 7.3.4.9.6
    ...    Test title: POST API version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.1 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    POST API Version
	Check HTTP Response Status Code Is    405
    
GET API Version with apiMajorVerion
    [Documentation]    Test ID: 7.3.4.9.7
    ...    Test title: GET API Version with apiMajorVerion
    ...    Test objective: The objective is to test that GET method successfully return ApiVersionInformation
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.17.3.2 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET API Version
	Check HTTP Response Status Code Is    200
	Check HTTP Response Body Json Schema Is    ApiVersionInformation

PUT API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID:7.3.4.9.8
    ...    Test title: PUT API Version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.3 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT API Version
	Check HTTP Response Status Code Is    405

PATCH API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 7.3.4.9.9
    ...    Test title: PATCH API Version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.4 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH API Version
	Check HTTP Response Status Code Is    405
    
DELETE API Version with apiMajorVerion - Method not implemented
    [Documentation]    Test ID: 7.3.4.9.10
    ...    Test title: DELETE API Version with apiMajorVerion - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 9.3.3.5 - ETSI NFV-SOL 013 v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE API Version
	Check HTTP Response Status Code Is    405

*** Keywords ***
POST API Version
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
GET API Version
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PUT API Version
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PATCH API Version
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
DELETE API Version
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
POST API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
GET API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PUT API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
PATCH API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
DELETE API Version with apiMajorVersion
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/v1/api_version
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 