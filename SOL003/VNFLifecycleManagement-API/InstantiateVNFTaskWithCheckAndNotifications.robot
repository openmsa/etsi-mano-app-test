*** Setting ***
Suite Setup       Initialize System
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

*** Variables ***
${headers} 
${vnfLcmOpOccId}
${response}
&{notification_request}
&{notification_response}
${vnfInstanceId}

*** Test Cases ***
VNF Instantiation
[Documentation]    Test ID: 5.x.y.x
    ...    Test title: VNF Instantiation
    ...    Test objective: The objective is to test the instantiation of a VNF instance
    ...    Pre-conditions: VNF instance resources is created (Test ID: 5.a.b.c)
    ...    Reference: section 5.x.y - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: VNFM is in direct mode
    ...    Post-Conditions: VNF instance in INSTANTIATED state
    Send VNF Instantiation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check Operation Occurrence Id
    Check Operation Notification    STARTING
    Check Operation Notification    PROCESSING
    Check Operation Notification    COMPLETED
    Check Postcondition  
    
*** Keywords ***
Send VNF Instantiation Request
    Log    Instantiate a VNF Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/instantiateVnfRequest.json
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate    ${body}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated 

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
    Log    Header is present

Check Operation Occurrence Id
    ${vnfLcmOpOccId}=    Get Value From Json    ${response.headers}    $..Location
    Should Not Be Empty    ${vnfLcmOpOccId}

Check HTTP Response Body Json Schema Is
    [Arguments]    ${schema}
    ${json}=    evaluate    json.loads('''${response.body}''')    json
    Validate Json    ${schema}    ${json}
    ${vnfInstanceId}=    ${response.body.id}
    Log    Json Schema Validation OK
    
Check VNF Status
    [Arguments]    ${current}    ${expected}
    Should Be Equal As Strings    ${current}    ${expected}
    Log    VNF Status in the correct status
    
Check VNF Instance
    [Arguments]    ${vnfId}
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfId}

Create Sessions
    Start Process  java  -jar  ../../bin/mockserver-netty-5.3.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
Configure Notification Handler
    [Arguments]    ${element}    ${endpoint}
    ${json}=	Get File	schemas/${element}.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle ${element}
    &{notification_request}=  Create Mock Request Matcher Schema	POST  ${endpoint}  body=${BODY}
    &{notification_response}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    
Check Operation Notification
    [Arguments]    ${status}
    Configure Notification Handler     VnfLcmOperationOccurrenceNotification    ${callback_endpoint}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Notification    ${status}
    Get    ${vnfLcmOpOccId}
    ${body}=    Output    response body
    Should Be Equal    ${body.operationState}   ${status}
    Clear Requests  ${callback_endpoint}

Verify Notification COMPLETED
    [Arguments]    ${status}
    Verify Mock Expectation     ${notification_request} 

Create VNF Resource
    Log    Create VNF instance by POST to ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/createVnfRequest.json
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    ${body}

Initialize System
    Create Sessions
    Configure Notification Handler     VnfIdentifierCreationNotification    ${callback_endpoint}
    Create VNF Resource
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header Contains    ${response.headers}    Content-Type
    Check HTTP Response Body Json Schema Is    vnfInstance.schema.json

Check Postcondition
    Log    Retrieve VNF Instance
    Check VNF Instance    ${vnfInstanceId}
    Should Not Be Empty    ${response}
    Check HTTP Status Code Is    200
    Should Be Equal    ${response.body.id}    ${vnfInstanceId}    
    Check HTTP Response Header Contains    Content-Type
    Check HTTP Response Json Schema    ${response.body}    vnfInstance.schema.json
    Check VNF Status    ${response.body.instantiationState}    INSTANTIATED