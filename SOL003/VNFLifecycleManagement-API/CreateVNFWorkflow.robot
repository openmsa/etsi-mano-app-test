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
    [Documentation]    Test ID: 7.3.1.22
    ...    Test title: Create VNF Instance workflow
    ...    Test objective: The objective is to test the workflow for the creation of a new VNF instance resource.
    ...    Pre-conditions: NFVO is subscribed to VNF Identifier Creation notifications 
    ...    Reference: Clause 5.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF instance resource has been created in "NOT_INSTANTIATED" state.
    Send VNF Instance Resource create Request
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location 
    Check Operation Notification For VNF Instance Creation
    Check Postcondition VNF Instance Created status is  NOT_INSTANTIATED

*** Keywords ***

Initialize System
    Create Sessions

Check Postcondition VNF Instance Created status is
    [Arguments]    ${status}
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    200
    Check VNF Status    ${response.body.instantiationState}  ${status}  
     
Check Operation Notification For VNF Instance Creation
    Check VNF Instance Operation Notification    VnfIdentifierCreationNotification   ${vnfInstanceId}
    