*** Settings ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Resource    environment/variables.txt 
Library    MockServerLibrary
Library    Process
Library    OperatingSystem


*** Test Cases ***
Deliver a notification - Operation Occurence
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/vnfLcmOperationOccurrenceNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle vnfLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Deliver a notification - Id Creation
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/vnfIdentifierCreationNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle vnfLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Deliver a notification - Id deletion
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/vnfIdentifierCreationNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle vnfLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Test a notification end point
    log    The GET method allows the server to test the notification endpoint
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
    Start Process  java  -jar  ../../bin/mockserver-netty-5.5.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}     #The API producer is set to NFVO according to SOL003-5.3.9
