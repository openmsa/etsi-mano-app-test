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
VNF Indicator Value Change Notification
    [Documentation]    Test ID: 6.3.2.6.1
    ...    Test title: VNF Indicator Value Change Notification
    ...    Test objective: The objective is to test the dispatch of VNF Indicator Value Change Notification when new indicator values are available in the VNF, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A VNF is instantiated, and a subscription for indicator value change notifications is available in the VNF.
    ...    Reference: clause 8.4.7.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNF
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the availability of new indicator value in the VNF (external action) 
    Check Indicator Value Change Notification Http POST Request Body Json Schema Is    VnfIndicatorValueChangeNotification
    Check Indicator Value Change Notification Http POST Request Body notificationType attribute Is    VnfIndicatorValueChangeNotification


*** Keywords ***
Trigger the availability of new indicator value in the VNF (external action) 
    #do nothing
    Log    do nothing
 
  
Check Indicator Value Change Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check Indicator Value Change Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Indicator Value Change Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}  
    
Configure Notification Indicator Value Change Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
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

Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}