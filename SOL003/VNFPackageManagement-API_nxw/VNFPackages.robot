*** Settings ***
Library           HttpLibrary.HTTP
Resource          environment/vnfPackages.txt    # VNF Packages specific parameters
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Library           JSONLibrary

*** Test Cases ***
GET all Packages
    Log    Trying to get all VNF Packages present in the NFVO Catalogue
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${json}
    Log    Validation OK

GET all Packages - Filter
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${POS_FIELDS}
    Response Status Code Should Equal    200
    ${result}=    Get Response Body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${json}
    Log    Validation OK

GET all Packages - Negative (wronge filter name)
    Log    Trying to perform a negative get, filtering by the inexistent field 'nfvId'
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${NEG_FIELDS}
    Response Status Code Should Equal    400
    Log    Received 400 Bad Request as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Packages - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Packages - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Set Request Header    Authorization    ${NEG_AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    401
    Log    Received 401 Unauthorized as expected
    ${problemDetails}=    Get Response Body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all Packages - all_fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?all_fields
    Response Status Code Should Equal    200
    ${vnfPkgInfos}=    Get Response Body
    ${json}=    evaluate    json.loads('''${vnfPkgInfos}''')    json
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    Validate Json    vnfPkgInfo.schema.json    ${json}
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

GET all Packages - fields
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting 'fields'
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?fields=${fields}
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

GET all PACKAGE (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_package
    Response Status Code Should Equal    404
    Log    Received 404 Not Found as expected
    ${problemDetails}=    Get Response Body
    Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

POST all PACKAGE (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
    #${problemDetails}=    Get Response Body
    #Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    #Log    Trying to validate ProblemDetails
    #Validate Json    ProblemDetails.schema.json    ${problemDetails}
    #Log    Validation OK

PUT all PACKAGE (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
    #${problemDetails}=    Get Response Body
    #Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    #Log    Trying to validate ProblemDetails
    #Validate Json    ProblemDetails.schema.json    ${problemDetails}
    #Log    Validation OK

PATCH all PACKAGE (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Http Request    "PATCH"    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    #PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
    #${problemDetails}=    Get Response Body
    #Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    #Log    Trying to validate ProblemDetails
    #Validate Json    ProblemDetails.schema.json    ${problemDetails}
    #Log    Validation OK

DELETE all PACKAGE (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Set Request Header    Accept    ${ACCEPT_JSON}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    Response Status Code Should Equal    405
    Log    Received 405 Method not implemented as expected
    #${problemDetails}=    Get Response Body
    #Response Header Should Equal    Content-Type    ${CONTENT_TYPE_JSON}
    #Log    Trying to validate ProblemDetails
    #Validate Json    ProblemDetails.schema.json    ${problemDetails}
    #Log    Validation OK
