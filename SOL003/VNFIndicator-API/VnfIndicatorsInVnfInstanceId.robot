*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfIndicatorinVnfInstance.txt
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET Indicators on VNF Instance
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfIndicators.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Filter
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${POS_FIELDS}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfIndicators.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Negative Filter
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${NEG_FIELDS}
    Integer    response status    400
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Indicators on VNF Instance - Negative (Not Found)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${erroneousVnfInstanceId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Indicators on VNF Instance - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Log    Received 405 Method not implemented as expected
