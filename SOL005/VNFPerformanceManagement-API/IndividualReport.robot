*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/reports.txt
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Report on Single PM Job
    [Documentation]    The client can use this resource to read the performance report.
    ...    The URI of this report can be obtained from a PerformanceInformationAvailableNotification
    ...    (see clause 7.5.2.5) or from the representation of the "Individual PM job" resource
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate result with PerformanceReport schema
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PerformanceReport.schema.json    ${json}

GET Report on Single PM Job - Negative (Not Found)
    [Documentation]    The client can use this resource to read the performance report.
    ...    The URI of this report can be obtained from a PerformanceInformationAvailableNotification
    ...    (see clause 7.5.2.5) or from the representation of the "Individual PM job" resource
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${erroneousReportId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Reports - (Method not implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
