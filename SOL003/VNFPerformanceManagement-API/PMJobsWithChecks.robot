*** Setting ***
Resource    variables.txt
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    String
Library    JSONSchemaLibrary    schemas/
Library    JSONLibrary
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}



*** Test Cases ***
Create PMJob
    ${post_response} =    Create PMJob
    Validate Status Code    ${post_response.status_code}    201
    Validate Header    ${post_response.headers}    Content-Type
    Validate JsonSchema    ${post_response.body}    PmJob.schema.json
    ${get_response}=    Retrieve PMJob    ${post_response.body.id}
    Should Not Be Empty    ${get_response}
    Validate Status Code    ${get_response.status_code}    200
    Should Be Equal    ${post_response.body.id}    ${get_response.body.id}    
    Validate Header    ${get_response.headers}    Content-Type
    Validate JsonSchema    ${get_response.body}    PmJob.schema.json
    
    
*** Keywords ***
Create PMJob
    Log    Creating a new PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${VNFM_AUTH_USAGE} == 1    Set Headers    {"Authorization": "${VNFM_AUTHENTICATION}"}
    ${body}=    Get File    jsons/CreatePmJobRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs    ${body}
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
    
Retrieve PMJob
    [Arguments]    ${pmJobId}
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${pmJobId}
    [Return]    response
    
    
    
