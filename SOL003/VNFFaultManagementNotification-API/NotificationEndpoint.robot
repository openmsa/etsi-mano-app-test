*** Settings ***
Resource    environment/variables.txt 
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library    OperatingSystem


*** Test Cases ***
Deliver a notification - Alarm
    [Documentation]    Test ID: 7.4.5.1
    ...    Test title: Deliver a notification - Alarm
    ...    Test objective: The objective is to notify a VNF alarm or that the alarm list has been rebuilt.
    ...    Pre-conditions: The VNF has subscribed to the VNFM alarm
    ...    Reference: section 7.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    log    The POST method delivers a notification - Information of a VNF alarm.
    ${json}=	Get File	schemas/alarmNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Log  Verifying results
    Wait Until Keyword Succeeds    ${sleep_interval}    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Deliver a notification - Alarm Clearance
    [Documentation]    Test ID: 7.4.5.2
    ...    Test title: Deliver a notification - Alarm Clearance
    ...    Test objective: The objective is to notify a VNF alarm or that the alarm list has been rebuilt.
    ...    Pre-conditions: The VNF has subscribed to the VNFM alarm
    ...    Reference: section 7.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:   
    log    The POST method delivers a notification - Information of a VNF alarm.
    ${json}=	Get File	schemas/alarmClearedNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Log  Verifying results
    Wait Until Keyword Succeeds    ${sleep_interval}    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Deliver a notification - Alarm List Rebuilt
    [Documentation]    Test ID: 7.4.5.3
    ...    Test title: Deliver a notification - Alarm List Rebuilt
    ...    Test objective: The objective is to notify a VNF alarm or that the alarm list has been rebuilt.
    ...    Pre-conditions: The VNF has subscribed to the VNFM alarm
    ...    Reference: section 7.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    log    The POST method delivers a notification - Information of a VNF alarm.
    ${json}=	Get File	schemas/alarmListRebuiltNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher  POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Log  Verifying results
    Wait Until Keyword Succeeds    ${sleep_interval}    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Test a notification end point
    [Documentation]    Test ID: 7.4.5.4
    ...    Test title: Test a notification end point
    ...    Test objective: The objective is to allow the server to test the notification endpoint that is provided by the client, e.g. during subscription
    ...    Pre-conditions: 
    ...    Reference: section 7.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    log    The GET method allows the server to test the notification endpoint
    Get    ${callback_endpoint}
    Log    Validate Status code
    Integer    response status    204
    Log    Validation OK

PUT notification - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Put    ${callback_endpoint}
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH subscriptions - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Patch    ${callback_endpoint}
    Log    Validate Status code
    Output    response
    Integer    response status    405

DELETE subscriptions - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Delete    ${callback_endpoint}
    Log    Validate Status code
    Output    response
    Integer    response status    405
    
*** Keywords ***
Create Sessions
    Start Process  java  -jar  ../../bin/mockserver-netty-5.3.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}     #The API producer is set to NFVO according to SOL003-7.3.4
