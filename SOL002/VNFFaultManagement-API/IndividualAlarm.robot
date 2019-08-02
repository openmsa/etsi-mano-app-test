*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt  
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    DependencyLibrary


*** Variables **
${original_etag}    1234


*** Test Cases ***
POST Alarm - Method not implemented
    [Documentation]    Test ID: 6.3.4.2.1
    ...    Test title: POST Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.3.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    POST Alarm Task
    Check HTTP Response Status Code Is    405


Get information about an individual alarm
    [Documentation]    Test ID: 6.3.4.2.2
    ...    Test title: Get information about an individual alarm
    ...    Test objective: The objective is to read an individual alarm.
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.2  - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    GET Alarm Task
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarm
    


PUT Alarm - Method not implemented
     [Documentation]    Test ID: 6.3.4.2.3
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.3.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PUT Alarm Task
    Check HTTP Response Status Code Is    405


PATCH Alarm
    [Documentation]    Test ID: 6.3.4.2.3
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.3.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PUT Alarm Task
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is     alarmModifications
    
PATCH Alarm - Precondition failed
    [Documentation]    Test ID: 6.3.4.2.4
    ...    Test title: Modify an individual alarm resource - Precondition failed
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    PUT Alarm Task
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is     ProblemDetails
    
PATCH Alarm - Conflict
    [Documentation]    Test ID: 6.3.4.2.5
    ...    Test title: Modify an individual alarm resource - Precondition failed
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    PUT Alarm Task
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is     ProblemDetails
    

DELETE Alarm - Method not implemented
    [Documentation]    Test ID: 6.3.4.2.6
    ...    Test title: DELETE Alarm - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.3.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE Alarm Task
    Check HTTP Response Status Code Is    405

*** Keywords ***
POST Alarm Task
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
PUT Alarm Task
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}     ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
PATCH Alarm Task
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Set Headers  {"If-Match": "${original_etag[0]}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
DELETE Alarm Task
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}			
GET Alarm Task	
	Log    Query VNF The GET method queries information about individual alarm.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${etag}    Output    response headers ETag
    Set Suite Variable    &{original_etag}    ${etag}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
GET Alarm Task with filter
	Log    Query VNF The GET method queries information about individual alarm with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
GET Alarm Task with invalid filter
	Log    Query VNF The GET method queries information about individual alarm with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	