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
Fail a VNF LCM Operation Workflow
    [Documentation]    Test ID: 7.3.1.24
    ...    Test title: Fail a VNF LCM Operation Workflow
    ...    Test objective: The objective is to test the workflow for a Fail VNF LCM Operation
    ...    Pre-conditions: The VNF lifecycle management operation occurrence is in FAILED_TEMP state. NFVO is subscribed to VNF LCM Operation Occurrence notifications 
    ...    Reference: clause 5.4.16 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF lifecycle management operation occurrence is in FAILED state
    Send Fail Operation Request
    Check Operation Notification For Fail    FAILED
    Check HTTP Response Status Code Is    200   #the order of notification and the response code is not defined. How to implement this?
    Check Postcondition VNF Fail 


*** Keywords ***
Initialize System
    Create Sessions
    
Precondition Checks
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP

Check Postcondition VNF Fail
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED
 
Check Operation Notification For Fail 
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    
    