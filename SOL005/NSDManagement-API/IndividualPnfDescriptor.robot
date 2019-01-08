*** Settings ***
Documentation     This clause defines all the resources and methods provided by the Iindividual PNF descriptor interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Single PNF Descriptor
    [Documentation]   The GET method reads information about an individual PNF descriptor.
    ...    This method shall follow the provisions specified in the Tables 5.4.6.3.2-1 and 5.4.6.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The GET method reads information about an individual PNF descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log  Validation of Content-Type : OK
#    Log    Trying to validate response
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    NsdInfo.schema.json    ${json}
#    Log    Validation OK


GET Single PNF Descriptor (Negative: Not found)
    Log    Trying to perform a GET on an erroneous pnfDescriptorInfoId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${erroneous_pnfdInfoId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK


PATCH Single PNF Descriptor - (Disabling a nsdInfo)
    [Documentation]   The PATCH method modifies the user defined data of an individual PNF descriptor resource.
    ...    This method shall follow the provisions specified in the Tables 5.4.6.3.4-1 and 5.4.6.3.4-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The PATCH method modifies the user defined data of an individual PNF descriptor resource.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    json/PnfdInfoModification.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}    ${body}
    Integer    response status    200
    Log    Received 200 OK as expected
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    PnfdInfoModification.schema.json    ${json}
#    Log    Validation of PnfdInfoModification OK


DELETE Single PNF Descriptor
    Log    Trying to perform a DELETE pnfdInfo.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${nsdInfoId}
    Integer    response status    204
    Log    Received 204 No Content as expected


POST Single PNF Descriptor (Method not implemented)
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${nsdInfoId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected



PUT Single PNF Descriptor (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${nsdInfoId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected


