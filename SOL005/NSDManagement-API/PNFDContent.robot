*** Settings ***
Documentation     This clause defines the content of the individual NS descriptor, i.e. NSD content
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/pnfDescriptors.txt    # Specific nsDescriptors Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library           OperatingSystem

*** Test Cases ***
GET PNFD Content
    [Documentation]   The GET method fetches the content of the PNFD..
    ...    This method shall follow the provisions specified in the Tables 5.4.7.3.2-1 and 5.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The GET method queries PNFD Content
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_PLAIN}


GET PNFD Content- Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${erroneous_pnfdId}/pnfd_content
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

  
GET PNFD Content - Negative (onboardingState issue)
    Log    Trying to get a PNFD content present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${onboardingStatePnfdId}/pnfd_content
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
      
        
PUT a PNFD Content 
    Log    Trying to perform a PUT. This method upload the content of a PNFD
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content    ${body}
    Integer    response status    204
    Log    Received 204 No Content as expected
    ${response}=    Output    response body
    Should Be Empty    ${response}
    ${contentType}=    Output    response headers Content-Type
    Should Be Equal    text/plain    ${contentType}    
    
    
    
PUT a PNFD Content - Negative. Nsd in CREATING state
    Log    Trying to perform a PUT.
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${creatingPnfdId}/pnfd_content    ${body}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
 
        

POST a PNFD Content (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected



PATCH a NSDContent (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE a NSDContent (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
