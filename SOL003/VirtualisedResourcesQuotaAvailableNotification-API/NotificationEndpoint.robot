*** Settings ***
Resource    environment/variables.txt 
Library    MockServerLibrary
Library    Process
Library    OperatingSystem

*** Variables ***


*** Test Cases ***
Deliver a notification - Vr Quota Availibility
    [Documentation]    Test ID: 11.4.4.1
    ...    Test title: Deliver a notification - Vr Quota Availibility
    ...    Test objective: The objective is to notify related to the availability of the virtualised resources quota.
    ...    Pre-conditions: The VNF has subscribed to the Vr Quota Availibility resource
    ...    Reference: section 11.4.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/VrQuotaAvailNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle Vr Quota AvailibilityNotification
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
    Get    ${callback_endpoint}
    Log    Validate Status code
    Output    response
    Integer    response status    204

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
    Create Mock Session  ${callback_uri}:${callback_port}     #The API producer is set to NFVO according to SOL003-5.3.9