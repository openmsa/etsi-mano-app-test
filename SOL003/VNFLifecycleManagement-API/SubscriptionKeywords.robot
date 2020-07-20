*** Settings ***
Resource    environment/variables.txt
Resource    VnfLcmMntOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}     ssl_verify=false
Library    OperatingSystem
Library    BuiltIn
Library    Process
Library    Collections
Library    JSONLibrary
Library    MockServerLibrary

*** Keywords ***
Check subscriptions about one VNFInstance and operation type
    [Arguments]    ${vnfInstanceId}    ${notificationType}    ${operationType}=""    ${operationState}=""
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Run Keyword If    ${notificationType}=="VnfIdentifierCreationNotification" or ${notificationType}=="VnfIdentifierDeletionNotification"    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?vnfInstanceIds=${vnfInstanceId}&notificationTypes=${notificationType} 
    ...    ELSE    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?vnfInstanceIds=${vnfInstanceId}&notificationTypes=${notificationType}&operationTypes=${operationType}&operationStates=${operationState}
    Integer    response status    200
    Array    response body    minItems=1
    ${body}    Output    response body
    [Return]    ${body}
  
Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
Configure Notification Status Handler
    [Arguments]    ${endpoint}    ${status}=""
    ${json}=     Create Dictionary
    ${value}=    Run Keyword And Return Status    Should Not Be Equal As Strings    ${status}        ""
    Run Keyword If   ${value} == True      Set to dictionary    ${json}    operationState    ${status}
    Log  Creating mock request and response to handle ${element}
    ${notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type='JSON'    body=${json}
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${notification_response}=  Create Mock Response	    status_code=${status}    headers=${headers}     
    Create Mock Expectation  ${notification_request}  ${notification_response}
    [Return]    ${notification_request}
    
Configure Notification VNF Instance Handler
    [Arguments]    ${endpoint}    ${instanceId}=""
    ${json}=     Create Dictionary
    ${value}=    Run Keyword And Return Status    Should Not Be Equal As Strings    ${instanceId}        ""
    Run Keyword If   ${value} == True      Set to dictionary    ${json}    vnfInstanceId    ${instanceId}
    Log  Creating mock request and response to handle ${element}
    ${notification_request}=  Create Mock Request Matcher	POST  ${endpoint}    body_type='JSON'  body=${json}
    &{headers}=  Create Dictionary  Content-Type=application/json
    ${notification_response}=  Create Mock Response     204    headers=${headers}    
    Log    ${notification_request}
    Log    ${notification_response}
    Create Mock Expectation  ${notification_request}  ${notification_response}
    [Return]    ${notification_request}

Configure Notification Forward
    [Arguments]    ${element}    ${endpoint}    ${endpoint_fwd}
    ${json}=    Get File    schemas/${element}.schema.json
    Log  Creating mock HTTP forward to handle ${element}
    ${notification_tmp}=  Create Mock Request Matcher	POST  ${endpoint}  body_type='JSON_SCHEMA'    body=${json}
    ${notification_fwd}=  Create Mock Http Forward	${endpoint_fwd}
    Create Mock Expectation With Http Forward  ${notification_tmp}  ${notification_fwd}
    [Return]  ${notification_tmp}

Check Operation Notification
    [Arguments]    ${element}    ${status}=""
    ${json}=	Get File	schemas/${element}.schema.json
    ${req1}=    Configure Notification Forward    ${element}    ${callback_endpoint}    ${callback_endpoint_fwd}
    ${req2}=    Configure Notification Status Handler    ${callback_endpoint_fwd}    ${status}
    Wait Until Keyword Succeeds    12 sec   3 sec   Verify Mock Expectation    ${req2}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Check VNF Instance Operation Notification
    [Arguments]    ${element}   ${instance_id}
    ${json}=	Get File	schemas/${element}.schema.json
    ${req1}=  Configure Notification Forward   ${element}    ${callback_endpoint}    ${callback_endpoint_fwd}
    ${req2}=  Configure Notification VNF Instance Handler    ${callback_endpoint_fwd}    ${instance_id}
    Wait Until Keyword Succeeds    12 sec  3 sec   Verify Mock Expectation    ${req2}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}