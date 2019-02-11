*** Settings ***
Documentation     This resource represents thresholds. The client can use this resource to create and query thresholds.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Resource          environment/thresholds.txt
Library           OperatingSystem

*** Test Cases ***
GET Thresholds
    [Documentation]    The client can use this method to query information about thresholds.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.2-1 and 6.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Log    Trying to validate result with thresholds schema
    Validate Json    Thresholds.schema.json    ${result}

GET Thresholds - Filter
    [Documentation]    The client can use this method to query information about thresholds.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.2-1 and 6.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_OK}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Log    Trying to validate result with Threshold schema
    Validate Json    Thresholds.schema.json    ${result}

GET Thresholds - NEGATIVE Filter
    [Documentation]    The client can use this method to query information about thresholds.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.2-1 and 6.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_KO}
    Integer    response status    400
    ${result}=    Output    response body
    Log    Trying to validate result with ProblemDetails schema
    Validate Json    ProblemDetails.schema.json    ${result}

GET Thresholds - Negative (Not Found)
    [Documentation]    The client can use this method to query information about thresholds.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.2-1 and 6.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/threshold
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Output    response body
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST Reports
    [Documentation]    The POST method can be used by the client to create a threshold.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.1-1 and 6.4.5.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${request}=    Get File    jsons/CreateThresholdRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds    ${request}
    Integer    response status    201
    Log    Received 201 Created as expected
    ${result}=    Output    response body
    Log    Trying to validate result with thresholds schema
    Validate Json    Threshold.schema.json    ${result}
    Log    Trying to validate the Location header
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location

PUT Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
