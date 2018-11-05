*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL003-VNFFaultManagement-API.yaml

*** Test cases ***
POST Alarms - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Output    response
    Integer    response status    405

Get information about multiple alarms  
    Log    Query VNF The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Output    response
    Log    Validate Status code
    Integer    response status    200

Get information about multiple alarms with filters 
    Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    Output    response
    Log    Validate Status code
    Integer    response status    200

Get information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    Log    Validate Status code
    Output    response
    Integer    response status    400
    
PUT Alarms - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH Alarms - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Output    response
    Integer    response status    405

DELETE Alarms - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    Log    Validate Status code
    Output    response
    Integer    response status    405

