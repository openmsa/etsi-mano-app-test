*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Library           OperatingSystem
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET Individual Subscription
    Log    Trying to get a given subscription identified by subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Log    Trying to validate result with VnfIndicatorSubscription schema
    Validate Json    VnfIndicatorSubscription.schema.json    ${result}
    Log    Validated VnfIndicatorSubscription schema

GET Subscription - Negative (Not Found)
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${problemDetails}=    Output    response body
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET Subscription - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as VNFM is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

DELETE Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    204
    Log    Received 204 No Content as expected

DELETE Subscription - Negative (Not Found)
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Integer    response status    404
    Log    The subscriptionId is not present in database
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${problemDetails}=    Output
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

PUT Subscription - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Subscription - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

POST Subscription - (Method not implemented)
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
