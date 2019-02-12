*** Settings ***
Documentation     This resource represents an individual performance report that was collected by a PM job. The client can use this
...               resource to read the performance report. The URI of this report can be obtained from a
...               PerformanceInformationAvailableNotification (see clause 6.5.2.5) or from the representation of the "Individual PM job"
...               resource.
...               It is determined by means outside the scope of the present document, such as configuration or policy, how long an
...               individual performance report is available.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/reports.txt
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET Report on Single PM Job
    [Documentation]    The client can use this method for reading an individual performance report.
    ...    This method shall follow the provisions specified in the tables 6.4.4.3.2-1 and 6.4.4.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate result with PerformanceReport schema
    ${result}=    Output    response body
    Validate Json    PerformanceReport.schema.json    ${result}

GET Report on Single PM Job - Negative (Not Found)
    [Documentation]    The client can use this method for reading an individual performance report.
    ...    This method shall follow the provisions specified in the tables 6.4.4.3.2-1 and 6.4.4.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${erroneousReportId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE Reports - (Method not implemented)
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
