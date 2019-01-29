*** Settings ***
Resource          environment/vnfPackages.txt    # VNF Packages specific parameters
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET all Packages
    Log    Trying to get all VNF Packages present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfPkgsInfo.schema.json    ${json}
    Log    Validation OK
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${json}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${json}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted
    Log    Checking missing information for _links element
    ${links}=    Get Value From Json    ${json}    $.._links
    Should Be Empty    ${links}
    Log    _links element is missing as excepted

GET all Packages - Filter
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${POS_FILTER}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    vnfPkgsInfo.schema.json    ${json}
    Log    Validation OK

GET all Packages - Negative (wronge filter name)
    Log    Trying to perform a negative get, filtering by the inexistent filter 'nfvId'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${NEG_FILTER}
    Integer    response status    400
    Log    Received 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
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
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
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
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
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
    ${json}=    evaluate    json.loads('''${vnfPkgInfos}''')    json
    Log    Trying to validate response
    Validate Json    vnfPkgsInfo.schema.json    ${json}
    Log    Validation OK
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${json}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${json}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK
    ${links}=    Get Value From Json    ${json}    $.._links
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
    ${json}=    evaluate    json.loads('''${vnfPkgInfos}''')    json
    Log    Trying to validate response
    Validate Json    vnfPkgsInfo.schema.json    ${json}
    Log    Validation OK
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${json}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${json}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted
    Log    Checking missing information for _links element
    ${links}=    Get Value From Json    ${json}    $.._links
    Should Be Empty    ${links}
    Log    _links element is missing as excepted

GET all Packages - fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?fields=${fields}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${vnfPkgInfos}=    Output    response body
    ${json}=    evaluate    json.loads('''${vnfPkgInfos}''')    json
    Log    Trying to validate response, checking vnfPkgInfo and other complex attributes included in the vnfPkgInfo
    Validate Json    vnfPkgsInfo.schema.json    ${json}
    Log    Validation for vnfPkgInfo OK
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${json}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${json}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK

GET all Packages - exclude_fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use exclude_fields option
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?exlude_fields=${fields}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    ${vnfPkgInfos}=    Output    response body
    ${json}=    evaluate    json.loads('''${vnfPkgInfos}''')    json
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${json}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${json}    $..additionalArtifacts
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
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST all PACKAGE (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT all PACKAGE (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH all PACKAGE (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE all PACKAGE (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
