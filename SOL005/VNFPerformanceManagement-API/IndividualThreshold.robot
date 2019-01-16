*** Settings ***
Documentation     This resource represents an individual threshold.
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library           OperatingSystem
Resource          environment/individualThresholds.txt

*** Test Cases ***
GET Individual Threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with thresholds schema
    Validate Json    Threshold.schema.json    ${json}

GET Individual Threshold - Negative (Not Found)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

DELETE Individual Threshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    Integer    response status    204
    Log    Received 204 No Content as expected
    ${body}=    Output    response body
    Should Be Empty    ${body}
    Log    Body of the response is empty

DELETE Individual Threshold - Negative (Not Found)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with ProblemDetails schema
    Validate Json    ProblemDetails.schema.json    ${json}

POST Individual Threshold - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Individual Threshold - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Individual Threshold - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
