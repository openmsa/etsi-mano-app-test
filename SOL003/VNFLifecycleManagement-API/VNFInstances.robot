*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
...        spec=SOL003-VNFLifecycleManagement-API.yaml
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new vnfInstance
    [Documentation]    Test ID: 5.4.2.1
    ...    Test title: Create a VNF instance
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: VNF instance with the given vnfInstanceId doesn't exist 
    ...    Reference: section 5.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: VNF instance created
    Log    Create VNF instance by POST to ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/createVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    ${body}
    Integer    response status    201
    Log    Status code validated 
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfInstance.schema.json    ${json}
    Log    Validation OK

Get information about multiple VNF instances  
    [Documentation]    Test ID: 5.4.2.2
    ...    Test title: Get information about multiple VNF instances
    ...    Test objective: The objective is to query information about multiple VNF instances
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfInstances.schema.json    ${json}
    Log    Validation OK

Get information about multiple VNF instances Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.4.2.2-1
    ...    Test title: Get information about multiple VNF instances - Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to query information about multiple VNF instances with Invalid attribute-based filtering parameters
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?attribute_not_exist=some_value
    Log    Validate Status code
    Integer    response status    400
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

Get information about multiple VNF instances Bad Request Invalid attribute selector
    [Documentation]    Test ID: 5.4.2.2-1
    ...    Test title: Get information about multiple VNF instances - Invalid attribute selector
    ...    Test objective: The objective is to query information about multiple VNF instances with Invalid attribute selector
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?fields=wrong_field
    Log    Validate Status code
    Integer    response status    400
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK
    
PUT VNFInstances - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances   
    Log    Validate Status code
    Integer    response status    405

PATCH VNFInstances - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    
    Log    Validate Status code
    Integer    response status    405

DELETE VNFInstances - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Log    Validate Status code
    Integer    response status    405