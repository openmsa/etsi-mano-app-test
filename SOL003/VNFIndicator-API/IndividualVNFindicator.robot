*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/individualVnfIndicator.txt
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET Individual VNF Indicator
    Log    The GET method reads a VNF indicator.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    200
    ${contentType}=    Output     response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfIndicator.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Indicator - Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization" : "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${erroneousIndicatorId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output     response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Indicator - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as VNFM is not supporting authentication
    Set Headers    {"Accept" : "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output     response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Indicator - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, without authentication token.
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as VNFM is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    401
    Log    Received 401 Unauthozired as expected
    ${contentType}=    Output     response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Individual VNF Indicator (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Individual VNF Indicator (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Individual VNF Indicator (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Individual VNF Indicator (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
