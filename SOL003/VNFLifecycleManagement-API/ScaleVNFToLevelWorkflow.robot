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
VNF Instance Scale To Level
   [Documentation]    Test ID: 7.3.1.31
    ...    Test title: VNF Instance Scale To Level workflow
    ...    Test objective: The objective is to test the workflow for the scale to level of a VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state . NFVO is subscribed to VNF LCM Operation Occurrence notifications 
    ...    Reference: Clause 5.4.6 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  NFVO is able to receive notifications from VNFM. Scale operation is supported for the VNF (as capability in the VNFD)
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and VNF is scaled to the new level
    Send VNF Scale To Level Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id existence
    Check Operation Notification For Scale   STARTING
    Check Operation Notification For Scale    PROCESSING
    Check Operation Notification For Scale    COMPLETED
    Check Postcondition VNF Scaled To New Level  

#Create a new Grant - Sync - Scale REMOVED

*** Keywords ***

Initialize System
    Create Sessions
    ${body}=    Get File    jsons/scaleVnfToLevelRequest.json
    ${scaleVnfToLevelRequest}=    evaluate    json.loads('''${body}''')    json
    ${instantiationLevelId}=    Get Value From Json    ${scaleVnfToLevelRequest}    $..instantiationLevelId    #How to use this info to get the instantiation scale level?
    ${scaleInfo}=    Get Value From Json    ${scaleVnfToLevelRequest}    $..scaleInfo

Check Postcondition VNF Scaled To New Level
    Check resource instantiated
    ${newScaleInfo}=    Get Vnf Scale Info    ${vnfInstanceId}
    Compare ScaleInfos    ${scaleInfo}    ${newScaleInfo}  
    
Compare ScaleInfos
    [Arguments]    ${old_scaleinfo}    ${new_scaleinfo}
    FOR    ${element}    IN    ${old_scaleinfo}
        ${old_level}=    Set Variable If    ${element.aspectId}==${aspectId}   ${element.scaleLevel}
        ${old_level_value}=    Convert To Integer    ${old_level}
    END
    FOR    ${element}    IN    ${new_scaleinfo}
        ${new_level}=    Set Variable If    ${element.aspectId}==${aspectId}   ${element.scaleLevel}
        ${new_level_value}=    Convert To Integer    ${new_level}
    END
    Should be true    ${old_level_value}==${new_level_value}
    
   
Create a new Grant - Sync - ScaleToLevel
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    SCALE_TO_LEVEL
    
Check Operation Notification For Scale
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    