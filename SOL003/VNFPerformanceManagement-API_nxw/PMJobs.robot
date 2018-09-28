*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary
Library           OperatingSystem
Resource          environment/pmJobs.txt

*** Test Cases ***
GET all Pm Jobs
    Log    Trying to get all PM Jobs present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    PmJob.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - Filter
    Log    Trying to get all PM Jobs present in the NFVO Catalogue, using filter params
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${POS_FILTER}
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - Negative (wronge filter name)
    Log    Trying to get all PM Jobs present in the NFVO Catalogue, using an erroneous filter param
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${NEG_FILTER}
    Response Status Code Should Equal    400
    Log    Received 400 Bad Request as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Pm Jobs - all_fields
    Log    Trying to get all PM Jobs present in the NFVO Catalogue, using 'all_fields' filter
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?all_fields
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
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
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting 'fields'
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?fields=${fields}
    Response Status Code Should Equal    200
    ${vnfPkgInfos}=    Get Response Body
    ${json}=    evaluate    json.loads('''${vnfPkgInfos}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response, checking vnfPkgInfo and other complex attributes included in the vnfPkgInfo
    Validate Json    vnfPkgInfo.schema.json    ${json}
    Log    Validation for vnfPkgInfo OK
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${json}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${json}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK

GET all Pm Jobs (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_job    # wrong URI /pm_job instead of /pm_jobs
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST PM Jobs - Create new PM Job
    Log    Creating a new PM Job
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Content-Type    ${CONTENT_TYPE_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    ${body}=    Get File    jsons/CreatePmJobRequest.json
    Set Request Body    ${body}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    201
    Log    Received 201 Created as expected
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    PmJob.schema.json    ${json}
    Log    Validated VnfIndicatorSubscription schema

PUT PM Jobs - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH Pm Jobs - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE Pm Jobs - \ (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
