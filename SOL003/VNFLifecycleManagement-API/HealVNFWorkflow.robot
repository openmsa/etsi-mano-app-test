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
Heal a VNF Instance
    [Documentation]    Test ID: 7.3.1.22
    ...    Test title: Heal a VNF Instance
    ...    Test objective: The objective is to heal a VNF instance.
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.4.9 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM. Heal a VNF instance is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance still in INSTANTIATED state 
    Send Heal VNF Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Heal    STARTING
    #Create a new Grant - Sync - OPERATE
    Check Operation Notification For Heal    PROCESSING
    Check Operation Notification For Heal    COMPLETED
    Check Postcondition VNF Heal

*** Keywords ***

Initialize System
    Create Sessions
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE

Check Postcondition VNF Heal
    Check resource Instantiated

Create a new Grant - Sync - OPERATE
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    OPERATE
    
Check Operation Notification For Heal 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    