*** Settings ***
Resource          environment/variables.txt
Resource          VnfLcmMntOperationKeywords.robot
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library           OperatingSystem
Library           BuiltIn
Library    Process
Library           JSONLibrary
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

Configure Notification Handler
    [Arguments]    ${element}    ${endpoint}
    ${json}=	Get File	schemas/${element}.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle ${element}
    &{notification_request}=  Create Mock Request Matcher Schema	POST  ${endpoint}  body=${BODY}
    &{notification_response}=  Create Mock Response Schema	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    [Return]        &{notification_request}
    
Check Operation Notification
    [Arguments]    ${status}    ${endpoint}
    ${req}=    Configure Notification Handler     VnfLcmOperationOccurrenceNotification    ${endpoint}
    Wait Until Keyword Succeeds    2 min   10 sec    Verify Mock Expectation     ${req}    
    ${VnfLcmOccInstance}=    Get VnfLcmOccInstance    ${vnfLcmOpOccId}
    Check operationState    ${status}    ${VnfLcmOccInstance}
    Clear Requests  ${endpoint}
    
Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${notification_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${NFVO_SCHEMA}://${NFVO_HOST}:${notification_port}     #The API producer is set to NFVO according to SOL003-5.3.9

    

    