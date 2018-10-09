*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT}    
...    spec=SOL003-VNFLifecycleManagement-API.yaml
Documentation    This resource represents an individual VNF instance. The client can use this resource to modify and delete the 
...    underlying VNF instance, and to read information about the VNF instance.

*** Test Cases ***
Post Individual VNFInstance - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Log    Validate Status code
    Output    response
    Integer    response status    405

Get Information about an individual VNF Instance
    log    Trying to get information about an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Log    Validate Status code
    Output    response
    Integer    response status    200
    
PUT Individual VNFInstance - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH Individual VNFInstance
    [Documentation]    Modify VNF Information
    ...    This method modifies an individual VNF instance resource. 
    ...    Changes to the VNF configurable properties are applied to the configuration in the VNF instance, and are reflected in the representation of this resource. 
    ...    Other changes are applied to the VNF instance information managed by the VNFM, and are reflected in the representation of this resource
    log    Trying to modify an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${PATCH_BODY_REQUEST}
    Log    Validate Status code
    Output    response
    Integer    response status    202

PATCH Individual VNFInstance Conflict
    # TODO: Need to set the pre-condition of the test
    [Documentation]    Conflict
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that another LCM operation is ongoing. The response body shall contain a ProblemDetails structure, in which the “detail” attribute should convey more information about the error.
    log    Trying to modify an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${PATCH_BODY_REQUEST_CONFLICT}
    Log    Validate Status code
    Output    response
    Integer    response status    409

PATCH Individual VNFInstance Precondition failed
    # TODO: Need to set the pre-condition of the test
    # TODO: According to the Etag mechanism principle (https://www.logicbig.com/quick-info/web/etag-header.html), a request header 'If-None-Match' is needed to trigger the Etag validation. 
    # But this request header is not mentioned in the spec  
    [Documentation]    Precondition Failed
    ...    A precondition given in an HTTP request header is not fulfilled. 
    ...    Typically, this is due to an ETag mismatch, indicating that the resource was modified by another entity. 
    ...    The response body should contain a ProblemDetails structure, in which the “detail” attribute should convey more information about the error.
    log    Trying to modify an individual VNF instance Precondition failed
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${PATCH_BODY_REQUEST}
    Log    Validate Status code
    Output    response
    Integer    response status    412

DELETE Individual VNFInstance
    [Documentation]    Delete VNF Identifier This method deletes an individual VNF instance resource.
    log    Trying to delete an individual VNF instance
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    Log    Validate Status code
    Output    response
    Integer    response status    204

DELETE Individual VNFInstance Conflict
    # TODO: Need to set the pre-condition of the test. The VnfInstance shall in INSTANTIATED state
    [Documentation]    Conflict 
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that the VNF instance resource is in INSTANTIATED state. 
    ...    The response body shall contain a ProblemDetails structure, in which the “detail” attribute should convey more information about the error.
    log    Trying to delete an individual VNF instance Conflict
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    Log    Validate Status code
    Output    response
    Integer    response status    409
    
    