*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/vnfPackageContent.txt

*** Test Cases ***
GET VNF Package Content
    Log    Trying to get a VNF Package Content
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_ZIP}
    Log    How can I validate it?

GET VNF Package Content - Range
    Log    Trying to get a VNF Package Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Range    ${range}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    206
    Response Should Have Header    Content-Range
    Response Should Have Header    Content-Length
    Log    Received 206 Partial Content as expected.
    Log    How can I validate it?

GET VNF Package Content - Range NFVO No RANGE
    Log    Trying to get a VNF Package Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 1    Skipping this test as NFVO is able to handle partial Requests.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Range    ${range}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    200
    Log    Received 200 OK as expected. The content is all available on this request. RANGE request has been ignored.
    Log    How can I validate it?

GET VNF Package Content - Negative Range
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Range    ${erroneousRange}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    416
    Log    Received 416 Range not satisfiable as expected.
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNF Package Content - Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/package_content
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNF Package Content - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNF Package Content - Negative (onboardingState issue)
    Log    Trying to get a VNF Package content present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/package_content
    Response Status Code Should Equal    409
    Log    Received 409 Conflict as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST VNF Package Content - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PUT VNF Package Content - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH VNF Package Content - (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE VNF Package Content - (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
