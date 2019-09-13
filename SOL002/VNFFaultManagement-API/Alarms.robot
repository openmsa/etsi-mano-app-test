*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem

*** Test Cases ***
POST Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.1
    ...    Test title: POST Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    POST Alarms Task
    Check HTTP Response Status Code Is    405

GET information about multiple alarms 
    [Documentation]    Test ID: 6.3.4.1.2
    ...    Test title: GET information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    GET Alarms Task
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

GET information about multiple alarms with filters 
    [Documentation]    Test ID: 6.3.4.1.3
    ...    Test title: GET information about multiple alarms - with filters
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

GET information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 6.3.4.1.4
    ...    Test title: GET information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.5
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PUT Alarms Task
    Check HTTP Response Status Code Is    405

PATCH Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.6
    ...    Test title: PATCH Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PATCH Alarms Task
    Check HTTP Response Status Code Is    405

DELETE Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.7
    ...    Test title: DELETE Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.6 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: the alarm is not deleted
    DELETE Alarms Task
    Check HTTP Response Status Code Is    405

*** Keywords ***
POST Alarms Task
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
PUT Alarms Task
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
PATCH Alarms Task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
DELETE Alarms Task
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}			
GET Alarms Task	
	Log    Query VNF The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
GET Alarms Task with filter
	Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
GET Alarms Task with invalid filter
	Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated 

