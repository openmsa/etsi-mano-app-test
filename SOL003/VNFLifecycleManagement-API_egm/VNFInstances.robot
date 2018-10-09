*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    variables.txt 
Library    REST    http://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL003-VNFLifecycleManagement-API.yaml

*** Test cases ***

Create a new vnfInstance
    Log    Create VNF instance by POST to ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    {"vnfdId": "${vnfInstanceId}","vnfInstanceName": "${vnfInstanceName}", "vnfInstanceDescription": "${vnfInstanceDescription}"}
    Output    response
    Integer    response status    201
    Log    Status code validated    

# Create a new vnfInstance Bad Request
    # Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    # Set Headers  {"Accept":"${ACCEPT}"}  
    # Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    # Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    # Post    /vnflcm/v1/vnf_instances    {"bad_request": "bad_example"}
    # Output    response
    # Integer    response status    400
    # Log    Status code validated

# Create a new vnfInstance Unauthorized
    # Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    # Set Headers  {"Accept":"${ACCEPT}"}  
    # Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    # #Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${WRONG_AUTHORIZATION}"}
    # Post    /vnflcm/v1/vnf_instances    {"vnfdId": "12345","vnfInstanceName": "Test-VnfInstance", "vnfInstanceDescription": "bla"}
    # Output    response
    # Integer    response status    401
    # Log    Status code validated
    
# Create a new vnfInstance Forbidden
    # Log    Create VNF instance by POST to /vnflcm/v1/vnf_instances
    # Set Headers  {"Accept":"${ACCEPT}"}  
    # Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    # Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${WRONG_AUTHORIZATION}"}
    # Post    /vnflcm/v1/vnf_instances    {"vnfdId": "12345","vnfInstanceName": "Test-VnfInstance", "vnfInstanceDescription": "bla"}
    # Output    response
    # Integer    response status    403
    # Log    Status code validated

Get information about multiple VNF instances  
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Output    response
    Log    Validate Status code
    Integer    response status    200

Get information about multiple VNF instances Bad Request Invalid attribute-based filtering parameters
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?attribute_not_exist=some_value
    Log    Validate Status code
    Output    response
    Integer    response status    400

Get information about multiple VNF instances Bad Request Invalid attribute selector
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?fields=wrong_field
    Log    Validate Status code
    Output    response
    Integer    response status    400

# Get information about multiple VNF instances Unauthorized
    # Log    Query VNF The GET method queries information about multiple VNF instances.
    # Set Headers  {"Accept":"${ACCEPT}"}  
    # Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    # Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${WRONG_AUTHORIZATION}"}
    # Get    /vnflcm/v1/vnf_instances
    # Output    response
    # Integer    response status    401
    # Log    Status code validated

# Get information about multiple VNF instances Forbidden
    # Log    Query VNF The GET method queries information about multiple VNF instances
    # Set Headers  {"Accept":"${ACCEPT}"}  
    # Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    # Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${WRONG_AUTHORIZATION}"}
    # Get    /vnflcm/v1/vnf_instances
    # Output    response
    # Integer    response status    403
    # Log    Status code validated
    
PUT VNFInstances - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    {"vnfInstanceDescription": "${vnfInstanceDescription_Update}"}
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH VNFInstances - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    {"vnfInstanceDescription": "${vnfInstanceDescription_Update}"}
    Log    Validate Status code
    Output    response
    Integer    response status    405

DELETE VNFInstances - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Log    Validate Status code
    Output    response
    Integer    response status    405
    
*** Keywords ***

