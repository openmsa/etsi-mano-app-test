*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Library           OperatingSystem

*** Test Cases ***
GET Individual Subscription
    Log    Trying to get the list of subscriptions
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    200
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Received a 200 OK as expected
    ${result}=    Get Response Body
    Validate Json    PkgmSubscription.schema.json    ${result}
    Log    Validated PkgmSubscription schema

GET Subscription - Negative (Not Found)
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET Subscription - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

DELETE Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    204
    Log    Received 204 No Content as expected
    Log    Trying to get the deleted element
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    404
    Log    The subscriptionId is not present in database

DELETE Subscription - Negative (Not Found)
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    Response Status Code Should Equal    404
    Log    The subscriptionId is not present in database
    ${problemDetails}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

PUT Subscription - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
    #${problemDetails}=    Get Response Body
    #Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    #Log    Trying to validate ProblemDetails
    #Validate Json    ProblemDetails.schema.json    ${problemDetails}
    #Log    Validation OK

PATCH Subscription - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    "PATCH"    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    #PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
    #${problemDetails}=    Get Response Body
    #Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    #Log    Trying to validate ProblemDetails
    #Validate Json    ProblemDetails.schema.json    ${problemDetails}
    #Log    Validation OK
