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
Scale out a VNF Instance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Scale out VNF operation
    ...    Test objective: The objective is to test a scale out of an existing VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: Scale operation is supported for the VNF (as capability in the VNFD)
    ...    NFVO is not subscribed for
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and VNF was scaled
    Send VNF Scale To Level Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location 
    Check Operation Occurrence Id
    Check Operation Notification For Scale   STARTING
    Create a new Grant - Sync - Scale
    Check Operation Notification For Scale    PROCESSING
    Check Operation Notification For Scale    COMPLETED
    Check Postcondition VNF    

*** Keywords ***

Initialize System
    Create Sessions
    ${body}=    Get File    json/scaleVnfToLevelRequest.json
    ${scaleVnfToLevelRequest}=    evaluate    json.loads('''${body}''')    json
    ${instantiationLevelId}=    Get Value From Json    ${scaleVnfToLevelRequest}    $..instantiationLevelId    #How to use this info to get the instantiation scale level?
    ${scaleInfo}=    Get Value From Json    ${scaleVnfToLevelRequest}    $..scaleInfo

Check Postcondition VNF
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
    
   
Create a new Grant - Sync - Scale
    Create a new Grant - Synchronous mode        ${vnfInstanceId}    ${vnfLcmOpOccId}    SCALE
    
Check Operation Notification For Scale
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}
    