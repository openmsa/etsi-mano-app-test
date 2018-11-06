*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL003-VNFFaultManagement-API.yaml
Library     OperatingSystem
Library    DependencyLibrary

*** Variables ***
${Etag}=    an etag
${Etag_modified}=    a modified etag

*** Test cases ***
POST Alarm - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Log    Validate Status code
    Output    response
    Integer    response status    405

Get information about an alarm  
    Log    Query VNF The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Output    response
    ${Etag}=    Output    response headers Etag
    Log    Validate Status code
    Integer    response status    200

PUT Alarm - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH Alarm
    [Documentation]    This method modifies an individual alarm resource
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    Log    Validate Status code
    Output    response
    ${Etag_modified}=    Output    response headers Etag
    Integer    response status    200

PATCH Alarm - Conflict
    [Documentation]    Conflict
    ...    The operation cannot be executed currently, due to a conflict with the state of the “Individual alarm” resource. 
    ...    Typically, this is due to the fact that the alarm is already in the state that is requested to be set (such as trying to acknowledge an already-acknowledged alarm). 
    ...    The response body shall contain a ProblemDetails structure, in which the “detail” attribute should convey more information about the error.
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that the alarm is in ackownledged state
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    Log    Validate Status code
    Output    response
    Integer    response status    409

PATCH Alarm - Precondition failed
    [Documentation]    Precondition Failed
    ...    A precondition given in an HTTP request header is not fulfilled. Typically, this is due to an ETag mismatch, 
    ...    indicating that the resource was modified by another entity. The response body should contain a ProblemDetails structure, 
    ...    in which the “detail” attribute should convey more information about the error.
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Set Headers    {"If-Match": "${Etag}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    Log    Validate Status code
    Output    response
    Integer    response status    412

DELETE Alarm - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Log    Validate Status code
    Output    response
    Integer    response status    405   
