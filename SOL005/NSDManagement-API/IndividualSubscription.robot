*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Individual Subscription
    Log    Trying to get a single subscription identified by subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${result}=    Output    response body
    Validate Json    NsdmSubscription.schema.json    ${result}
    Log    Validated NsdmSubscription schema

GET Subscription - Negative (Not Found)
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
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
    Comment    Log    Trying to get the deleted element
    Comment    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Comment    Set Request Header    Accept    ${ACCEPT_JSON}
    Comment    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Comment    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Comment    Response Status Code Should Equal    404
    Comment    Log    The subscriptionId is not present in database

DELETE Subscription - Negative (Not Found)
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Integer    response status    404
    Log    The subscriptionId is not present in database
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

PUT Subscription - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Subscription - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

POST Subscription - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
