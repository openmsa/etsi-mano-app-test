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
    Log    The GET method allows the server to test the notification endpoint
    &{req}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Verify Mock Expectation  ${req}
    Clear Requests  ${callback_endpoint}

PUT notification - Method not implemented
    Log  PUT Method not implemented
    &{req}=  Create Mock Request Matcher	PUT  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

PATCH subscriptions - Method not implemented
    Log  PATCH Method not implemented
    &{req}=  Create Mock Request Matcher	PATCH  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

DELETE subscriptions - Method not implemented
    Log  DELETE Method not implemented
    &{req}=  Create Mock Request Matcher	DELETE  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
*** Keywords ***
Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}  
