*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Library           OperatingSystem

*** Test Cases ***
GET Subscription
    Log    Trying to get the list of subscriptions
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    200
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Received a 200 OK as expected
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PkgmSubscription.schema.json    ${json}
    Log    Validated PkgmSubscription schema

GET Subscription - Filter
    Log    Trying to get the list of subscriptions using filters
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    Response Status Code Should Equal    200
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Received a 200 OK as expected
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PkgmSubscription.schema.json    ${json}
    Log    Validated PkgmSubscription schema

GET Subscription - Negative Filter
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    Response Status Code Should Equal    400
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Received a 400 Bad Request as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Subscription - Negative (Not Found)
    Log    Trying to perform a request on a Uri which doesn't exist
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
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
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Subscription
    Log    Trying to create a new subscription
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Content-Type    ${CONTENT_TYPE_JSON}
    ${body}=    Get File    json/subscriptions.json
    Set Request Body    ${body}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    201
    Log    Received 201 Created as expected
    Response Should Have Header    Location
    Log    Response has header Location
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PkgmSubscription.schema.json    ${json}
    Log    Validation of PkgmSubscription OK

POST Subscription - DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 1    NFVO is not permitting duplication. Skipping the test
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Content-Type    ${CONTENT_TYPE_JSON}
    ${body}=    Get File    json/subscriptions.json
    Set Request Body    ${body}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    201
    Log    Received 201 Created as expected
    Response Should Have Header    Location
    Log    Response has header Location
    ${result}    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PkgmSubscription.schema.json    ${json}
    Log    Validation of PkgmSubscription OK

POST Subscription - NO DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 1    NFVO is not permitting duplication. Skipping the test
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Content-Type    ${CONTENT_TYPE_JSON}
    ${body}=    Get File    json/subscriptions.json
    Set Request Body    ${body}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    303
    Log    Received 303 See Other as expected
    Response Should Have Header    Location
    Log    Response header contains Location
    Comment    ${result}=    Get Response Body
    Comment    ${count}=    Get Length    ${result}
    Comment    Run Keyword If    $count == 0    Response body is empty as expected

PUT Subscription - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH Subscription - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE Subscription - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
