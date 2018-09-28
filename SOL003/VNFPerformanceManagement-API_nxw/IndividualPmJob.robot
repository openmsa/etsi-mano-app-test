*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/IndividualPmJob.txt

*** Test Cases ***
GET Individual PM Job
    Log    Trying to get a Pm Job present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK

GET Individual PM Job - Negative (Not Found)
    Log    Trying to perform a negative get, using erroneous PM Job identifier
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual PM Job - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual PM Job - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, without authentication token.
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST Individual PM Job - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PUT Individual PM Job - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH Individual PM Job - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE Individual PM Job - (Method not implemented)
    Log    Trying to delete an existing PM Job
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    204
    Log    Received 204 No Content as expected
    Log    Trying to delete the same resource again
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
