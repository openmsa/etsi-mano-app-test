*** Settings ***
Resource    variables.txt 
Library    REST    ${VNF_SCHEMA}://${VNF_HOST}:${VNF_PORT} 
...        spec=SOL002-VNFConfiguration-API.yaml
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    DependencyLibrary

*** Variables ***
${Etag}=    an etag
${Etag_modified}=    a modified etag

*** Test cases ***
POST Configuration - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405

Get information about a configuration  
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
    [Documentation]    Precondition Failed
    ...    Precondition Failed A precondition given in an HTTP request header is not fulfilled. 
    ...    Typically, this is due to an ETag mismatch, indicating that the resource was modified by another entity. 
    ...    The response body should contain a ProblemDetails structure, in which the “detail” attribute should convey more information about the error.
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