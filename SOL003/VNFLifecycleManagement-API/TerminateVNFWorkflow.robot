*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    environment/scaleVariables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}        ssl_verify=false
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Library    Process


*** Test Cases ***
Terminate a VNF Instance
    [Documentation]    Test ID: 7.3.1.33.1
    ...    Test title: Terminate a VNF Instance
    ...    Test objective: The objective is to terminate a VNF instance.
    ...    Pre-conditions: VNF instance in INSTANTIATED state 
    ...    Reference: Clause 5.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM. 
    ...    Post-Conditions: VNF instance in NOT_INSTANTIATED state 
    Send Terminate VNF Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Terminate    STARTING
    Check Operation Notification For Terminate    PROCESSING
    Check Operation Notification For Terminate    COMPLETED
    Check Postcondition VNF Terminate

*** Keywords ***

Initialize System
    Create Sessions
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE

Check Postcondition VNF Terminate
    Check resource not Instantiated

Create a new Grant - Sync - OPERATE
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    OPERATE
    
Check Operation Notification For Terminate 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    