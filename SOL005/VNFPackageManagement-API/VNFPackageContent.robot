*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfPackageContent.txt
Library           JSONLibrary
Library           OperatingSystem    
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET VNF Package Content
    Log    Trying to get a VNF Package Content
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Integer    response status    200

GET VNF Package Content - Range
    Log    Trying to get a VNF Package Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Integer    response status    206
    Log    Received 206 Partial Content as expected.
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Content-Range
    Log    Header Content-Range is present
    Should Contain    ${headers}    Content-Length
    Log    Header Content-Length is present


GET VNF Package Content - Negative Range
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Integer    response status    416
    Log    Received 416 Range not satisfiable as expected.

GET VNF Package Content - Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/package_content
    Integer    response status    404
    Log    Received 404 Not Found as expected

GET VNF Package Content - Negative (onboardingState issue)
    Log    Trying to get a VNF Package content present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/package_content
    Integer    response status    409
    Log    Received 409 Conflict as expected


PUT VNF Package Content 
    Log    Trying to perform a PUT. This method uploads the content of a VNF package.
    Set Headers    {"Content-Type": "${CONTENT_TYPE_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${content}=    Get Binary File     files/vnfPackage.zip
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content    ${content}
    Integer    response status    202
    Log    Received 202 Accepted as expected
    Log    Verification of body. Should be empty
    ${body}=    Output    response body
    Should Be Empty    ${body}
    Log    Verified empty body OK    


PUT VNF Package Content - Negative (Conflict on onboarding status not in CREATED)
    Log    Trying to perform a PUT. This method uploads the content of a VNF package.
    Set Headers    {"Content-Type": "${CONTENT_TYPE_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${content}=    Get Binary File     files/vnfPackage.zip
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${creatingVnfPackageId}/package_content    ${content}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
    

POST VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected


PATCH VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
