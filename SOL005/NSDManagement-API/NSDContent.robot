*** Settings ***
Documentation     This clause defines the content of the individual NS descriptor, i.e. NSD content
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library           OperatingSystem

*** Test Cases ***
GET NSD Content
    [Documentation]   The GET method fetches the content of the NSD.
    ...    The NSD can be implemented as a single file or as a collection of multiple files. If the NSD is implemented in the form
    ...    of multiple files, a ZIP file embedding these files shall be returned. If the NSD is implemented as a single file, either
    ...    that file or a ZIP file embedding that file shall be returned.
    ...    
    ...    The selection of the format is controlled by the "Accept" HTTP header passed in the GET request:
    ...    
    ...    - If the "Accept" header contains only "text/plain" and the NSD is implemented as a single file, the file shall be
    ...    returned; otherwise, an error message shall be returned.
    ...    
    ...    - If the "Accept" header contains only "application/zip", the single file or the multiple files that make up the
    ...    NSD shall be returned embedded in a ZIP file.
    ...    
    ...    - If the "Accept" header contains both "text/plain" and "application/zip", it is up to the NFVO to choose the
    ...    format to return for a single-file NSD; for a multi-file NSD, a ZIP file shall be returned.
    ...    
    ...    NOTE: The structure of the NSD zip file is outside the scope of the present document.
    ...    
    ...    This method shall follow the provisions specified in the Tables 5.4.4.3.2-1 and 5.4.4.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The GET method queries multiple NS descriptors
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_ZIP}


GET NSD Content - Range
    Log    Trying to get a NSD Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content
    Integer    response status    206
    Log    Received 206 Partial Content as expected.
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Content-Range
    Log    Header Content-Range is present
    Should Contain    ${headers}    Content-Length
    Log    Header Content-Length is present
    
    
        
GET NSD Content - Negative Range
    Log    Trying to get a range of bytes of the limit of the NSD Content
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content
    Integer    response status    416
    Log    Received 416 Range not satisfiable as expected.
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK        
        
        


GET NSD Content- Negative (Not Found)
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${erroneous_nsdInfoId}/nsd_content
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK

  
GET NSD Content - Negative (onboardingState issue)
    Log    Trying to get a NSD content present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${onboardingStateNsdInfoId}/nsd_content
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
      
        
PUT a NSD Content - Asynchronous mode
    [Documentation]    The NSD to be uploaded can be implemented as a single file or as a collection of multiple files, as defined in
    ...    clause 5.4.4.3.2. If the NSD is implemented in the form of multiple files, a ZIP file embedding these files shall be
    ...    uploaded. If the NSD is implemented as a single file, either that file or a ZIP file embedding that file shall be uploaded.
    ...    The "Content-Type" HTTP header in the PUT request shall be set accordingly based on the format selection of the
    ...    NSD.
    ...    
    ...    - If the NSD to be uploaded is a text file, the "Content-Type" header is set to "text/plain".
    ...    
    ...    - If the NSD to be uploaded is a zip file, the "Content-Type" header is set to "application/zip".
    ...    
    ...    This method shall follow the provisions specified in the Tables 5.4.4.3.3-1 and 5.4.4.3.3-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content    ${body}
    Integer    response status    202
    Log    Received 202 Accepted as expected
    ${response}=    Output    response body
    Should Be Empty    ${response}    
    
    
PUT a NSD Content - Synchronous mode
    [Documentation]    The NSD to be uploaded can be implemented as a single file or as a collection of multiple files, as defined in
    ...    clause 5.4.4.3.2. If the NSD is implemented in the form of multiple files, a ZIP file embedding these files shall be
    ...    uploaded. If the NSD is implemented as a single file, either that file or a ZIP file embedding that file shall be uploaded.
    ...    The "Content-Type" HTTP header in the PUT request shall be set accordingly based on the format selection of the
    ...    NSD.
    ...    
    ...    - If the NSD to be uploaded is a text file, the "Content-Type" header is set to "text/plain".
    ...    
    ...    - If the NSD to be uploaded is a zip file, the "Content-Type" header is set to "application/zip".
    ...    
    ...    This method shall follow the provisions specified in the Tables 5.4.4.3.3-1 and 5.4.4.3.3-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content    ${body}
    Integer    response status    200
    Log    Received 200 OK as expected
    ${response}=    Output    response body
    Should Be Empty    ${response}   
    
    
PUT a NSD Content - Negative. Nsd in CREATING state
    [Documentation]    The NSD to be uploaded can be implemented as a single file or as a collection of multiple files, as defined in
    ...    clause 5.4.4.3.2. If the NSD is implemented in the form of multiple files, a ZIP file embedding these files shall be
    ...    uploaded. If the NSD is implemented as a single file, either that file or a ZIP file embedding that file shall be uploaded.
    ...    The "Content-Type" HTTP header in the PUT request shall be set accordingly based on the format selection of the
    ...    NSD.
    ...    
    ...    - If the NSD to be uploaded is a text file, the "Content-Type" header is set to "text/plain".
    ...    
    ...    - If the NSD to be uploaded is a zip file, the "Content-Type" header is set to "application/zip".
    ...    
    ...    This method shall follow the provisions specified in the Tables 5.4.4.3.3-1 and 5.4.4.3.3-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${creatingNsdInfoId}/nsd_content    ${body}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    Validate Json    ProblemDetails.schema.json    ${problemDetails}
    Log    Validation OK
 
        

POST a NSD Content (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected



PATCH a NSD Content (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE a NSD Content (Method not implemented)
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}/nsd_content
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
