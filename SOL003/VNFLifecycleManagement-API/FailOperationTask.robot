*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL003-VNFLifecycleManagement-API.yaml
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This task resource represents the "Fail operation" operation. 
...    The client can use this resource to mark a VNF lifecycle management operation occurrence as "finally failed", 
...    i.e. change the state of the related VNF LCM operation occurrence resource to "FAILED", if it is not assumed that a subsequent retry or rollback will succeed. 
...    Once the operation is marked as "finally failed", it cannot be retried or rolled back anymore.
Suite Setup    Check resource existance

*** Test Cases ***
Post Fail operation task  
    [Documentation]    The POST method marks a VNF lifecycle management operation occurrence as "finally failed" if that operation occurrence is in "FAILED_TEMP" state.
    Log    Final fail a VNF lifecycle operation if that operation has experienced a temporary failure
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    Output    response
    Log    Validate Status code
    Integer    response status    202
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    Log    Validation OK

Post Fail operation task Conflict (Not-FAILED_TEMP)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Conflict. 
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that the VNF instance resource is not in FAILED_TEMP state, 
    ...    or another error handling action is starting, such as retry or rollback. 
    ...    The response body shall contain a ProblemDetails structure, in which the �detail� attribute should convey more information about the error.
    Depends on test failure  Check resource FAILED_TEMP
    Log    Final Fail an operation
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    Integer    response status    409
    Log    Status code validated
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

Post Fail operation task Conflict (parallel LCM operation)
    # TODO: Need to set the pre-condition of the test
    [Documentation]    Conflict
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that the VNF instance resource is not in FAILED_TEMP state, 
    ...    or another error handling action is starting, such as retry or rollback. 
    ...    The response body shall contain a ProblemDetails structure, in which the �detail� attribute should convey more information about the error.
    [Setup]    Launch another error handling action
    log    Final Fail an operation
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    Log    Validate Status code
    Integer    response status    409
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK
    [Teardown]    #We cannot know if the "scale" operation is finished easily because the 202 indicates only whether the operation has been accepted, not whether the operation has been finished

Post Fail operation task Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
    [Documentation]    Not Found
    ...    Error: The API producer did not find a current representation for the target resource or is not willing to disclose that one exists. 
    ...    Specifically in case of this task resource, the response code 404 shall also be returned 
    ...    if the task is not supported for the VNF LCM operation occurrence represented by the parent resource, 
    ...    which means that the task resource consequently does not exist. 
    ...    In this case, the response body shall be present, and shall contain a ProblemDetails structure, in which the �detail� attribute shall convey more information about the error.
    [Setup]    Check Fail not supported
    log    Final fail an operation
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    Log    Validate Status code
    Integer    response status    409
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Fail operation task - Method not implemented
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfInstanceId}/fail    
    Log    Validate Status code
    Integer    response status    405

PUT Fail operation task - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfInstanceId}/fail    
    Log    Validate Status code
    Integer    response status    405

PATCH Fail operation task - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfInstanceId}/fail    
    Log    Validate Status code
    Integer    response status    405
    
DELETE Fail operation task - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfInstanceId}/fail    
    Log    Validate Status code
    Integer    response status    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Integer    response status    200

Launch another error handling action
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry
    Integer    response status    202
    
Check Fail not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    # how to check if Fail is not supported?

Check resource FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP