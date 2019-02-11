*** Settings ***
Resource    environment/configuration.txt
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
...    spec=SOL003-VNFLifecycleManagement-API.yaml
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This resource represents an individual VNF instance. The client can use this resource to modify and delete the 
...    underlying VNF instance, and to read information about the VNF instance.
Suite Setup    Check resource existance

*** Variables ***
${Etag}=    an etag
${Etag_modified}=    a modified etag

*** Test Cases ***
Post Individual VNFInstance - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Log    Validate Status code
    Integer    response status    405

Get Information about an individual VNF Instance
    log    Trying to get information about an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Log    Validate Status code
    ${Etag}=    Output    response headers Etag
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    Validate Json    vnfInstance.schema.json    ${result}
    Log    Validation OK
    
PUT Individual VNFInstance - Method not implemented 
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    Log    Validate Status code
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
    ${body}=    Get File    json/patchBodyRequest.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${body}
    Log    Validate Status code
    ${Etag_modified}=    Output    response headers Etag
    Integer    response status    202
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    Log    Validation OK

PATCH Individual VNFInstance Precondition failed
    [Documentation]    Precondition Failed
    ...    A precondition given in an HTTP request header is not fulfilled. 
    ...    Typically, this is due to an ETag mismatch, indicating that the resource was modified by another entity. 
    ...    The response body should contain a ProblemDetails structure, in which the �detail� attribute should convey more information about the error.
    Depends On Test    PATCH Individual VNFInstance    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to modify an individual VNF instance Precondition failed
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Set Headers    {"If-Match": "${Etag}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/patchBodyRequest.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${body}
    Log    Validate Status code
    Integer    response status    412
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

PATCH Individual VNFInstance Conflict
    # TODO: Need to set the pre-condition of the test
    [Documentation]    Conflict
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that another LCM operation is ongoing. The response body shall contain a ProblemDetails structure, in which the �detail� attribute should convey more information about the error.
    [Setup]    Launch another LCM operation
    log    Trying to modify an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/patchBodyRequest.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${body}
    Log    Validate Status code
    Integer    response status    409
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
    [Teardown]    #We cannot know if the "scale" operation is finished easily because the 202 indicates only whether the operation has been accepted, not whether the operation has been finished

DELETE Individual VNFInstance
    [Documentation]    Delete VNF Identifier This method deletes an individual VNF instance resource.
    log    Trying to delete an individual VNF instance
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    Log    Validate Status code
    Integer    response status    204
    Log    Validation OK

DELETE Individual VNFInstance Conflict
    # TODO: Need to set the pre-condition of the test. The VnfInstance shall in INSTANTIATED state
    [Documentation]    Conflict 
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that the VNF instance resource is in INSTANTIATED state. 
    ...    The response body shall contain a ProblemDetails structure, in which the �detail� attribute should convey more information about the error.
    [Setup]    Check resource instantiated
    log    Trying to delete an individual VNF instance Conflict
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    Log    Validate Status code
    Integer    response status    409
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
    
*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Check resource instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    String    response body instantiationState    INSTANTIATED

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/scaleVnfToLevelRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level    ${body}
    Integer    response status    202

