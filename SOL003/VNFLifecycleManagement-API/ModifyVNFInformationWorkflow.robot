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
Modify info of a VNF Instance
    [Documentation]    Test ID: 7.3.1.27
    ...    Test title: Update information about a VNF instance
    ...    Test objective: The objective is to update information about a VNF instance.
    ...    Pre-conditions: VNF instance is created 
    ...    Reference: Clause 5.3.6 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM. Update information of a VNF instance is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance info is updated
    Send Info Modification Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Modify Info    start   #need more info about the notification content
    Check Operation Notification For Modify Info    result  #need more info about the notification content, how the result is presented
    Check Postcondition VNF Modify Info

*** Keywords ***

Initialize System
    Create Sessions
    ${body}=    Get File    jsons/patchBodyRequest.json
    ${patchBodyRequest}=    evaluate    json.loads('''${body}''')    json    
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE

Check Postcondition VNF Modify Info
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    200
    #do we need to compare the modified info in the updated VNF instance with the values in the request?
    
Create a new Grant - Sync - OPERATE
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    OPERATE
    
Check Operation Notification For Modify Info 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    