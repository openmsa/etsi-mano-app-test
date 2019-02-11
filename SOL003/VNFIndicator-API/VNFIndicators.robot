*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/vnfIndicators.txt
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET all Indicators
    Log    The GET method queries multiple VNF indicators
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate response
    ${result}=    Output    response body
    Validate Json    vnfIndicators.schema.json    ${result}
    Log    Validation OK

GET all Indicators - Filter
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators?${POS_FIELDS}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate response
    ${result}=    Output    response body
    Validate Json    vnfIndicators.schema.json    ${result}
    Log    Validation OK

GET all Indicators - Negative (wronge filter name)
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters. Negative case, with erroneous attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators?${NEG_FIELDS}
    Integer    response status    400
    Log    Received 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET all Indicators - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as VNFM \ is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET all Indicators - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as VNFM is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET all Indicators (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicator
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST all Indicators (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT all Indicators (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH all Indicators (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE all Indicators (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
