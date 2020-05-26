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


*** Test Cases ***
Retry VNF LCM Operation - Successful
    [Documentation]    Test ID: 7.3.1.29.1
    ...    Test title: Retry VNF LCM Operation - Successful
    ...    Test objective: The objective is to test the workflow for a successful Retry VNF LCM Operation and the status notifications
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state. NFVO is subscribed to VNF LCM Operation Occurrence notifications 
    ...    Reference: clause 5.3.10 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in COMPLETED state
    Send Retry Operation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Retry    PROCESSING
    Check Operation Notification For Retry    COMPLETED
    Check Postcondition VNF Retry Successful

Retry VNF LCM Operation - Unsuccessful
    [Documentation]    Test ID: 7.3.1.29.2
    ...    Test title: Retry VNF LCM Operation - Unsuccessful
    ...    Test objective: The objective is to test the workflow for an unsuccesful Retry VNF LCM Operation and the status notifications
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state. NFVO is subscribed to VNF LCM Operation Occurrence notifications 
    ...    Reference: clause 5.3.10 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state
    Send Retry Operation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
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
    