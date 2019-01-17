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
Create a VNF Instance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Delete a VNF instance procedure
    ...    Test objective: The objective is to test the procedure for the deletion of a VNF instance resource.
    ...    Pre-conditions: The resource representing the VNF instance to be deleted needs to be in NOT_INSTANTIATED state
    ...    Reference: section 5.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The resource representing the VNF instance has been removed from the list of VNF instance resources
    Send VNF delete Request
    Check HTTP Response Status Code Is    204 
    Check Operation Notification For Create   VnfIdentifierDeletionNotification
    Check Postcondition VNF    DELETE

*** Keywords ***

Initialize System
    Create Sessions

Check Postcondition VNF
    [Arguments]    ${operation}
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    404
   
Check Operation Notification For Create
    [Arguments]    ${element}
    ${json}=	Get File	schemas/${element}.schema.json
    Configure Notification Handler    ${notification_ep}       
    