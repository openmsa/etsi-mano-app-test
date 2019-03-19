*** Settings ***
Resource          environment/vnfPackages.txt    # VNF Packages specific parameters
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET all Packages
    [Documentation]    This method shall follow the provisions specified in the Tables 9.4.2.3.1-1 and 9.4.2.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to get all VNF Packages present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    Validate Json    vnfPkgsInfo.schema.json    ${result}
    Log    Validation OK
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${result}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${result}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted


GET all Packages - Filter
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${POS_FIELDS}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    Validate Json    vnfPkgsInfo.schema.json    ${result}
    Log    Validation OK

GET all Packages - Negative (wronge filter name)
    Log    Trying to perform a negative get, filtering by the inexistent field 'nfvId'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${NEG_FIELDS}
    Integer    response status    400
    Log    Received 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET all Packages - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET all Packages - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

GET all Packages - all_fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?all_fields
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${vnfPkgInfos}=    Output    response body
    Log    Trying to validate response
    Validate Json    vnfPkgsInfo.schema.json    ${vnfPkgInfos}
    Log    Validation OK
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${vnfPkgInfos}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${vnfPkgInfos}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK
    ${links}=    Get Value From Json    ${vnfPkgInfos}    $.._links
    Validate Json    links.schema.json    ${links[0]}
    Log    Validation for _links schema OK

GET all Packages - exclude_default
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using exclude_default filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?exclude_default
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${vnfPkgInfos}=    Output    response body
    Log    Trying to validate response
    Validate Json    vnfPkgsInfo.schema.json    ${vnfPkgInfos}
    Log    Validation OK
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${vnfPkgInfos}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${vnfPkgInfos}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted


GET all Packages - fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?fields=${fields}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${vnfPkgInfos}=    Output    response body
    Log    Trying to validate response, checking vnfPkgInfo and other complex attributes included in the vnfPkgInfo
    Validate Json    vnfPkgsInfo.schema.json    ${vnfPkgInfos}
    Log    Validation for vnfPkgInfo OK
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${vnfPkgInfos}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${vnfPkgInfos}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK

GET all Packages - exclude_fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use exclude_fields option
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?exclude_fields=${fields}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${vnfPkgInfos}=    Output    response body
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${vnfPkgInfos}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${vnfPkgInfos}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted

GET all PACKAGE (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_package
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST all VNF PACKAGE
    [Documentation]    This method shall follow the provisions specified in the Tables 9.4.2.3.1-1 and 9.4.2.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a POST to create a new individual VNF package resource
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Load JSON From File    jsons/CreateVnfPkgInfoRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages    ${body}
    Integer    response status    201
    Log    Received 201 Created as expected
    Log    Trying to get Location from the header
    ${location}=    Output    response headers Location
    Should Not Be Empty    ${location}
    Log    Validation of Location headers OK
    Log    Validation of the vnfPkgInfo schema
    ${vnfPkgInfo}=    Output    response body
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${vnfPkgInfo}

PUT all PACKAGE (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH all PACKAGE (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE all PACKAGE (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
