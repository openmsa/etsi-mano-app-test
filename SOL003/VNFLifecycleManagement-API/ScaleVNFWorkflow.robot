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
VNF Instance Scale Out
   [Documentation]    Test ID: 5.4.5.1
    ...    Test title: VNF Instance Scale Out worflow
    ...    Test objective: The objective is to test the workflow for the scaling out a VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.4.4.1). NFVO is subscribed to VNF LCM Operation Occurrence notifications (Test ID: 5.4.20.1)
    ...    Reference: section 5.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  NFVO is able to receive notifications from VNFM. Scale operation is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and VNF is scaled out
    Send VNF Scale Out Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Scale   STARTING
    Check Operation Notification For Scale    PROCESSING
    Check Operation Notification For Scale    COMPLETED
    Check Postcondition VNF    SCALE_OUT

#Create a new Grant - Sync - Scale REMOVED

*** Keywords ***

Initialize System
    Create Sessions
    ${scaleInfo}=    Get Vnf Scale Info    ${vnfInstanceId}
    
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE
    ${scaleInfo}=    Get Vnf Scale Info        ${vnfInstanceId}

Check Postcondition VNF
    [Arguments]    ${operation}
    Check resource instantiated
    ${newScaleInfo}=    Get Vnf Scale Info    ${vnfInstanceId}
    Compare ScaleInfos    ${operation}    ${scaleInfo}    ${newScaleInfo}  
    
Compare ScaleInfos
    [Arguments]    ${type}    ${old_scaleinfo}    ${new_scaleinfo}
    FOR    ${element}    IN    ${old_scaleinfo}
        ${old_level}=    Set Variable If    ${element.aspectId}==${aspectId}   ${element.scaleLevel}
        ${old_level_value}=    Convert To Integer    ${old_level}
    END
    FOR    ${element}    IN    ${new_scaleinfo}
        ${new_level}=    Set Variable If    ${element.aspectId}==${aspectId}   ${element.scaleLevel}
        ${new_level_value}=    Convert To Integer    ${new_level}
    END
    Run Keyword If    ${type}==SCALE_OUT    Should Be True    ${old_level_value}<${new_level_value}
    ...    ELSE    Should Be True    ${old_level_value}<${new_level_value}
   
Create a new Grant - Sync - Scale
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    SCALE
    
Check Operation Notification For Scale
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    