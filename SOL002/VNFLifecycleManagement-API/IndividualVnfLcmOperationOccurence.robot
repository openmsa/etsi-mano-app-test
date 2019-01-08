*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
...    spec=SOL002-VNFLifecycleManagement-API.yaml
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This resource represents a VNF lifecycle management operation occurrence. The client can use this resource to read
...    status information about an individual VNF lifecycle management operation occurrence. Further, the client can use task
...    resources which are children of this resource to request cancellation of an operation in progress, and to request the
...    handling of operation errors via retrying the operation, rolling back the operation, or permanently failing the operation

*** Test Cases ***
Post Individual VNF LCM OP occurences - Method not implemented
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Log    Validate Status code
    Integer    response status    405

Get Individual VNF LCM OP occurences
    [Documentation]    Get Operation Status
    ...    The client can use this method to retrieve status information about a VNF lifecycle management operation occurrence 
    ...    by reading an individual �VNF LCM operation occurrence� resource.
    Log    Query status information about multiple VNF lifecycle management operation occurrences.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfLcmOpOcc.schema.json    ${json}
    Log    Validation OK

PUT Individual VNF LCM OP occurences - Method not implemented
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Log    Validate Status code
    Integer    response status    405

PATCH Individual VNF LCM OP occurences - Method not implemented
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Log    Validate Status code
    Integer    response status    405
    
DELETE Individual VNF LCM OP occurences - Method not implemented
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Log    Validate Status code
    Integer    response status    405