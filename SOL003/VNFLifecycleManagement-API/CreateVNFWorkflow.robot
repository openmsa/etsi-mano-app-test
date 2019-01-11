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
    ...    Test title: Create a VNF instance procedure
    ...    Test objective: The objective is to test the procedure for the creation of a VNF instance resource.
    ...    Pre-conditions: 
    ...    Reference: section 5.3.1 - SOL003 v2.4.1; section
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    NFVO is not subscribed for
    ...    Post-Conditions: upon successful completion, the VNF instance resource has been created in "NOT_INSTANTIATED" state.
    Send VNF create Request
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location 
    Check Operation Notification For Create   VnfIdentifierCreationNotification
    Check Postcondition VNF    CREATE

*** Keywords ***

Initialize System
    Create Sessions

Check Postcondition VNF
    [Arguments]    ${operation}
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    200
    Check VNF Status    ${response.body.instantiationState}    NOT_INSTANTIATED
   
Check Operation Notification For Create
    [Arguments]    ${element}
    ${json}=	Get File	schemas/${element}.schema.json
    Configure Notification Handler    ${notification_ep}       
    