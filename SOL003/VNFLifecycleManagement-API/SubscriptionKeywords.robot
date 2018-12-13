*** Settings ***
Resource          environment/variables.txt
Library           REST    http://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library           OperatingSystem
Library           BuiltIn
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
    
   
Deliver a notification - Operation Occurence
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/vnfLcmOperationOccurrenceNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle vnfLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher    POST  ${notification_ep} body_type='JSON_SCHEMA' body=${BODY}
    &{rsp}=  Create Mock Response	204 headers="Content-Type: application/json"  body_type='JSON_SCHEMA'
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${notification_ep}

    

    