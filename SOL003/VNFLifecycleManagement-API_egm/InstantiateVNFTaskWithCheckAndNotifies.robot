*** Setting ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Resource    variables.txt
Library    OperatingSystem
Library    MockServerLibrary
Library    Process
Library    BuiltIn
Library    Collections
Library    String
Library    JSONSchemaLibrary    schemas/
Library    JSONLibrary
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Documentation  
...    Preconditions:
...    ...    Mock server's jar should be locally present on the same directory when the test will run
...    ...    The notification endpoint will be configured on http://localhost:8888/subscribe
...    ...    Subscription to LCM operations previously performed using as callback_URI: http://localhost:8888/subscribe.


*** Test Cases ***
Create VNFInstance
    Log    Start Notification handler
    ${req}=    Start Notification Handler     VnfIdentifierCreationNotification    ${callback_endpoint}
    Log     Create VNF Instance Resource
    ${resource_response} =    Create VNF Resource
    Validate Status Code    ${resource_response.status_code}    201
    Validate Header    ${resource_response.headers}    Location
    Validate Header    ${resource_response.headers}    Content-Type
    Validate JsonSchema    ${resource_response.body}    vnfInstance.schema.json
    Verify Notification Handler     ${req}
    Log    Instantiate VNF
    ${req}=    Start Notification Handler     VnfLcmOperationOccurrenceNotification    ${callback_endpoint}
    ${instance_response}=    Instantiate VNF   ${resource_response.body.id}
    Validate Status Code    ${instance_response.status_code}    202
    Validate Header    ${instance_response.headers}    Location
    Wait Until VNF Instantiated    ${instance_response.headers.Location}
    Verify Notification Handler     ${req}
    Log    Retrieve VNF Instance
    ${get_response}=    Retrieve VNFinstance    ${instance_response.body.id}
    Should Not Be Empty    ${get_response}
    Validate Status Code    ${get_response.status_code}    200
    Should Be Equal    ${instance_response.body.id}    ${get_response.body.id}    
    Validate Header    ${get_response.headers}    Content-Type
    Validate JsonSchema    ${get_response.body}    vnfInstance.schema.json
    
    
*** Keywords ***
Create VNF Resource
    Log    Create VNF instance by POST to ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/createVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    ${body}
    [Return]    response 


Instantiate VNF
    [Arguments]    ${vnfInstanceId}
    Log    Instantiate a vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/instantiateVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate    ${body}
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
    
Validate VNF Status
    [Arguments]    ${current}    ${expected}
    Should Be Equal As Strings    ${current}    ${expected}
    Log    VNF Status in the correct status
    
Retrieve VNFinstance
    [Arguments]    ${vnfId}
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfId}
	[Return]	response
	
Create Sessions
    Start Process  java  -jar  mockserver-netty-5.3.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
    
Start Notification Handler
    [Arguments]    ${element}    ${endpoint}
    ${json}=	Get File	schemas/${element}.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle ${element}
    &{req}=  Create Mock Request Matcher Schema	POST  ${endpoint}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    [Return]    ${req}

Verify Notification Handler
    [Arguments]    ${request}
    Verify Mock Expectation  ${request}
    Clear Requests  ${callback_endpoint}
    
Wait Until VNF Instantiated
    [Arguments]    ${vnfLcmOpOccId}
    :FOR    ${i}    IN RANGE    20
    \    Get  ${vnfLcmOpOccId}
    \    ${body}=    Output    response body
    \    Exit For Loop If    ${body.operationState} == COMPLETED
    \    Sleep 5s
