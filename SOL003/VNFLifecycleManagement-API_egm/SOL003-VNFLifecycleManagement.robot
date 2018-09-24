*** Settings ***
Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    ../variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT} 

*** Test cases ***

Create a new vnfInstance
    Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "application/json"}
    Post    /vnflcm/v1/vnf_instances    {"vnfdId": "12345","vnfInstanceName": "Test-VnfInstance", "vnfInstanceDescription": "bla"}
    Log    Validate Status code
    Integer    response status    200
    

Get information about multiple VNF instances
    [Tags]  get   
   
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "application/json"}
    Set Headers  {"Authorization": "${AUTHORIZATION_TOKEN}"}
    Log    Execute Query and validate against online spec
    Get    /vnflcm/v1/vnf_instances
    Log    Validate Status code
    Integer    response status    200
    
    Log    Execute Query and validate against online spec
    GET    ${apiRoot}/vnflcm/v1/vnf_instances?fields=wrong_field
    Log    Validate Status code
    Integer    response status    400
    
