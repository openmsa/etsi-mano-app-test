*** Setting ***
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
Check Notification Endpoint
    &{req}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Verify Mock Expectation  ${req}
    Clear Requests  ${callback_endpoint}
    
Post VNF Indicator Notification
    ${json}=	Get File	schemas/VnfIndicatorValueChangeNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle VNF Indicator Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Post VNF Indicator Notification Negative 404 
    ${json}=	Get File	schemas/ProblemDetails.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle VNF Indicator Notification to handle 404 error
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint_error}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=404
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
    
    
Put VNF Indicator Notification 
    Log  PUT Method not implemented
    &{req}=  Create Mock Request Matcher	PUT  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
    
Patch VNF Indicator Notification 
    Log  PATCH Method not implemented
    &{req}=  Create Mock Request Matcher	PATCH  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
    
    
Delete VNF Indicator Notification 
    Log  PATCH Method not implemented
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
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    