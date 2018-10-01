*** Settings ***
Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT} 
#Library    RequestsLibrary

*** Test cases ***

Create a new vnfInstance
    Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    /vnflcm/v1/vnf_instances    {"vnfdId": "12345","vnfInstanceName": "Test-VnfInstance", "vnfInstanceDescription": "bla"}
    Output    response
    Integer    response status    201
    Log    Status code validated

Create a new vnfInstance Bad Request
    Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    /vnflcm/v1/vnf_instances    {"bad_request": "bad_example"}
    Output    response
    Integer    response status    400
    Log    Status code validated

Create a new vnfInstance Unauthorized
    Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${WRONG_AUTHORIZATION}"}
    Post    /vnflcm/v1/vnf_instances    {"vnfdId": "12345","vnfInstanceName": "Test-VnfInstance", "vnfInstanceDescription": "bla"}
    Output    response
    Integer    response status    401
    Log    Status code validated

Get information about multiple VNF instances  
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    /vnflcm/v1/vnf_instances
    Output    response
    Log    Validate Status code
    Integer    response status    200
    
    Log    Execute Query and validate against online spec
    GET    /vnflcm/v1/vnf_instances?fields=wrong_field
    Log    Validate Status code
    Integer    response status    400
    
*** Keywords ***

