*** Settings ***
Resource    environment/variables.txt 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
...    spec=SOL003-VNFFaultManagement-API.yaml
Documentation    This resource represents an individual subscription for VNF alarms. 
...    The client can use this resource to read and to terminate a subscription to notifications related to VNF fault management.
Suite setup    Check resource existance 

*** Test Cases ***
Post Individual Subscription - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    Log    Validate Status code
    Output    response
    Integer    response status    405

Get Information about an individual subscription
    [Documentation]    Test ID: 7.4.4.5
    ...    Test title: Retrieve the alarm subscriptions
    ...    Test objective: The objective is to read an individual subscription for VNF alarms subscribed by the client
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: section 7.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    subscriptions.schema.json    ${json}
    Log    Validation OK

PUT an individual subscription - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}    
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH an individual subscription - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}    
    Log    Validate Status code
    Output    response
    Integer    response status    405
    
DELETE an individual subscription
    log    Try to delete an individual subscription
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}    
    Log    Validate Status code
    Output    response
    Integer    response status    204

*** Keywords ***   

Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200