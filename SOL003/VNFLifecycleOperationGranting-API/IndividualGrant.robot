*** Settings ***
Resource   environment/variables.txt 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Documentation    This resource represents an individual grant. The client can use this resource to read the grant.
...    It is determined by means outside the scope of the present document, such as configuration or policy,
...    how long an individual grant is available.

*** Test Cases ***
Post Individual Grant - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}  
    Log    Validate Status code
    Integer    response status    405

Get an individual grant - Successful
    [Documentation]    Test ID: 9.4.3.1
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Successful
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation 
    ...    Pre-conditions: The related grant information is available to the VNFM
    ...    Reference: section 9.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    Log    Validate Status code
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    Validate Json    grant.schema.json    ${result}
    Log    Validation OK
    
Get an individual grant - Process ongoing
    [Documentation]    Test ID: 9.4.3.2
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - Process ongoing
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation 
    ...    Pre-conditions: The process of creating the grant is ongoing, no grant is available yet.
    ...    Reference: section 9.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    Log    Validate Status code
    Integer    response status    202

Get an individual grant - grant rejected
    [Documentation]    Test ID: 9.4.3.3
    ...    Test title: Requests a grant for a particular VNF lifecycle operation - grant rejected
    ...    Test objective: The objective is to request a grant for a particular VNF lifecycle operation 
    ...    Pre-conditions: The related grant is rejected
    ...    Reference: section 9.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    log    Trying to read an individual grant
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}
    Log    Validate Status code
    Integer    response status    403
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
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
    Integer    response status    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200