*** Settings ***
Documentation     This resource represents thresholds. The client can use this resource to create and query thresholds.
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Resource          environment/thresholds.txt
Library           OperatingSystem

*** Test Cases ***
GET Thresholds
    [Documentation]    T=This resource represents thresholds. 
    ...    The client can use this resource to create and query thresholds.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with thresholds schema
    Validate Json    Thresholds.schema.json    ${json}

GET Thresholds - Filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_OK}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with Threshold schema
    Validate Json    Thresholds.schema.json    ${json}

GET Thresholds - NEGATIVE Filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_KO}
    Integer    response status    400
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with ProblemDetails schema
    Validate Json    ProblemDetails.schema.json    ${json}

GET Thresholds - Negative (Not Found)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/threshold
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Reports
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${request}=    Get File    jsons/CreateThresholdRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds    ${request}
    Integer    response status    201
    Log    Received 201 Created as expected
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with thresholds schema
    Validate Json    Threshold.schema.json    ${json}
    Log    Trying to validate the Location header
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location

PUT Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
