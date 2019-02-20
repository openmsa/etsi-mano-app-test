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
Create VNF Instance Resource
    [Documentation]    Test ID: 5.3.1.1
    ...    Test title: Create VNF Instance workflow
    ...    Test objective: The objective is to test the workflow for the creation of a new VNF instance resource.
    ...    Pre-conditions: NFVO is subscribed to VNF Identifier Creation notifications (Test ID: 5.4.20.2)
    ...    Reference: section 5.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF instance resource has been created in "NOT_INSTANTIATED" state.
    Send VNF Instance Resource create Request
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location 
    Check Operation Notification For VNF Instance Creation
    Check Postcondition VNF Instance Created  NOT_INSTANTIATED

*** Keywords ***

Initialize System
    Create Sessions

Check Postcondition VNF Instance Created
    [Arguments]    ${status}
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    200
    Check VNF Status    ${response.body.instantiationState}  ${status}  
     
Check Operation Notification For VNF Instance Creation
    Check VNF Instance Operation Notification    VnfIdentifierCreationNotification   ${vnfInstanceId}
    