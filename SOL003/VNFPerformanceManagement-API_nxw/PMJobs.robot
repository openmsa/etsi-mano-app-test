*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Library           OperatingSystem
Resource          environment/pmJobs.txt
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET all Pm Jobs
    Log    Trying to get all PM Jobs present in the VNFM
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - Filter
    Log    Trying to get all PM Jobs present in the VNFM, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${POS_FILTER}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - all_fields
    Log    Trying to get all PM Jobs present in the VNFM, using 'all_fields' filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?all_fields
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK
    Log    Trying to validate criteria schema
    ${criteria}=    Get Value From Json    ${json}    $..criteria
    Validate Json    criteria.schema.json    ${criteria[0]}
    Log    Validation for criteria schema OK
    Log    Trying to validate criteria schema
    ${reports}=    Get Value From Json    ${json}    $..reports
    Validate Json    reports.schema.json    ${reports[0]}
    Log    Validation for reports schema OK
    Log    Validating _links schema
    ${links}=    Get Value From Json    ${json}    $.._links
    Validate Json    links.schema.json    ${links[0]}
    Log    Validation for _links schema OK

GET all Pm Jobs - fields
    Log    Trying to get all VNF Packages present in the VNFM, using filter params
    Pass Execution If    ${VNFM_AUTH_USAGE} == 0    Skipping test as VNFM is not supporting 'fields'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?fields=${fields}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK
    Log    Trying to validate criteria schema
    ${criteria}=    Get Value From Json    ${json}    $..criteria
    Validate Json    criteria.schema.json    ${criteria[0]}
    Log    Validation for criteria schema OK
    Log    Trying to validate criteria schema
    ${reports}=    Get Value From Json    ${json}    $..reports
    Validate Json    reports.schema.json    ${reports[0]}
    Log    Validation for reports schema OK

GET all Pm Jobs - Negative (wronge filter name)
    Log    Trying to get all PM Jobs present in the VNFM, using an erroneous filter param
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${NEG_FILTER}
    Integer    response status    400
    Log    Received 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response headers Content-Type
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_job    # wrong URI /pm_job instead of /pm_jobs
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response headers Content-Type
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST all PM Jobs - Create new PM Job
    Log    Creating a new PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    ${body}=    Get File    jsons/CreatePmJobRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs    ${body}
    Integer    response status    201
    Log    Received 201 Created as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK

PUT all PM Jobs - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH all Pm Jobs - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE all Pm Jobs - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
