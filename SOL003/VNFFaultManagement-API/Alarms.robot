*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem

*** Test Cases ***
POST Alarms - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Integer    response status    405

Get information about multiple alarms  
    [Documentation]    Test ID: 7.4.2.1
    ...    Test title: Get information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Query VNF The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    Validate Json    Alarms.schema.json    ${result}
    Log    Validation OK

Get information about multiple alarms with filters 
    [Documentation]    Test ID: 7.4.2.2
    ...    Test title: Get information about multiple alarms - with filters
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    Validate Json    Alarms.schema.json    ${result}
    Log    Validation OK

Get information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.4.2.2-1
    ...    Test title: Get information about multiple alarms - with Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Query VNF The GET method queries information about multiple alarm instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    Log    Validate Status code
    Integer    response status    400
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
    
PUT Alarms - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Integer    response status    405

PATCH Alarms - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Integer    response status    405

DELETE Alarms - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Integer    response status    405
