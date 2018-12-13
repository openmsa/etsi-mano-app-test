*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${notification_port}
Library    MockServerLibrary
Library    Process
Library    OperatingSystem

*** Variables ***
${sleep_interval}    20s

*** Test Cases ***
Deliver a notification - Vr Quota Availibility
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/VrQuotaAvailNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle Vr Quota AvailibilityNotification
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
    Get    ${notification_ep}
    Log    Validate Status code
    Output    response
    Integer    response status    204

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
    Create Mock Session  ${NFVO_SCHEMA}://${NFVO_HOST}:${notification_port}     #The API producer is set to NFVO according to SOL003-5.3.9