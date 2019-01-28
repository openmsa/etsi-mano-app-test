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
Operate a VNF Instance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Change the external connectivity of a VNF instance
    ...    Test objective: The objective is to change the external connectivity of a VNF instance.
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM. Change the external connectivity of a VNF instance is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and external connectivity of the VNF is changed
    Send Change Ext Connectivity Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Change Ext Connectivity    STARTING
    #Create a new Grant - Sync - OPERATE
    Check Operation Notification For Change Ext Connectivity    PROCESSING
    Check Operation Notification For Change Ext Connectivity    COMPLETED
    Check Postcondition VNF Change Ext Connectivity

*** Keywords ***

Initialize System
    Create Sessions
    ${body}=    Get File    json/changeExtVnfConnectivityRequest.json
    ${changeVnfExtConnectivityRequest}=    evaluate    json.loads('''${body}''')    json    
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE

Check Postcondition VNF Change Ext Connectivity
    Check resource instantiated
    ${extVLId}=    Get Vnf Ext Link Id    ${vnfInstanceId}
    Should be Equal    ${changeVnfExtConnectivityRequest["extVirtualLinks"][0]["id"]}    ${extVLId}
    
Create a new Grant - Sync - OPERATE
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    OPERATE
    
Check Operation Notification For Change Ext Connectivity 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    