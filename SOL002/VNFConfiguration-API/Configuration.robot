*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNF_SCHEMA}://${VNF_HOST}:${VNF_PORT} 
...        spec=SOL002-VNFConfiguration-API.yaml
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    DependencyLibrary

*** Variables ***
${Etag}=    an etag
${Etag_modified}=    a modified etag

*** Test Cases ***
POST Configuration - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405

Get information about a configuration
    [Documentation]    Test ID: 9.4.2.1
    ...    Test title: Get information about a configuration
    ...    Test objective: The objective is to read configuration information about a VNF instance and/or its VNFC instances
    ...    Pre-conditions: 
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    Log    Query VNF The GET method queries information about a configuration.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/configuration
    ${Etag}=    Output    response headers Etag
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfConfiguration.schema.json    ${json}
    Log    Validation OK

PUT Config - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405

PATCH Config
    [Documentation]    Test ID: 9.4.2.2
    ...    Test title: Set or modify a configuration resource
    ...    Test objective: The objective is to set or modify a configuration resource
    ...    Pre-conditions: A VNF instance and its VNFC instances exist
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  Configuration of the VNF instance and/or its VNFC instances has been set 
    log    Trying to perform a PATCH. This method modifies the configuration
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/vnfConfigModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}
    Log    Validate Status code
    ${Etag_modified}=    Output    response headers Etag
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfConfigModifications.schema.json    ${json}
    Log    Validation OK

PATCH Config - Precondition failed
    [Documentation]    Test ID: 9.4.2.2-1
    ...    Test title: Set or modify a configuration resource  - Precondition failed
    ...    Test objective: The objective is to set or modify a configuration resource, but a precondition given in an HTTP request header is not fulfilled
    ...    Pre-conditions: A VNF instance and its VNFC instances exist, ETag modified in the meanwhile
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"} 
    Set Headers    {"If-Match": "${Etag}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/vnfConfigModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}
    Log    Validate Status code
    Integer    response status    412
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

DELETE Config - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405   