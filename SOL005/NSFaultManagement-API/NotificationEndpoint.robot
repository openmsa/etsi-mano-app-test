*** Settings ***
Resource    environment/variables.txt 
Resource    NSFMOperationKeywords.robot   

Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    Collections

Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
NS Fault Alarm Notification
    [Documentation]    Test ID: 5.3.3.5.1
    ...    Test title: NS Fault Alarm Notification
    ...    Test objective: The objective is to test the dispatch of NS Fault Alarm Notification when a virtualised resource within an NS instance fails, and perform a JSON schema and content validation of the delivered notification
    ...    Pre-conditions: A NS instance is instantiated, and a subscription for fault alarm notifications is available in the NFVO.
    ...    Reference:  section 8.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the fault of a virtualised resource in the NS instance (external action) 
    Check Alarm Notification Http POST Request Body Json Schema Is    alarmNotification
    Check Alarm Notification Http POST Request Body notificationType attribute Is    alarmNotification

NS Fault Alarm Cleared Notification
    [Documentation]    Test ID: 5.3.3.5.2
    ...    Test title: NS Fault Alarm Cleared Notification
    ...    Test objective: The objective is to test the dispatch of NS Fault Alarm Cleared Notification when a faulty virtualised resource within an NS instance is cleared, and perform a JSON schema and content validation of the delivered notification
    ...    Pre-conditions: A NS instance is instantiated, a virtualised resource is in faulty state, and a subscription for fault alarm cleared notifications is available in the NFVO.
    ...    Reference:  section 8.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the fault cleared of a virtualised resource in the NS instance (external action) 
    Check Alarm cleared Notification Http POST Request Body Json Schema Is    alarmClearedNotification
    Check Alarm cleared Notification Http POST Request Body notificationType attribute Is    alarmClearedNotification

NS Fault Alarm List Rebuilt Notification 
    [Documentation]    Test ID: 5.3.3.5.3
    ...    Test title: NS Fault Alarm List Rebuilt Notification 
    ...    Test objective: The objective is to test the dispatch of NS Fault Alarm List Rebuilt Notification when the NFVO decides to rebuild the list of its NS alarms, e.g. due to a corruption in the alarm storage, and perform a JSON schema and content validation of the delivered notification
    ...    Pre-conditions: A NS instance is instantiated, one or more virtualised resource are in faulty state, and a subscription for fault alarm list rebuilt notifications is available in the NFVO.
    ...    Reference:  section 8.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the NS fault alarm list rebuild in the NFVO (external action) 
    Check Alarm list rebuilt Notification Http POST Request Body Json Schema Is    alarmListRebuiltNotification
    Check Alarm list rebuilt Notification Http POST Request Body notificationType attribute Is    alarmListRebuiltNotification


*** Keywords ***
Trigger the fault of a virtualised resource in the NS instance (external action)  
    #do nothing
    Log    do nothing

Trigger the fault cleared of a virtualised resource in the NS instance (external action) 
    #do nothing
    Log    do nothing   

Trigger the NS fault alarm list rebuild in the NFVO (external action) 
    #do nothing
    Log    do nothing 

Check Alarm List Rebuilt Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check Alarm List Rebuilt Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Alarm List Rebuilt Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check Alarm Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check Alarm Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Alarm Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check Alarm cleared Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}
    

Check Alarm cleared Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Alarm Cleareance Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
    
Check Alarm Clerance Notification Http POST Request Body changeType attribute Is
    [Arguments]    ${type}
    #do nothing
    Log    do nothing 
    

Configure Notification Alarm List Rebuilt Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification Alarm Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification Alarm Cleareance Handler
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
