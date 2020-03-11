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
NSD Onboarding Notification
    [Documentation]    Test ID: 5.3.1.9.1
    ...    Test title: NSD Onboarding Notification
    ...    Test objective: The objective is to test the dispatch of NSD Onboarding notification when the NSD onboarding operation is successfully completed, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A NSD management subscription for onboarding notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the completion of NSD Onboarding (external action) 
    Check NSD Onboarding Notification Http Request Body Json Schema Is    NsdOnboardingNotification
    Check NSD Onboarding Notification Http Request Body notificationType attribute Is    NsdOnboardingNotification
    
NSD Onboarding Failure Notification
    [Documentation]    Test ID: 5.3.1.9.2
    ...    Test title: NSD Onboarding Failure Notification
    ...    Test objective: The objective is to test the dispatch of NSD Onboarding failure notification when the NSD onboarding operation fails, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A NSD management subscription for onboarding failure notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the failure of NSD Onboarding (external action) 
    Check NSD Onboarding Failure Notification Http Request Body Json Schema Is    NsdOnboardingFailureNotification
    Check NSD Onboarding Failure Notification Http Request Body notificationType attribute Is    NsdOnboardingFailureNotification

NSD Operational State Change Notification
    [Documentation]    Test ID: 5.3.1.9.3
    ...    Test title: NSD Operational State Change Notification
    ...    Test objective: The objective is to test the dispatch of NSD Operational State Change notification when the NSD operational status change in the NFVO, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A NSD management subscription for operational state change notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Trigger the change of NSD Operational State (external action) 
    Check NSD Operational State Change Notification Http Request Body Json Schema Is    NsdChangeNotification
    Check NSD Operational State Change Notification Http Request Body notificationType attribute Is    NsdChangeNotification

NSD Deletion Notification
    [Documentation]    Test ID: 5.3.1.9.4
    ...    Test title: NSD Deletion Notification
    ...    Test objective: The objective is to test the dispatch of NSD Deletion notification when the NSD is deleted from the NFVO, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A NSD management subscription for deletion notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Trigger the deletion of NSD (external action) 
    Check NSD Deletion Notification Http Request Body Json Schema Is    NsdDeletionNotification
    Check NSD Deletion Notification Http Request Body notificationType attribute Is    NsdDeletionNotification
    
PNFD Onboarding Notification
    [Documentation]    Test ID: 5.3.1.9.5
    ...    Test title: PNFD Onboarding Notification
    ...    Test objective: The objective is to test the dispatch of PNFD Onboarding notification when the PNFD onboarding operation is successfully completed, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A PNFD management subscription for onboarding notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the completion of PNFD Onboarding (external action) 
    Check PNFD Onboarding Notification Http Request Body Json Schema Is    PnfdOnboardingNotification
    Check PNFD Onboarding Notification Http Request Body notificationType attribute Is    PnfdOnboardingNotification
    
PNFD Onboarding Failure Notification
    [Documentation]    Test ID: 5.3.1.9.6
    ...    Test title: PNFD Onboarding Failure Notification
    ...    Test objective: The objective is to test the dispatch of PNFD Onboarding failure notification when the PNFD onboarding operation fails, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A PNFD management subscription for onboarding failure notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Trigger the failure of PNFD Onboarding (external action) 
    Check PNFD Onboarding Failure Notification Http Request Body Json Schema Is    PnfdOnboardingFailureNotification
    Check PNFD Onboarding Failure Notification Http Request Body notificationType attribute Is    PndfOnboardingFailureNotification

PNFD Deletion Notification
    [Documentation]    Test ID: 5.3.1.9.7
    ...    Test title: PNFD Deletion Notification
    ...    Test objective: The objective is to test the dispatch of PNFD Deletion notification when the PNFD is deleted from the NFVO, and perform a JSON schema and content validation of the delivered notification. The action that triggers the notification under test is an explicit test step, but it is not performed by the test system.
    ...    Pre-conditions: A PNFD management subscription for deletion notifications is available in the NFVO.
    ...    Reference: clause 5.4.10.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Trigger the deletion of PNFD (external action) 
    Check PNFD Deletion Notification Http Request Body Json Schema Is    PnfdDeletionNotification
    Check PNFD Deletion Notification Http Request Body notificationType attribute Is    PnfdDeletionNotification


*** Keywords ***
Trigger the completion of NSD Onboarding (external action) 
    #do nothing
    Log    do nothing

Trigger the failure of NSD Onboarding (external action) 
    #do nothing
    Log    do nothing   

Trigger the change of NSD Operational State (external action) 
    #do nothing
    Log    do nothing
 
Trigger the deletion of NSD (external action) 
    #do nothing
    Log    do nothing
    
Trigger the completion of PNFD Onboarding (external action) 
    #do nothing
    Log    do nothing
        
Trigger the failure of PNFD Onboarding (external action) 
    #do nothing
    Log    do nothing
       
Trigger the deletion of PNFD (external action) 
    #do nothing
    Log    do nothing
 
Check PNFD Onboarding Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check PNFD Onboarding Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure PNFD Onboarding Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check PNFD Onboarding Failure Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}
    
Check PNFD Onboarding Failure Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification PNFD Onboarding Failure Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check PNFD Deletion Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check PNFD Deletion Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure PNFD Deletion Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check NSD Onboarding Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check NSD Onboarding Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure NSD Onboarding Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check NSD Onboarding Failure Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}
    

Check NSD Onboarding Failure Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure Notification NSD Onboarding Failure Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Check NSD Operational State Change Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check NSD Operational State Change Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure NSD Operational State Change Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Check NSD Deletion Notification Http Request Body Json Schema Is    
    [Arguments]    ${element}
    ${schema}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${schema}    ${callback_endpoint}    ${callback_endpoint_fwd}

Check NSD Deletion Notification Http Request Body notificationType attribute Is
    [Arguments]    ${type}
    Configure NSD Deletion Handler    ${callback_endpoint_fwd}    ${type}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}

Configure PNFD Deletion Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure NSD Deletion Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure NSD Operational State Change Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure PNFD Onboarding Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification PNFD Onboarding Failure Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure NSD Onboarding Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary    ${json}    notificationType    ${type}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification NSD Onboarding Failure Handler
    [Arguments]    ${endpoint}    ${type}
    ${json}=    evaluate    {}
    set to dictionary   ${json}    notificationType    ${type}
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle status notification
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
  
Configure Notification Forward
    [Arguments]    ${schema}    ${endpoint}    ${endpoint_fwd}    
    Log  Creating mock HTTP forward to handle ${schema}
    &{notification_tmp}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON_SCHEMA"    body=${schema}
    &{notification_fwd}=  Create Mock Http Forward	${endpoint_fwd}
    Create Mock Expectation With Http Forward  ${notification_tmp}  ${notification_fwd}

Create Sessions
    Start Process  java  -jar ${MOCK_SERVER_JAR} -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}