*** Setting ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    String

*** Variable ***
${callback_uri}    http://localhost
${callback_port}    9091
${callback_endpoint}    /endpoint
${callback_endpoint_error}    /endpoint_404
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
    ${json}=	Get File	schemas/PerformanceInformationAvailableNotification.schema.json
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
    

Post Performance Information Available Notification Negative 404 
    ${json}=	Get File	schemas/ProblemDetails.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle Performance Information Available Notification to handle 404 error
    &{req}=  Create Mock Request Matcher Schema	POST  ${callback_endpoint_error}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=404
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Post Threshold Crossed Notification
    ${json}=	Get File	schema/ThresholdCrossedNotification.schema.json
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
    

PostThreshold Crossed Notification Negative 404 
    ${json}=	Get File	schemas/ProblemDetails.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handleThreshold Crossed Notification to handle 404 error
    &{req}=  Create Mock Request Matcher Schema	POST  ${callback_endpoint_error}  body=${BODY}
    &{rsp}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=404
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
    
PUT Performance Notification 
    Log  PUT Method not implemented
    &{req}=  Create Mock Request Matcher Schema	PUT  ${callback_endpoint}
    &{rsp}=  Create Mock Response Schema  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
    
PATCH Performance Notification 
    Log  PATCH Method not implemented
    &{req}=  Create Mock Request Matcher Schema	PATCH  ${callback_endpoint}
    &{rsp}=  Create Mock Response Schema  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
    
DELETE Performance Notification 
    Log  PATCH Method not implemented
    &{req}=  Create Mock Request Matcher Schema	DELETE  ${callback_endpoint}
    &{rsp}=  Create Mock Response Schema  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
	

*** Keywords ***
Create Sessions
    Start Process  java  -jar  ../../mockserver-netty-5.3.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}