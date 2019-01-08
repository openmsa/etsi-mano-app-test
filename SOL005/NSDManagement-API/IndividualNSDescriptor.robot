*** Settings ***
Documentation     This clause defines all the resources and methods provided by the Individual NS descriptor interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Single Network Service Descriptor
    [Documentation]   The GET method reads information about an individual NS descriptor.
    ...    This method shall follow the provisions specified in the Tables 5.4.3.3.2-1 and 5.4.3.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The GET method reads information about an individual NS descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log  Validation of Content-Type : OK
#    Log    Trying to validate response
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    NsdInfo.schema.json    ${json}
#    Log    Validation OK


GET Single Network Service Descriptor (Negative: Not found)
    Log    Trying to perform a GET on an erroneous nsDescriptorInfoId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${erroneous_nsdInfoId}
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK


PATCH Single Network Service Descriptor - (Disabling a nsdInfo)
    Log    Trying to perform a PATCH. As prerequisite the nsdInfo shall be in enabled operational state
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    json/NsdInfoModificationDisable.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}    ${body}
    Integer    response status    200
    Log    Received 200 OK as expected
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    NsdInfoModification.schema.json    ${json}
#    Log    Validation of NsdInfoModifications OK

PATCH Single Network Service Descriptor - (Enabling an previously disabled nsdInfo)
    Log    Trying to perform a PATCH. As prerequisite the nsdInfo shall be in disabled operational state
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    json/NsdInfoModificationEnable.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}    ${body}
    Integer    response status    200
    Log    Received 200 OK as expected
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    NsdInfoModification.schema.json    ${json}
#    Log    Validation of NsdInfoModifications OK

DELETE Single Network Service Descriptor
    Log    Trying to perform a DELETE nsdInfo. The nsdInfo should be in "NOT_USED" usageState and in "DISABLED" operationalState.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    Integer    response status    204
    Log    Received 204 No Content as expected


DELETE Single Network Service Descriptor (Negative: Trying to delete an enabled nsdInfo)
    Log    Trying to perform a DELETE nsdInfo in ENABLED operational state
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${enabledNsdInfoId}
    Integer    response status    409
    Log    Received 409 Conflict as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK


POST Single Network Service Descriptor (Method not implemented)
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected



PUT Single Network Service Descriptor (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    Integer    response status    405
    Log    Received 405 Method not implemented as expected


