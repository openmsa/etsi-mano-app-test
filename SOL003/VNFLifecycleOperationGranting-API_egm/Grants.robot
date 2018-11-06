*** Settings ***
Resource    variables.txt 
Library    REST    http://${NFVO_HOST}:${NFVO_PORT} 
...        spec=SOL003-VNFLifecycleOperationGranting-API.yaml
Library     OperatingSystem
Documentation    This resource represents grants. The client can use this resource to obtain permission
...     from the NFVO to perform a particular VNF lifecycle operation.

*** Test Cases ***
Create a new Grant - Synchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 0    The Granting process is asynchronous mode. Skipping the test
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    Output    response
    Integer    response status    201
    Log    Status code validated

Create a new Grant - Asynchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 1    The Granting process is synchronous mode. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    json/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    Output    response
    Integer    response status    202
    Log    Status code validated

Create a new Grant - Forbidden
    # TODO: How to set up the pre-condition for this test?
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Log    The grant request should be rejected
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    json/grantRejectedRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    Output    response
    Integer    response status    403
    Log    Status code validated

GET Grants - Method not implemented
    Log    Trying to perform a GET. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants
    Output    response
    Log    Validate Status code
    Integer    response status    405
    
PUT subscriptions - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH subscriptions - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    Log    Validate Status code
    Output    response
    Integer    response status    405

DELETE subscriptions - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Log    Validate Status code
    Output    response
    Integer    response status    405
    