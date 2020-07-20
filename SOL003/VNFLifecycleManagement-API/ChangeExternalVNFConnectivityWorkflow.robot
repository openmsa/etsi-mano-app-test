*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    environment/scaleVariables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}       ssl_verify=false 
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Library    Process
Suite Setup    Initialize System
Suite Teardown    Terminate All Processes    kill=true


*** Test Cases ***
Change external connectivity of VNF Workflow
    [Documentation]    Test ID: 7.3.1.20.1
    ...    Test title: Change external connectivity of VNF Workflow
    ...    Test objective: The objective is to change the external connectivity of a VNF instance.
    ...    Pre-conditions: VNF instance in INSTANTIATED state 
    ...    Reference: Clause 5.4.11 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM. The VNFD supports the external connectivity change
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and external connectivity of the VNF is changed
    Send Change Ext Connectivity Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Change Ext Connectivity    STARTING
    Check Operation Notification For Change Ext Connectivity    PROCESSING
    Check Operation Notification For Change Ext Connectivity    COMPLETED
    Check Postcondition VNF Change Ext Connectivity

*** Keywords ***
Initialize System
    Create Sessions
    ${body}=    Get File    jsons/changeExtVnfConnectivityRequest.json
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
    