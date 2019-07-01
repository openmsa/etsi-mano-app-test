*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    environment/scaleVariables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Library    Process
Suite Setup    Initialize System
Suite Teardown    Terminate All Processes    kill=true


*** Test Cases ***
Operate a VNF Instance
    [Documentation]    Test ID: 7.3.2.3.1
    ...    Test title: Operate a VNF Instance
    ...    Test objective: The objective is to change the operational state of a VNF instance.
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: change the operational state of a VNF instance is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and the operational state is changed
    Send Change VNF Operational State Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Operate    STARTING
    #Create a new Grant - Sync - OPERATE
    Check Operation Notification For Operate    PROCESSING
    Check Operation Notification For Operate    COMPLETED
    Check Postcondition VNF OPERATE

*** Keywords ***
Initialize System
    Create Sessions
    ${body}=    Get File    jsons/operateVnfRequest.json
    ${changeVnfOperateRequest}=    evaluate    json.loads('''${body}''')    json
    ${requestedState}=    Get Value From Json    ${changeVnfOperateRequest}    $..changeStateTo 
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE

Check Postcondition VNF OPERATE
    Check resource instantiated
    ${newState}=    Get Vnf Operational State Info    ${vnfInstanceId}
    Should be Equal    ${requestedState}    ${newState}
    
Create a new Grant - Sync - OPERATE
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    OPERATE
    
Check Operation Notification For Operate 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    