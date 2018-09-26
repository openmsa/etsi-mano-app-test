*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/vnfIndicatorinVnfInstance.txt
Library           JSONLibrary

*** Test Cases ***
GET Indicators on VNF Instance
    Log    This resource represents VNF indicators related to a VNF instance.
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfIndicators.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Filter
    Log    This resource represents VNF indicators related to a VNF instance.
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${POS_FIELDS}
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfIndicators.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Negative Filter
    Log    This resource represents VNF indicators related to a VNF instance.
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${NEG_FIELDS}
    Response Status Code Should Equal    400
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Negative (Not Found)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${erroneousVnfInstanceId}
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instancee - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, without authentication token.
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PUT Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Create HTTP Context    ${VNFM_HOST}:${VNFM_PORT}    ${VNFM_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Request Header    Authorization    ${VNFM_AUTHENTICATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
