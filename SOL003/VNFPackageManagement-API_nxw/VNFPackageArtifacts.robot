*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/vnfPackageArtifacts.txt
Library           JSONLibrary

*** Test Cases ***
GET VNF Package Artifact
    Log    Trying to get a VNF Package Artifact
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    200
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_OCTET}
    Log    Received a 200 OK as expected
    Log    How can I validate it?

GET VNF Package Artifact - Range
    Log    Trying to get an Artifact using RANGE Header and using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Range    ${range}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    206
    Response Should Have Header    Content-Range
    Response Should Have Header    Content-Length
    Log    Received 206 Partial Content as expected.
    Log    How can I validate it?

GET VNF Package Artifact - NFVO No RANGE
    Log    Trying to get an Artifact using RANGE Header and using an NFVO that cannot handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 1    Skipping this test as NFVO is able to handle partial Requests.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Range    ${range}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    200
    Log    Received 200 OK as expected. The content is all available on this request. RANGE request has been ignored.
    Log    How can I validate it?

GET VNF Package Artifact - Negative Range
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Range    ${erroneousRange}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    416
    Log    Received 416 Range not satisfiable as expected.
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNF Package Artifact- Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNF Package Artifact - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNF Package Artifact - Negative (onboardingState issue)
    Log    Trying to get a VNF Package artifact present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    409
    Log    Received 409 Conflict as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PUT VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/artifacts/{artifactPath}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
