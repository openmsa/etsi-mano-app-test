*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/IndividualPmJob.txt
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
GET Individual PM Job
    Log    Trying to get a Pm Job present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK

GET Individual PM Job - Negative (Not Found)
    Log    Trying to perform a negative get, using erroneous PM Job identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

DELETE Individual PM Job
    Log    Trying to delete an existing PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Integer    response status    204
    Log    Received 204 No Content as expected

DELETE Individual PM Job - Negative (Not Found)
    Log    Trying to delete an existing PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK
	
	
POST Individual PM Job - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Individual PM Job - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH Individual PM Job - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
