*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/vnfdInIndividualVnfPackage.txt
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET VNFD in Individual VNF Package (PLAIN)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_PLAIN}

GET VNFD in Individual VNF Package (ZIP)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_ZIP}

GET VNFD in Individual VNF Package (PLAIN-ZIP)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Run Keyword If    ${NFVO_PLAIN} == 0    Should Contain    ${contentType}    ${CONTENT_TYPE_ZIP}
    Run Keyword If    ${NFVO_PLAIN} == 1    Should Contain    ${contentType}    ${CONTENT_TYPE_PLAIN}

GET VNFD in Individual VNF Package - Negative (PLAIN/ZIP)
    Log    Trying to get a negative case performing a get on a VNFD from a given VNF Package present in the NFVO Catalogue. Accept will be text/plain but VNFD is composed my multiple files.
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Integer    response status    406
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNFD in Individual VNF Package - Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/vnfd
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNFD in Individual VNF Package - Negative (onboardingState issue)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/vnfd
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST VNFD in Individual VNF Package (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT VNFD in Individual VNF Package (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH VNFD in Individual VNF Package (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE VNFD in Individual VNF Package (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization: "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
