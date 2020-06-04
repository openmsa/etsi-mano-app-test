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
    ...    Test title: POST Alarm - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.3.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    POST Alarm Task
    Check HTTP Response Status Code Is    405


GET information about an individual alarm
    [Documentation]    Test ID: 6.3.4.2.2
    ...    Test title: GET information about an individual alarm
    ...    Test objective: The objective is to read an individual alarm.
    ...    Pre-conditions: The related alarm exists
    ...    Reference: Clause 7.4.3.3.2  - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    GET Alarm Task
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarm
    


PUT Individual Alarm - Method not implemented
     [Documentation]    Test ID: 6.3.4.2.3
    ...    Test title: PUT Individual Alarm - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.3.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PUT Alarm Task
    Check HTTP Response Status Code Is    405


PATCH Individual Alarm
    [Documentation]    Test ID: 6.3.4.2.4
    ...    Test title: PATCH Individual Alarm
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: Clause 7.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PATCH Alarm Task
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is     alarmModifications
    
PATCH Individual Alarm - Precondition failed
    [Documentation]    Test ID: 6.3.4.2.5
    ...    Test title: PATCH Individual Alarm - Precondition failed
    ...    Test objective: The objective is to attempt to Modify an individual alarm resource, where the precondition was not met
    ...    Pre-conditions: The related alarm exists
    ...    Reference: Clause 7.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    PATCH Alarm Task with wrong precondition
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is     ProblemDetails
    
PATCH Individual Alarm - Conflict
    [Documentation]    Test ID: 6.3.4.2.6
    ...    Test title: PATCH Individual Alarm - Conflict
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: Clause 7.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    PATCH Alarm Task
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is     ProblemDetails
    

DELETE Individual Alarm - Method not implemented
    [Documentation]    Test ID: 6.3.4.2.7
    ...    Test title: DELETE Individual Alarm - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.3.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: alarm not deleted
    DELETE Alarm Task
    Check HTTP Response Status Code Is    405

*** Keywords ***
POST Alarm Task
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
PUT Alarm Task
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}     ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
PATCH Alarm Task
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Set Headers  {"If-Match": "${original_etag[0]}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
PATCH Alarm Task with wrong precondition
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
DELETE Alarm Task
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}			
GET Alarm Task	
	Log    Query VNF The GET method queries information about individual alarm.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${etag}    Output    response headers ETag
    Set Suite Variable    &{original_etag}    ${etag}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
GET Alarm Task with filter
	Log    Query VNF The GET method queries information about individual alarm with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
GET Alarm Task with invalid filter
	Log    Query VNF The GET method queries information about individual alarm with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK
