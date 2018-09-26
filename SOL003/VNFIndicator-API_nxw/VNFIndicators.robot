*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/vnfIndicators.txt

*** Test Cases ***
GET all Indicators
    Log    The GET method queries multiple VNF indicators
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfIndicators.schema.json    ${json}
    Log    Validation OK

GET all Indicators - Filter
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators?${POS_FIELDS}
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfIndicators.schema.json    ${json}
    Log    Validation OK

GET all Indicators - Negative (wronge filter name)
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters. Negative case, with erroneous attribute name
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators?${NEG_FIELDS}
    Response Status Code Should Equal    400
    Log    Received 400 Bad Request as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Indicators - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Indicators - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Indicators (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicator
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST all Indicators (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PUT all Indicators (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH all Indicators (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE all Indicators (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
