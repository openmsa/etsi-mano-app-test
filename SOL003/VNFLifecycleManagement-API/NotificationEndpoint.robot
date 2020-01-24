*** Settings ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Resource    environment/variables.txt 
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    Collections

*** Test Cases ***
VNF LCM Operation Occurrence Start Notification
    [Documentation]    Test ID: 7.3.1.19.1
    ...    Test title: VNF LCM Operation Occurrence Start Notification
    ...    Test objective: The objective is to test the dispatch of VNF LCM Operation Occurrence Start Notification when a new VNF LCM operation is started in the VNFM, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A subscription for VNF LCM Operation Occurrence notifications is available in the VNFM.
    ...    Reference: clause 5.4.20.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger a VNF LCM operation (external action) 
    Check VNF LCM Operation Occurrence Start Notification Http POST Request Body Json Schema Is    VnfLcmOperationOccurrenceNotification
    Check VNF LCM Operation Occurrence Start Notification Http POST Request Body notificationType attribute Is    VnfLcmOperationOccurrenceNotification
    Check VNF LCM Operation Occurrence Start Notification Http POST Request Body notificationStatus attribute Is    START
    
VNF LCM Operation Occurrence Result Notification
    [Documentation]    Test ID: 7.3.1.19.2
    ...    Test title: VNF LCM Operation Occurrence Result Notification
    ...    Test objective: The objective is to test the dispatch of VNF LCM Operation Occurrence Result Notification when a VNF LCM operation is completed in the VNFM, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: An VNF LCM operation is in progress, and a subscription for VNF LCM Operation Occurrence notifications is available in the VNFM.
    ...    Reference: clause 5.4.20.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the completion of an VNF LCM operation (external action)
    Check VNF LCM Operation Occurrence Result Notification Http POST Request Body Json Schema Is    VnfLcmOperationOccurrenceNotification
    Check VNF LCM Operation Occurrence Result Notification Http POST Request Body notificationType attribute Is    VnfLcmOperationOccurrenceNotification
    Check VNF LCM Operation Occurrence Start Notification Http POST Request Body notificationStatus attribute Is    RESULT
    
VNF Identifier Creation Notification
    [Documentation]    Test ID: 7.3.1.19.3
    ...    Test title: VNF Identifier Creation Notification
    ...    Test objective: The objective is to test the dispatch of VNF Identifier Creation Notification when a new VNF instance resource is created in the VNFM, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A subscription for VNF identifier creation notifications is available in the VNFM.
    ...    Reference: clause 5.4.20.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the creation of a VNF instance resource (external action)
    Check VNF Identifier Creation Notification Http POST Request Body Json Schema Is    VnfIdentifierCreationNotification
    Check VNF Identifier Creation Notification Http POST Request Body notificationType attribute Is    VnfIdentifierCreationNotification
    
VNF Identifier Deletion Notification
    [Documentation]    Test ID: 7.3.1.19.4
    ...    Test title: VNF Identifier Deletion Notification
    ...    Test objective: The objective is to test the dispatch of VNF Identifier Deletion Notification when a VNF instance resource is deleted in the VNFM, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A VNF instance resource is created, and a subscription for VNF identifier creation notifications is available in the VNFM.
    ...    Reference: clause 6.4.18.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the deletion of a VNF instance resource (external action)
    Check VNF Identifier Deletion Notification Http POST Request Body Json Schema Is    VnfIdentifierDeletionNotification
    Check VNF Identifier Deletion Notification Http POST Request Body notificationType attribute Is    VnfIdentifierDeletionNotification
    
*** Keywords ***
Trigger a VNF LCM operation (external action) 
    #do nothing
    Log    do nothing

Trigger the completion of an VNF LCM operation (external action)
    #do nothing
    Log    do nothing   
    
Trigger the creation of a VNF instance resource (external action)
    #do nothing
    Log    do nothing     
  
Trigger the deletion of a VNF instance resource (external action)
    #do nothing
    Log    do nothing     
    
Check VNF LCM Operation Occurrence Start Notification Http POST Request Body Json Schema Is  
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check VNF LCM Operation Occurrence Start Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification VNF LCM Operation Occurrence Start Handler    ${callback_endpoint_fwd}    ${type}    START
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Configure Notification VNF LCM Operation Occurrence Start Handler
    [Arguments]    ${endpoint}    ${type}    ${status}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}    changeType    ${status}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Check VNF LCM Operation Occurrence Result Notification Http POST Request Body Json Schema Is  
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check VNF LCM Operation Occurrence Result Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification VNF LCM Operation Occurrence Result Handler    ${callback_endpoint_fwd}    ${type}    RESULT
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Configure Notification VNF LCM Operation Occurrence Result Handler
    [Arguments]    ${endpoint}    ${type}    ${status}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}    changeType    ${status}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Check VNF Identifier Creation Notification Http POST Request Body Json Schema Is  
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check VNF Identifier Creation Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification VNF Identifier Creation Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Configure Notification VNF Identifier Creation Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    
Check VNF Identifier Deletion Notification Http POST Request Body Json Schema Is  
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check VNF Identifier Deletion Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification VNF Identifier Deletion Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Configure Notification VNF Identifier Deletion Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Check VNF LCM Operation Occurrence Start Notification Http POST Request Body notificationStatus attribute Is
    [Arguments]    ${type}
    #do nothing
    Log    do nothing
    
Check VNF LCM Operation Occurrence Result Notification Http POST Request Body notificationStatus attribute Is
    [Arguments]    ${type}
    #do nothing
    Log    do nothing

Configure Notification Forward
    [Arguments]    ${schema}    ${endpoint}    ${endpoint_fwd}    
    Log  Creating mock Http POST forward to handle ${schema}
    &{notification_tmp}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON_SCHEMA"    body=${schema}
    &{notification_fwd}=  Create Mock Http Forward	${endpoint_fwd}
    Create Mock Expectation With Http Forward  ${notification_tmp}  ${notification_fwd}

Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}

