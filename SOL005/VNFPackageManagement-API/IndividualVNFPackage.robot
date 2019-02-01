*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/individualVnfPackage.txt
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Individual VNF Package
    Log    Trying to get a VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate response
    ${vnfPkgInfo}=    Output    response body
    ${json}=    evaluate    json.loads('''${vnfPkgInfo}''')    json
    Validate Json    vnfPkgInfo.schema.json    ${json}
    Log    Validation OK

GET Individual VNF Package - Negative (Not Found)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPackageId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK
    
    
PATCH Individual VNF Package
    Log    Trying to perform a PATCH. This method updates the information of a VNF package.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Load JSON From File    jsons/VnfPkgInfoModifications.json
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}    ${body}
    Integer    response status    200
    Log    Received 200 OK as expected
    Log    Trying to validate VnfPkgInfoModification
    ${response}=    Output    response body
    ${json}=    evaluate    json.loads('''${response}''')    json
    Validate Json    VnfPkgInfoModification.schema.json    ${json}
    Log    Validation OK
    
    
PATCH Individual VNF Package - Negative (Conflict on the state of the resource)
    Log    Trying to perform a PATCH, disabling a package already disabled
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Load JSON From File    jsons/VnfPkgInfoModificationsDisabled.json
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${disabledVnfPackageId}    ${body}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    Log    Trying to validate ProblemDetails
    ${response}=    Output    response body
    ${json}=    evaluate    json.loads('''${response}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK    
    

DELETE Individual VNF Package
    [Documentation]    This method shall follow the provisions specified in the Tables 9.4.3.3.5-1 and 9.4.3.3.5-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a DELETE. This method deletes an individual VNF package resource.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${disabledVnfPackageId}
    Integer    response status    204
    Log    Received 204 No Content as expected
    
    
    
DELETE Individual VNF Package - Negative (Conflict on the state of the resource)
    [Documentation]    This method shall follow the provisions specified in the Tables 9.4.3.3.5-1 and 9.4.3.3.5-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a DELETE trying to delete a resource which operational status is ENABLED.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    Log    Trying to validate ProblemDetails
    ${response}=    Output    response body
    ${json}=    evaluate    json.loads('''${response}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK    
    
    
POST Individual VNF Package - (Method not implemented)
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PUT Individual VNF Package - (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected


