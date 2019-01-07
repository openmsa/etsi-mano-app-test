*** Settings ***
Resource    variables.txt 
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${notification_port}


*** Test Cases ***
Deliver a notification - Alarm
    log    The POST method delivers a notification - Information of a VNF alarm.
    ${json}=	Get File	schemas/alarmNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher Schema	POST  ${notification_ep}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${notification_ep}

Deliver a notification - Alarm Clearance
    log    The POST method delivers a notification - Information of a VNF alarm.
    ${json}=	Get File	schemas/alarmClearedNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher Schema	POST  ${notification_ep}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${notification_ep}

Deliver a notification - Alarm List Rebuilt
    log    The POST method delivers a notification - Information of a VNF alarm.
    ${json}=	Get File	schemas/alarmListRebuiltNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher Schema	POST  ${notification_ep}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${notification_ep}

Test a notification end point
    log    The GET method allows the server to test the notification endpoint
    &{req}=  Create Mock Request Matcher Schema	GET  ${notification_ep}    
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Verify Mock Expectation  ${req}
    Clear Requests  ${notification_ep}

PUT notification - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Put    ${notification_ep}    
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH subscriptions - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Patch    ${notification_ep}    
    Log    Validate Status code
    Output    response
    Integer    response status    405

DELETE subscriptions - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Delete    ${notification_ep}
    Log    Validate Status code
    Output    response
    Integer    response status    405
    
*** Keywords ***
Create Sessions
    Start Process  java  -jar  ../../bin/mockserver-netty-5.3.0-jar-with-dependencies.jar  -serverPort  ${notification_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${NFVO_SCHEMA}://${NFVO_HOST}:${notification_port}     #The API producer is set to NFVO according to SOL003-7.3.4