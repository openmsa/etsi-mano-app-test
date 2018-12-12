*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${PRODUCER_SCHEMA}://${PRODUCER_HOST}:${PRODUCER_PORT}

*** Test Cases ***
GET Subscription
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VnfIndicatorSubscription.schema.json    ${json}
    Log    Validated VnfIndicatorSubscription schema

GET Subscription - Filter
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${POS_FILTER}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Received a 200 OK as expected
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VnfIndicatorSubscription.schema.json    ${json}
    Log    Validated VnfIndicatorSubscriptions schema

GET Subscription - Negative Filter
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${NEG_FILTER}
    Integer    response status    400
    Log    Received a 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Subscription - Negative (Not Found)
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Subscription
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    json/subscriptions.json
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    Integer    response status    201
    Log    Received 201 Created as expected
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    Log    Response has header Location
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VnfIndicatorSubscription.schema.json    ${json}
    Log    Validation of VnfIndicatorSubscription OK

PUT Subscription - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Subscription - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Subscription - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${PRODUCER_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${PRODUCER_AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
