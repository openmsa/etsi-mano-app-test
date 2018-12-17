*** Settings ***
Resource    environment/variables.txt
Library    REST    http://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
  

*** Keywords ***

Get Vnf Instance 
    [Arguments]    ${vnfInstanceId}
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    ${body}=    Output    response body
    ${json}=    evaluate    json.loads('''${body}''')    json
    [Return]    ${json}    ${body.aspectId}

Check resource Instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200
    String    response body instantiationState    INSTANTIATED

Get Vnf Scale Info
    [Arguments]    ${vnfInstanceId}
    ${vnfInstance}=    Get Vnf Instance    ${vnfInstanceId}
    ${scaleInfo}=    Get Value From Json    ${vnfInstance}    $..scaleStatus
    [Return]   ${scaleInfo} 

Check Response Status
    [Arguments]    ${expected_status}    ${status}
    Should Be Equal    ${expected_status}    ${status}
    Log    Status code validated 
    
Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}    ${headers}
    Should Contain    ${headers}    ${CONTENT_TYPE}
    Log    Header is present 

Send VNFscaleOut Request
    [Arguments]    ${vnfInstanceId}
    Log    Trying to scale a vnf Instance
    Set Headers    {"Accept":"${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/scaleVnfOutRequest.json  
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    [Return]    ${response}

Get VnfLcmOpOccId
    [Arguments]    ${headers}
    ${json}=    evaluate    json.loads('''${headers}''')    json
    ${vnfLcmOpOccId}=    Get Value From Json    ${json}    $..Location
    Should Not Be Empty    ${vnfLcmOpOccId}
    [Return]    ${vnfLcmOpOccId}

Get VnfLcmOccInstance
    [Arguments]    ${vnfLcmOpOccId}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    ${body}=    Output    response body
    ${json}=    evaluate    json.loads('''${body}''')    json
    [Return]    ${json}

Check operationState
    [Arguments]    ${operationState}    ${VnfLcmOccInstance}
    ${currentState}=    Get Value From Json    ${VnfLcmOccInstance}    $..operationState
    Should Be Equal    ${currentState}    ${operationState}
    
Create a new Grant - Synchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 0    The Granting process is asynchronous mode. Skipping the test
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    Integer    response status    201
    Log    Status code validated 
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    grant.schema.json    ${json}
    Log    Validation OK

Create a new Grant - Asynchronous mode
    Log    Request a new Grant for a VNF LCM operation by POST to ${apiRoot}/${apiName}/${apiVersion}/grants
    Pass Execution If    ${SYNC_MODE} == 1    The Granting process is synchronous mode. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    json/grantRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}
    Output    response
    Integer    response status    202
    Log    Status code validated
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    Log    Validation OK