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
Retry VNF LCM Operation - Successful
    [Documentation]    Test ID: 5.x.x.x
    ...    Test title: Retry VNF LCM Operation - Successful
    ...    Test objective: The objective is to test the workflow for a Retry VNF LCM Operation and the operation is successful
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state. NFVO is subscribed to VNF LCM Operation Occurrence notifications (Test ID: 5.4.20.1)
    ...    Reference: section 5.3.10 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in COMPLETED state
    Send Retry Operation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Retry    PROCESSING
    Check Operation Notification For Retry    COMPLETED
    Check Postcondition VNF Retry Successful

Retry VNF LCM Operation - Unsuccessful
    [Documentation]    Test ID: 5.x.x.x
    ...    Test title: Retry VNF LCM Operation - Unsuccessful
    ...    Test objective: The objective is to test the workflow for a Retry VNF LCM Operation and the operation is not successful
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state. NFVO is subscribed to VNF LCM Operation Occurrence notifications (Test ID: 5.4.20.1)
    ...    Reference: section 5.3.10 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state
    Send Retry Operation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Retry    PROCESSING
    Check Operation Notification For Retry    FAILED_TEMP
    Check Postcondition VNF Retry Unsuccessful

*** Keywords ***

Initialize System
    Create Sessions
    
Precondition Checks
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP

Check Postcondition VNF Retry Successful
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    COMPLETED

Check Postcondition VNF Retry Unsuccessful
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP
    
Check Operation Notification For Retry 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    