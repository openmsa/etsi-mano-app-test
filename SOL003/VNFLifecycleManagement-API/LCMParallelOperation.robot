*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Scale a vnfInstance
    [Documentation]    Instantiate VNF The POST method instantiates a VNF instance.
    Log    Trying to Instantiate a vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${conflicVnfInstanceId}/scale    ${body}
    Integer    response status    202
    Log    Status code validated
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    Log    Validation OK
    
    
Scale a vnfInstance Conflict (parallel LCM operation)
    # TODO: Need to set the pre-condition of the test
    [Documentation]    Conflict
    ...    The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Typically, this is due to the fact that the VNF instance resource is in NOT-INSTANTIATED state, or that another lifecycle management operation is ongoing. 
    ...    The response body shall contain a ProblemDetails structure, in which the �detail� attribute should convey more information about the error.
    log    Trying to Scale a vnf Instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${conflicVnfInstanceId}/scale    ${body}
    Integer    response status    409
    Log    Status code validated
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
    
