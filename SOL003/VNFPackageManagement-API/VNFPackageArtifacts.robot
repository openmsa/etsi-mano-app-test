*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfPackageArtifacts.txt
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET VNF Package Artifact
    Log    Trying to get a VNF Package Artifact
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_OCTET}

GET VNF Package Artifact - Range
    Log    Trying to get an Artifact using RANGE Header and using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    206
    Log    Received 206 Partial Content as expected.
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Content-Range
    Should Contain    ${headers}    Content-Length


GET VNF Package Artifact - Negative Range
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Range": "${erroneousRange}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    416
    Log    Received 416 Range not satisfiable as expected.
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET VNF Package Artifact- Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/artifacts/${artifactPath}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET VNF Package Artifact - Negative (onboardingState issue)
    Log    Trying to get a VNF Package artifact present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/artifacts/${artifactPath}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE VNF Package Artifact - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
