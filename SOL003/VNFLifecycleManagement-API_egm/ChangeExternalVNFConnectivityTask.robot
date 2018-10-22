*** Settings ***
Resource    variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL003-VNFLifecycleManagement-API.yaml
Library     DependencyLibrary
Suite setup    Check resource existance

*** Test Cases ***
Change external VNF connectivity 
    [Documentation]   The POST method changes the external connectivity of a VNF instance
    Log    Trying to change the external connectivity of a VNF instance.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    ${Change_Ext_Vnf_Connectivity_REQUEST}
    Integer    response status    202
    Log    Status code validated

Change external VNF connectivity Conflict (parallel LCM operation)
    # TODO: Need to set the pre-condition of the test
    [Documentation]    Conflict
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that another LCM operation is ongoing.
    ...    The response body shall contain a ProblemDetails structure, in which the “detail” attribute should convey more information about the error.
    [Setup]    Launch another LCM operation
    log    Trying to change the deployment flavour of a VNF instance.
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    ${Change_Ext_Vnf_Connectivity_REQUEST}
    Log    Validate Status code
    Output    response
    Integer    response status    409
    [Teardown]    #We cannot know if the "scale" operation is finished easily because the 202 indicates only whether the operation has been accepted, not whether the operation has been finished
       
    
GET Change external VNF connectivity - Method not implemented
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    
    Log    Validate Status code
    Output    response
    Integer    response status    405

PUT Change external VNF connectivity - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH Change external VNF connectivity - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    
    Log    Validate Status code
    Output    response
    Integer    response status    405
    
DELETE Change external VNF connectivity - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    
    Log    Validate Status code
    Output    response
    Integer    response status    405

*** Key words ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${Scale_Vnf_REQUEST}
    Integer    response status    202