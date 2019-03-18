*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    DependencyLibrary


*** Variables ***
${original_etag}    1234

*** Test Cases ***
POST Alarm - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Log    Validate Status code
    Output    response
    Integer    response status    405

Get information about an alarm
    [Documentation]    Test ID: 7.4.3.1
    ...    Test title: Get information about an alarm
    ...    Test objective: The objective is to read an individual alarm.
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Log    Query VNF The GET method queries information about an alarm.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${etag}    Output    response header ETag
    Set Suite Variable    &{original_etag}    ${etag}
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    Validate Json    alarm.schema.json    ${result}
    Log    Validation OK

PUT Alarm - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Log    Validate Status code
    Integer    response status    405

PATCH Alarm
    [Documentation]    Test ID: 7.4.3.2
    ...    Test title: Modify an individual alarm resource
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Set Headers    {"If-Match": "${original_etag[0]}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    Log    Validate Status code
    ${Etag_modified}=    Output    response headers ETag
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    Validate Json    AlarmModification.schema.json    ${result}
    Log    Validation OK

PATCH Alarm - Precondition failed
    [Documentation]    Test ID: 7.4.3.2-1
    ...    Test title: Modify an individual alarm resource - Precondition failed
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Set Headers    {"If-Match": "${original_etag[0]}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    Log    Validate Status code
    Integer    response status    412
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK


PATCH Alarm - Conflict
    [Documentation]    Test ID: 7.4.3.2-1
    ...    Test title: Modify an individual alarm resource - Conflict
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    Log    Validate Status code
    Integer    response status    409
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK


DELETE Alarm - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    Log    Validate Status code
    Integer    response status    405   
