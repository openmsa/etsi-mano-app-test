*** Settings ***
Resource    environment/variables.txt
Resource    VnfLcmMntOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
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
    Run Keyword If   ${status}!=""  set to dictionary    ${json["operationState"]}    dp=${status}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle ${element}
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    
Configure Notification VNF Instance Handler
    [Arguments]    ${endpoint}    ${instanceId}=""
    Run Keyword If   ${instanceId}!=""  set to dictionary    ${json["vnfInstanceId"]}    dp=${instanceId}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle ${element}
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}

Configure Notification Forward
    [Arguments]    ${element}    ${endpoint}    ${endpoint_fwd}    
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock HTTP forward to handle ${element}
    &{notification_tmp}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{notification_fwd}=  Create Mock Http Forward	${endpoint_fwd}
    Create Mock Expectation With Http Forward  ${notification_tmp}  ${notification_fwd}

Check Operation Notification
    [Arguments]    ${element}    ${status}=""
    ${json}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${element}    ${callback_endpoint}    ${callback_endpoint_fwd}
    Configure Notification Status Handler    ${callback_endpoint_fwd}    ${status}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Check VNF Instance Operation Notification
    [Arguments]    ${element}   ${instance_id}
    ${json}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${element}    ${callback_endpoint}    ${callback_endpoint_fwd}
    Configure Notification VNF Instance Handler    ${callback_endpoint_fwd}    ${instance_id}
    