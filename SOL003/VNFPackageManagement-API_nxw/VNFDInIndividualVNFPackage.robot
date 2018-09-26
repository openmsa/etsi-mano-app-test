*** Settings ***
Library           HttpLibrary.HTTP
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/vnfdInIndividualVnfPackage.txt

*** Test Cases ***
GET VNFD in Individual VNF Package (PLAIN/PLAIN)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_PLAIN}
    Log    How can I validate it?

GET VNFD in Individual VNF Package (ZIP/ZIP)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_ZIP}
    Log    How can I validate it?

GET VNFD in Individual VNF Package (PLAIN-ZIP/ZIP)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_ZIP}
    Log    How can I validate it?

GET VNFD in Individual VNF Package (PLAIN-ZIP/PLAIN)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_PLAIN}
    Log    How can I validate it?

GET VNFD in Individual VNF Package - Negative (PLAIN/ZIP)
    Log    Trying to get a negative case performing a get on a VNFD from a given VNF Package present in the NFVO Catalogue. Accept will be text/plain but VNFD is composed my multiple files.
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Response Status Code Should Equal    406
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Package - Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/vnfd
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Package - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Package - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, without authentication token.
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    Response Status Code Should Equal    401
    Log    Received 401 Unauthozired as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET VNFD in Individual VNF Package - Negative (onboardingState issue)
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/vnfd
    Response Status Code Should Equal    409
    Log    Received 409 Conflict as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST all PACKAGE (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PUT all PACKAGE (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

PATCH all PACKAGE (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected

DELETE all PACKAGE (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
