*** Settings ***
Documentation     This resource represents subscriptions. The client can use this resource to subscribe to notifications related to VNF
...               performance management and to query its subscriptions.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Library           OperatingSystem
Library           JSONLibrary
Resource          environment/subscriptions.txt

*** Test Cases ***
GET Subscription
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmSubscriptions.schema.json    ${json}
    Log    Validated PmSubscription schema

GET Subscription - Filter
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmSubscriptions.schema.json    ${json}
    Log    Validated PmSubscription schema

GET Subscription - Negative Filter (Erroneous filter)
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    Integer    response status    400
    Log    Received a 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validated ProblemDetails schema

GET Subscription - Negative (Not Found)
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    Integer    response status    404
    Log    Received a 404 Not found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validated ProblemDetails schema

POST Subscription
    [Documentation]    The POST method creates a new subscription.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.1-1 and 6.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the EM or VNF, and might make sense only in very rare use
    ...    cases. Consequently, the VNFM may either allow creating a subscription resource if another subscription resource with
    ...    the same filter and callbackUri already exists (in which case it shall return the "201 Created" response code), or may
    ...    decide to not create a duplicate subscription resource (in which case it shall return a "303 See Other" response code
    ...    referencing the existing subscription resource with the same filter and callbackUri).
    Set headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    ${body_request}=    Get File    jsons/subscriptions.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body_request}
    Integer    response status    201
    Log    Received a 201 Created as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmSubscriptions.schema.json    ${json}
    Log    Validated PmSubscription schema
    Log    Trying to validate the Location header
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location

POST Subscription - DUPLICATION
    [Documentation]    The POST method creates a new subscription.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.1-1 and 6.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the EM or VNF, and might make sense only in very rare use
    ...    cases. Consequently, the VNFM may either allow creating a subscription resource if another subscription resource with
    ...    the same filter and callbackUri already exists (in which case it shall return the "201 Created" response code), or may
    ...    decide to not create a duplicate subscription resource (in which case it shall return a "303 See Other" response code
    ...    referencing the existing subscription resource with the same filter and callbackUri).
    Pass Execution If    ${VNFM_DUPLICATION} == 1    VNFM is permitting duplication. Skipping the test
    Set headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    ${body_request}=    Get File    jsons/subscriptions.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body_request}
    Integer    response status    303
    Log    Received a 303 See other as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Should Be Empty    ${result}
    Log    Body is empty
    Log    Trying to validate the Location header
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location

POST Subscription - NO DUPLICATION
    [Documentation]    The POST method creates a new subscription.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.1-1 and 6.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the EM or VNF, and might make sense only in very rare use
    ...    cases. Consequently, the VNFM may either allow creating a subscription resource if another subscription resource with
    ...    the same filter and callbackUri already exists (in which case it shall return the "201 Created" response code), or may
    ...    decide to not create a duplicate subscription resource (in which case it shall return a "303 See Other" response code
    ...    referencing the existing subscription resource with the same filter and callbackUri).
    Pass Execution If    ${VNFM_DUPLICATION} == 0    VNFM is not permitting duplication. Skipping the test
    Set headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    ${body_request}=    Get File    jsons/subscriptions.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body_request}
    Integer    response status    201
    Log    Received a 201 Created as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmSubscription.schema.json    ${json}
    Log    Validated PmSubscription schema
    Log    Trying to validate the Location header
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location

PUT Subscription - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Subscription - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Subscription - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
