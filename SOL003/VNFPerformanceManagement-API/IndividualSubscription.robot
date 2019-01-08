*** Settings ***
Documentation     This resource represents subscriptions. The client can use this resource to subscribe to notifications related to VNF
...               performance management and to query its subscriptions.
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Library           OperatingSystem
Library           JSONLibrary
Resource          environment/individualSubscription.txt

*** Test Cases ***
GET Individual Subscription
    [Documentation]    The client can use this method for reading an individual subscription about Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.8.3.2-1 and 6.4.8.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": ${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmSubscription.schema.json    ${json}
    Log    Validated PmSubscription schema

GET Individual Subscription - Negative (Not Found)
    [Documentation]    The client can use this method for reading an individual subscription about Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.8.3.2-1 and 6.4.8.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": ${VNFM_AUTHENTICATION}"
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Integer    response status    404
    Log    Received a 404 Not found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validated ProblemDetails schema

POST Individual Subscription - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Individual Subscription - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Individual Subscription - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Individual Subscription - (Method not implemented)
    [Documentation]    This method terminates an individual subscription.
    ...    This method shall follow the provisions specified in the tables 6.4.8.3.5-1 and 6.4.8.3.5-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": ${VNFM_AUTHENTICATION}"
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    204
    Log    Received a 204 No Content as expected
    ${body}=    Output    response body
    Should Be Empty    ${body}
    Log    Body of the response is empty
