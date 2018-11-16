*** Setting ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    BuiltIn
Library    RequestsLibrary
Library    Collections
Library    String

*** Variable ***
${callback_uri}    http://localhost
${callback_port}    9091
${callback_endpoint}    /endpoint
${sleep_interval}    20s

*** Test Cases ***
Check Notification Endpoint
    &{req}=  Create Mock Request Matcher Schema	GET  ${callback_endpoint}    
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Verify Mock Expectation  ${req}
    Clear Requests  ${callback_endpoint}
    
Post Performance Information Available Notification
    ${json}=	Get File	jsons/PerformanceInformationAvailableNotification.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle Performance Information Available Notification
    &{req}=  Create Mock Request Matcher Schema	POST  ${callback_endpoint}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Post Threshold Crossed Notification
    ${json}=	Get File	jsons/ThresholdCrossedNotification.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle Threshold Crossed Notification
    &{req}=  Create Mock Request Matcher Schema	POST  ${callback_endpoint}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

*** Keywords ***
Create Sessions
    Start Process  java  -jar  mockserver-netty-5.3.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
	Create Session  server  ${callback_uri}:${callback_port}
    Create Mock Session  ${callback_uri}:${callback_port}