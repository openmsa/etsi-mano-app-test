*** Setting ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    String
Library    JSONSchemaLibrary    schemas/
Library    JSONLibrary
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}



*** Test Cases ***
Create VNFInstantiation
    ${post_response} =    Instantiate VNF
    Validate Status Code    ${post_response.status_code}    201
    Validate Header    ${post_response.headers}    Location
    Validate Header    ${post_response.headers}    Content-Type
    Validate JsonSchema    ${post_response.body}    vnfInstance.schema.json
    ${get_response}=    Retrieve VNFinstance    ${post_response.body.id}
    Should Not Be Empty    ${get_response}
    Validate Status Code    ${get_response.status_code}    200
    Should Be Equal    ${post_response.body.id}    ${get_response.body.id}    
    Validate Header    ${get_response.headers}    Content-Type
    Validate JsonSchema    ${get_response.body}    vnfInstance.schema.json
    
    
*** Keywords ***
Instantiate VNF
    Log    Create VNF instance by POST to ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/createVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    ${body}
    [Return]    response 


Validate Status Code
    [Arguments]    ${curr_status}    ${exp_status}    
    Should Be Equal    ${curr_status}    ${exp_status}
    Log    Status code validated 


Validate Header
    [Arguments]    ${headers}    ${CONTENT_TYPE}
    Should Contain    ${headers}    ${CONTENT_TYPE}
    Log    Header is present


Validate JsonSchema
    [Arguments]    ${body}    ${schema}
    ${json}=    evaluate    json.loads('''${body}''')    json
    Validate Json    ${schema}    ${json}
    Log    Validation OK
    
Retrieve VNFinstance
    [Arguments]    ${vnfId}
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfId}
    [Return]	response