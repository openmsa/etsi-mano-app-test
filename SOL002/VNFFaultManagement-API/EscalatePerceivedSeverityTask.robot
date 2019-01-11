*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL002-VNFFaultManagement-API.yaml
Suite Setup    Check resource existance

*** Test Cases ***
Escalate the perceived severity 
    [Documentation]    Test ID: 7.4.4.1
    ...    Test title: Escalate the perceived severity
    ...    Test objective: To enable the consumer to escalate the perceived severity of an alarm that is represented by an individual alarm resource.
    ...    Pre-conditions: The resource representing the individual alarm has been created
    ...    Reference: section 7.4.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Log    escalate the perceived severity of an alarm with the VNFM
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    ${PerceivedSeverity}
    Integer    response status    204
    Log    Status code validated
   
GET Escalate the perceived severity - Method not implemented
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    
    Log    Validate Status code
    Integer    response status    405

PUT Escalate the perceived severity - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    
    Log    Validate Status code
    Integer    response status    405

PATCH Escalate the perceived severity - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    
    Log    Validate Status code
    Integer    response status    405
    
DELETE Escalate the perceived severity - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}/escalate    
    Log    Validate Status code
    Integer    response status    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Integer    response status    200
