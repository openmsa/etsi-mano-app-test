*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    environment/scaleVariables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
...    spec=SOL003-VNFLifecycleManagement-API.yaml
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Library    Process
Suite Setup    Initialize System
Suite Teardown    Terminate All Processes    kill=true


*** Test Cases ***
Scale out a VNF Instance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Change VNF Flavour Operation
    ...    Test objective: The objective is to test a change flavour operation of an existing VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: change flavour operation is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and the flavour is changed
    Send VNF Scale Out Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Change Flavour    STARTING
    Create a new Grant - Sync - CHANGE_FLAVOUR
    Check Operation Notification For Change Flavour    PROCESSING
    Check Operation Notification For Change Flavour    COMPLETED
    Check Postcondition VNF    CHANGE_FLAVOUR

*** Keywords ***

Initialize System
    Create Sessions
    ${body}=    Get File    json/changeVnfFlavourRequest.json
    ${changeVnfFlavourRequest}=    evaluate    json.loads('''${body}''')    json
    ${requestedFlavour}=    Get Value From Json    ${changeVnfFlavourRequest}    $..newFlavourId
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE
    ${scaleInfo}=    Get Vnf Scale Info        ${vnfInstanceId}

Check Postcondition VNF
    [Arguments]    ${operation}
    Check resource instantiated
    ${newFlavour}=    Get Vnf Flavour Info    ${vnfInstanceId}
    Should be Equal    ${requestedFlavour}    ${newFlavour}
    
Create a new Grant - Sync - CHANGE_FLAVOUR
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    CHANGE_FLAVOUR
    
Check Operation Notification For Change Flavour
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    