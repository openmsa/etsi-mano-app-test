*** Settings ***
Documentation     This clause defines all the resources and methods provided by the PNF descriptors interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/generic.txt    # Generic Parameters
Resource          environment/pnfDescriptors.txt    # Specific nsDescriptors Parameters
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET all PNF Descriptors
    [Documentation]   The GET method queries information about multiple PNF descriptor resources.
    ...    This method shall follow the provisions specified in the Tables 5.4.5.3.2-1 and 5.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The GET method queries multiple PNF descriptors
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log  Validation of Content-Type : OK
#    Log    Trying to validate response
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    PnfdInfos.schema.json    ${json}
#    Log    Validation OK

GET all PNF Descriptors - Filter
    [Documentation]   The GET method queries information about multiple PNF descriptor resources.
    ...    This method shall follow the provisions specified in the Tables 5.4.5.3.2-1 and 5.4.5.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Log    The GET method queries multiple PNF descriptors using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?${POS_FIELDS}
    Integer    response status    200
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
#    Log    Trying to validate response
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    PnfdInfos.schema.json    ${json}
#    Log    Validation OK

GET all PNF Descriptors - Negative (wronge filter name)
    Log    The GET method queries multiple PNF descriptors using Attribute-based filtering parameters. Negative case, with erroneous attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?${NEG_FIELDS}
    Integer    response status    400
    Log    Received 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all PNF Descriptors - Negative (Unauthorized: Wrong Token)
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all PNF Descriptors - Negative (Unauthorized: No Token)
    Log    Trying to perform a negative get, using no authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    Integer    response status    401
    Log    Received 401 Unauthorized as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

GET all PNF Descriptors (Negative: Not found)
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptor
    Integer    response status    404
    Log    Received 404 Not Found as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    Log    Trying to validate ProblemDetails
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK

POST a new PNF Descriptor
    Log    Creating a new PNF descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    json/createPnfdInfoRequest.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors    ${body}
    Integer    response status    201
    Log    Received 201 Created as expected
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    Log    Response has header Location
#    ${result}=    Output    response body
#    ${json}=    evaluate    json.loads('''${result}''')    json
#    Validate Json    PnfdInfo.schema.json    ${json}
#    Log    Validation of PnfdInfo OK

PUT all PNF Descriptors (Method not implemented)
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

PATCH all PNF Descriptors (Method not implemented)
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    Integer    response status    405
    Log    Received 405 Method not implemented as expected

DELETE all PNF Descriptors (Method not implemented)
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    Integer    response status    405
    Log    Received 405 Method not implemented as expected
