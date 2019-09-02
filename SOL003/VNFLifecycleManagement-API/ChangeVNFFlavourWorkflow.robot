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
Change VNF Flavour Workflow
    [Documentation]    Test ID: 7.3.1.21
    ...    Test title: Change VNF Flavour Workflow
    ...    Test objective: The objective is to test the workflow for a change flavour of an existing VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state . NFVO is subscribed to VNF LCM Operation Occurrence notifications 
    ...    Reference: section 5.4.7 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: Multiple flavours are supported for the VNF (as capability in the VNFD). NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and the flavour is changed
    Send Change VNF Flavour Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Change Flavour    STARTING
    Check Operation Notification For Change Flavour    PROCESSING
    Check Operation Notification For Change Flavour    COMPLETED
    Check Postcondition VNF Flavor Changed
    
#Create a new Grant Sync - CHANGE_FLAVOU Scale REMOVED

*** Keywords ***

Initialize System
    Create Sessions
    ${body}=    Get File    jsons/changeVnfFlavourRequest.json
    ${changeVnfFlavourRequest}=    evaluate    json.loads('''${body}''')    json
    ${requestedFlavour}=    Get Value From Json    ${changeVnfFlavourRequest}    $..newFlavourId
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE
    ${scaleInfo}=    Get Vnf Scale Info        ${vnfInstanceId}

Check Postcondition VNF Flavor Changed
    Check resource instantiated
    ${newFlavour}=    Get Vnf Flavour Info    ${vnfInstanceId}
    Should be Equal    ${requestedFlavour}    ${newFlavour}
    
Create a new Grant - Sync - CHANGE_FLAVOUR
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    CHANGE_FLAVOUR
    
Check Operation Notification For Change Flavour 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    