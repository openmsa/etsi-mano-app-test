*** Settings ***
Library           HttpLibrary.HTTP
Resource          ../variables.txt
Library           JSONSchemaLibrary    schemas/

*** Test Cases ***
VNF packages
    Log    Trying to get all VNF Packages present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages
    Response Status Code Should Equal    200
    ${vnfPkgInfos}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE}
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${vnfPkgInfos}
    Log    Validation OK
    Log    Trying to generate a invalid request using invalid attribute filter
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages?fields=wrong_field
    Response Status Code Should Equal    400
    Log    Response code il 400 as expected
    Log    Trying to generate an invalid request using an invalid token
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT}
    Set Request Header    Authorization    ${WRONG_AUTHORIZATION}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages
    Response Status Code Should Equal    401
    Log    Response code is 401 as expected

Individual VNF package
    Log    Trying to get a VNF Package present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE}
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${vnfPkgInfo}
    Log    Validation OK

VNFD of an individual VNF package
    Log    Trying to get the content of a VNFD within a VNF Package present in the NFVO Catalogue
    Log    Request to have a VNFD from a given VNF Package
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/vnfd
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    #Run Keyword If    ${SINGLE_FILE_VNFD} == 1    Response Header Should Equal    Content-Type    ${ACCEPT_PLAIN}
    Run Keyword If    ${SINGLE_FILE_VNFD} == 0    Response Header Should Equal    Content-Type    ${ACCEPT_ZIP}
    Log    How to handle validation here? Are we going to check some fields from the json?
    Log    Request that will generate an error (406) using an Accept header as text/plain but the NFVO could not provide
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${WRONG_ACCEPT}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/vnfd
    Response Status Code Should Equal    406
    Log    Received 406 Not Applicable

VNF package content
    Log    Trying to fetch the content of a VNF package identified by the VNF package identifier allocated by the NFVO
    Log    Request to have the whole VNF Package
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${ACCEPT_ZIP}
    Log    Request to have the VNF Package using partial download
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Range    bytes=0-1023
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/package_content
    Response Header Should Equal    Content-Length    2048
    Response Header Should Equal    Content-Range    bytes 0-1023/2048
    Response Status Code Should Equal    206
    Log    Received 206 Partial Content
    Log    Request that will generate a 416 Error. Package length in bytes is 2048 and will be requested a range from 2048 to 2560
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    Set Request Header    Range    bytes=2048-2560
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/package_content
    Response Status Code Should Equal    416
    Log    Received 416 Range not satisfiable

Individual VNF package artifact
    Log    Trying to get an individual artifact contained in a VNF package
    Log    Request to have the whole VNF Package
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ARTIFACT_TYPE}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/artifacts/${ARTIFACT_ID}
    Response Status Code Should Equal    200
    ${vnfPkgInfo}=    Get Response Body
    Response Header Should Equal    Content-Type    ${ARTIFACT_TYPE}
    Log    How to handle validation here? The object returned is a zip file
    Log    Trying to get \ with partial download an individual artifact contained in a VNF package
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ARTIFACT_TYPE}
    Set Request Header    Range    bytes=0-1023
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/artifacts/${ARTIFACT_ID}
    Response Header Should Equal    Content-Length    2048
    Response Header Should Equal    Content-Range    bytes 0-1023/2048
    Response Status Code Should Equal    206
    Log    Received 206 Partial Content
    Log    Request that will generate a 416 Error. Artifact length in bytes is 2048 and will be requested a range from 2048 to 2560
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ARTIFACT_TYPE}
    Set Request Header    Range    bytes=2048-2560
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId}/artifacts/${ARTIFACT_ID}
    Response Status Code Should Equal    416
    Log    Received 416 Range not satisfiable
