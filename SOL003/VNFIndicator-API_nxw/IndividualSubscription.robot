*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Library           OperatingSystem

*** Test Cases ***
GET Individual Subscription
    Log    Trying to get a given subscription identified by subscriptionId
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    200
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Received a 200 OK as expected
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VnfIndicatorSubscriptions.schema.json    ${json}
    Log    Validated VnfIndicatorSubscription schema

GET Subscription - Negative (Not Found)
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Subscription - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

DELETE Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    204
    Log    Received 204 No Content as expected
    Log    Trying to get the deleted element
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    404
    Log    The subscriptionId is not present in database

DELETE Subscription - Negative (Not Found)
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Response Status Code Should Equal    404
    Log    The subscriptionId is not present in database
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

PUT Subscription - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH Subscription - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

POST Subscription - (Method not implemented)
    Log    Trying to perform a POST. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
