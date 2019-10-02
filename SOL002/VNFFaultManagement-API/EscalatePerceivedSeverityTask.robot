*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Library    JSONSchemaLibrary
Suite Setup    Check resource existance

*** Test Cases ***
Escalate the perceived severity 
    [Documentation]    Test ID: 6.3.4.3.1
    ...    Test title: Escalate the perceived severity
    ...    Test objective: To enable the consumer to escalate the perceived severity of an alarm that is represented by an individual alarm resource.
    ...    Pre-conditions: The resource representing the individual alarm has been created
    ...    Reference: section 7.4.4.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Post escalate severity
    Check HTTP Response Status Code Is    204
    
GET Escalate the perceived severity - Method not implemented
    [Documentation]    Test ID: 6.3.4.3.2
    ...    Test title: GET Escalate the perceived severity - Method not implemented
    ...    Test objective: to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.4.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Get escalate severity
    Check HTTP Response Status Code Is    405

PUT Escalate the perceived severity - Method not implemented
    [Documentation]    Test ID: 6.3.4.3.3
    ...    Test title: PUT Escalate the perceived severity - Method not implemented
    ...    Test objective: to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.4.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Put escalate severity
    Check HTTP Response Status Code Is    405
    
PATCH Escalate the perceived severity - Method not implemented
    [Documentation]    Test ID: 6.3.4.3.4
    ...    Test title: PATCH Escalate the perceived severity - Method not implemented
    ...    Test objective: to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.4.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Put escalate severity
    Check HTTP Response Status Code Is    405
    
    
DELETE Escalate the perceived severity - Method not implemented
    [Documentation]    Test ID: 6.3.4.3.5
    ...    Test title: DELETE Escalate the perceived severity - Method not implemented
    ...    Test objective: to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: section 7.4.4.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Delete escalate severity
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Integer    response status    200
POST escalate severity
    Log    escalate the perceived severity of an alarm with the VNFM
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    ${PerceivedSeverity}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
GET escalate severity
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
PUT escalate severity	
	log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    
     ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
PATCH escalate severity
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate  
     ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
DELETE escalate severity        
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate  
     ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK