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
Cancel a VNF LCM Operation - STARTING
    [Documentation]    Test ID: 7.3.1.19.1
    ...    Test title: Cancel a VNF LCM Operation - STARTING
    ...    Test objective: The objective is to test the workflow for Cancelling a VNF LCM Operation being in the STARTING state
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in STARTING state. NFVO is subscribed to VNF LCM Operation Occurrence notifications (Test ID 5.4.20.1)
    ...    Reference: clause 5.4.17 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in ROLLED_BACK state
    Send Cancel Operation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Cancel    ROLLED_BACK
    Check Postcondition VNF Cancel - STARTING

Cancel a VNF LCM Operation - PROCESSING - ROLLING_BACK
    [Documentation]    Test ID: 7.3.1.19.2
    ...    Test title: Cancel a VNF LCM Operation - PROCESSING - ROLLING_BACK
    ...    Test objective: The objective is to test the workflow for Cancelling a VNF LCM Operation being either in the PROCESSIONG or ROLLING_BACK state
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in PROCESSING or ROLLING_BACK state. NFVO is subscribed to VNF LCM Operation Occurrence notifications
    ...    Reference: clause 5.3.10 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state
    Send Cancel Operation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Cancel    FAILED_TEMP
    Check Postcondition VNF Cancel - PROCESSING - ROLLING_BACK


*** Keywords ***

Initialize System
    Create Sessions
    
Precondition Checks - STARTING
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    STARTING

Precondition Checks - PROCESSING - ROLLING_BACK
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    PROCESSING 

Check Postcondition VNF Cancel - STARTING
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    ROLLED_BACK

Check Postcondition VNF Cancel - PROCESSING - ROLLING_BACK
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP
 
Check Operation Notification For Cancel 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    