*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    environment/scaleVariables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}      ssl_verify=false  
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Library    Process
Suite Setup    Initialize System
Suite Teardown    Terminate All Processes    kill=true


*** Test Cases ***
Delete VNF Instance Resource
    [Documentation]    Test ID: 7.3.1.23.1
    ...    Test title: Delete VNF Instance workflow
    ...    Test objective: The objective is to test the workflow for the deleteion of an existing VNF instance resource
    ...    Pre-conditions: The VNF Instance resource is in NOT_INSTANTIATED state. NFVO is subscribed to VNF Identifier Creation notifications 
    ...    Reference: Clause 5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: The VNF instance resource is deleted on the VNFM.
    Send VNF Instance Resource delete Request
    Check HTTP Response Status Code Is    204 
    Check Operation Notification For VNF Instance Deletion 
    Check Postcondition VNF Instance Deleted

*** Keywords ***
Initialize System
    Create Sessions

Check Postcondition VNF Instance Deleted
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    404

Check Operation Notification For VNF Instance Deletion
    Check VNF Instance Operation Notification    VnfIdentifierDeletionNotification   ${vnfInstanceId}