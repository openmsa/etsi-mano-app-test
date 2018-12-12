*** Settings ***
Resource   variables.txt 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST    http://${NFVO_HOST}:${NFVO_PORT}     
...    spec=SOL003-VNFLifecycleOperationGranting-API.yaml
Documentation    This resource represents an individual grant. The client can use this resource to read the grant.
...    It is determined by means outside the scope of the present document, such as configuration or policy,
...    how long an individual grant is available.
Suite setup    Check resource existance

*** Test Cases ***
Post Individual Grant - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}  
    Log    Validate Status code
    Integer    response status    405

Get an individual grant - Successful
    # TODO: How to set up the precondition?
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    grant.schema.json    ${json}
    Log    Validation OK
    
Get an individual grant - Process ongoing
    # TODO: How to set up the precondition?
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    Log    Validate Status code
    Integer    response status    202

Get an individual grant - grant rejected
    # TODO: How to set up the precondition?
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    Log    Validate Status code
    Integer    response status    403
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

PUT an individual grant - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}   
    Log    Validate Status code
    Integer    response status    405

PATCH an individual grant - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}    
    Log    Validate Status code
    Integer    response status    405
    
DELETE an individual grant - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}   
    Log    Validate Status code
    Integer    response status    204

*** Key words ***   

Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200