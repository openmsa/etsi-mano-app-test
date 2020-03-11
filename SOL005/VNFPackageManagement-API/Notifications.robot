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
VNF Package Onboarding Notification
    [Documentation]    Test ID: 5.3.5.9.1
    ...    Test title: VNF Package Onboarding Notification
    ...    Test objective: The objective is to test the dispatch of VNF Package Onboarding notification when the VNF package onboarding operation is successfully completed, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A VNF package subscription for onboarding notifications is available in the NFVO.
    ...    Reference: clause 9.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the completion of VNF Package Onboarding (external action) 
    Check Onboarding Notification Http POST Request Body Json Schema Is    VnfPackageOnboardingNotification
    Check Onboarding Notification Http POST Request Body notificationType attribute Is    VnfPackageOnboardingNotification

VNF Package Operational State Change Notification
    [Documentation]    Test ID: 5.3.5.9.2
    ...    Test title: VNF Package Operational State Change Notification
    ...    Test objective: The objective is to test the dispatch of VNF Package Change notification when the VNF package operational state is modified, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A VNF package subscription for change notifications is available in the NFVO.
    ...    Reference: clause 9.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the change of VNF Package Operational State (external action) 
    Check State Change Notification Http POST Request Body Json Schema Is    VnfPackageChangeNotification
    Check State Change Notification Http POST Request Body notificationType attribute Is    VnfPackageChangeNotification
    Check State Change Notification Http POST Request Body changeType attribute Is    OP_STATE_CHANGE 

VNF Package Deletion Notification
    [Documentation]    Test ID: 5.3.5.9.3
    ...    Test title: VNF Package Deletion Notification
    ...    Test objective: The objective is to test the dispatch of VNF Package Change notification when the VNF package is deleted on the NFVO, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A VNF package subscription for change notifications is available in the NFVO.
    ...    Reference: clause 9.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the deletion of VNF Package (external action) 
    Check Deletion Notification Http POST Request Body Json Schema Is    VnfPackageChangeNotification
    Check Deletion Notification Http POST Request Body notificationType attribute Is    VnfPackageChangeNotification
    Check Deletion Notification Http POST Request Body changeType attribute Is    PKG_DELETE 


*** Keywords ***
Trigger the completion of VNF Package Onboarding (external action) 
    #do nothing
    Log    do nothing

Trigger the change of VNF Package Operational State (external action) 
    #do nothing
    Log    do nothing   

Trigger the deletion of VNF Package (external action) 
    #do nothing
    Log    do nothing   
  
Check Onboarding Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check Onboarding Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Onboarding Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check State Change Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}
    
Check Deletion Notification Http POST Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check State Change Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Change Status Handler    ${callback_endpoint_fwd}    ${type}    PKG_DELETE
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Check Deletion Notification Http POST Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification Change Status Handler    ${callback_endpoint_fwd}    ${type}    OP_STATE_CHANGE
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Check State Change Notification Http POST Request Body changeType attribute Is
    [Arguments]    ${type}
    #do nothing
    Log    do nothing 
    
Check Deletion Notification Http POST Request Body changeType attribute Is
    [Arguments]    ${type}
    #do nothing
    Log    do nothing
    
Configure Notification Onboarding Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification Delete Handler
    [Arguments]    ${endpoint}    ${type}    ${change}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}    changeType    ${change}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification Change Status Handler
    [Arguments]    ${endpoint}    ${type}    ${change}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}    changeType    ${change}
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
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}