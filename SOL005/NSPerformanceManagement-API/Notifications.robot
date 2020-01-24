*** Setting ***
Resource	environment/notifications.txt
Resource	environment/variables.txt
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    String


*** Test Cases ***
NS Performance Information Availability Notification
    [Documentation]    Test ID: 5.3.4.8.1
    ...    Test title: NS Performance Information Availability Notification
    ...    Test objective: The objective is to test the dispatch of NS Performance Information Availability Notification when new NS performance information is available in the NFVO, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A NS performance job is created, and a subscription for information availability notifications is available in the NFVO.
    ...    Reference: clause 7.4.9.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the availability of NS Performance Information (external action) 
    Check Performance Information Available Notification Http POST Request Body Json Schema Is    PerformanceInformationAvailableNotification
    Check Performance Information Available Notification Http POST Request Body notificationType attribute Is    PerformanceInformationAvailableNotification

NS Threshold Crossed Notification
    [Documentation]    Test ID: 5.3.4.8.2
    ...    Test title: NS Threshold Crossed Notification
    ...    Test objective: The objective is to test the dispatch of NS Threshold Crossed Notification when a previously set NS performance metric threshold is crossed, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A NS performance job is created, and a threshold subscription is available in the NFVO.
    ...    Reference: clause 7.4.9.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the cross of NS Performance Threshold (external action) 
    Check Threshold Crossed Notification Http POST Request Body Json Schema Is    ThresholdCrossedNotification
    Check Threshold Crossed Notification Http POST Request Body notificationType attribute Is    ThresholdCrossedNotification


*** Keywords ***
Trigger the availability of NS Performance Information (external action) 
    #do nothing
    Log    do nothing

Trigger the cross of NS Performance Threshold (external action) 
    #do nothing
    Log    do nothing   
  
Check Performance Information Available Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check Performance Information Available Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Performance Information Available Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check Threshold Crossed Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}
    

Check Threshold Crossed Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Threshold Crossed Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
    
Check Threshold Crossed Notification Http POST Request Body changeType attribute Is
    [Arguments]    ${type}
    #do nothing
    Log    do nothing 
    
    
Configure Notification Performance Information Available Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification Threshold Crossed Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
  
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