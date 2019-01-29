*** Settings ***
Documentation     This resource represents an individual threshold.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Library           OperatingSystem
Resource          environment/individualThresholds.txt

*** Test Cases ***
GET Individual Threshold
    [Documentation]    The client can use this method to query information about thresholds.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.2-1 and 6.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with thresholds schema
    Validate Json    Threshold.schema.json    ${json}

GET Individual Threshold - Negative (Not Found)
    [Documentation]    The client can use this method to query information about thresholds.
    ...    This method shall follow the provisions specified in the tables 6.4.5.3.2-1 and 6.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

DELETE Individual Threshold
    [Documentation]    This method allows to delete a threshold.
    ...    This method shall follow the provisions specified in the tables 6.4.6.3.5-1, and 6.4.6.3.5-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    Integer    response status    204
    Log    Received 204 No Content as expected
    ${body}=    Output    response body
    Should Be Empty    ${body}
    Log    Body of the response is empty

DELETE Individual Threshold - Negative (Not Found)
    [Documentation]    This method allows to delete a threshold.
    ...    This method shall follow the provisions specified in the tables 6.4.6.3.5-1, and 6.4.6.3.5-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Log    Trying to validate result with ProblemDetails schema
    Validate Json    ProblemDetails.schema.json    ${json}

POST Individual Threshold - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Individual Threshold - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Individual Threshold - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHENTICATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
