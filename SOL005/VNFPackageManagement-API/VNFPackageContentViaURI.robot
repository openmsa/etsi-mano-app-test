*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfPackageContent.txt
Library           JSONLibrary
Library           OperatingSystem    
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
POST VNF Package Content 
    [Documentation]    This method shall follow the provisions specified in the Tables 9.4.6.3.1-1 and 9.4.6.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a POST. The POST method provides the information for the NFVO to get the content of a VNF package.
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/UploadVnfPkgFromUriRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content/upload_from_uri    ${body}
    Integer    response status    202
    Log    Received 202 Accepted as expected
    ${response}=    Output    response body
    Should Be Empty    ${response} 


POST VNF Package Content - Negative (VNF Package not in CREATED operational state)
    [Documentation]    This method shall follow the provisions specified in the Tables 9.4.6.3.1-1 and 9.4.6.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a POST. The POST method provides the information for the NFVO to get the content of a VNF package.
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/UploadVnfPkgFromUriRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${creatingVnfPackageId}/package_content/upload_from_uri    ${body}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK     
    
    
GET VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgId}/package_content/upload_from_uri
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
    
    
PUT VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content/upload_from_uri
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content/upload_from_uri
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE VNF Package Content - (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content/upload_from_uri
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
