*** Settings ***
Resource          environment/variables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    http://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
Suite Teardown    Terminate All Processes    kill=true

*** variables ***
${LccnSubscriptions}
${scaleInfo}
${element}
${aspectId}

*** Test Cases ***
Scale out a VnFInstance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Scale out VNF operation
    ...    Test objective: The objective is to test a scale out of an existing VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: Scale operation is supported for the VNF (as capability in the VNFD)
    ...    NFVO is not subscribed for
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and VNF was scaled
    Precondition Checks
    ${response}    ${aspectId}=    Send VNFScaleOut request    ${vnfInstanceId}
    Check Response Status    202    ${response.status}
    Check HTTP Response Header Contains    Location    ${response.headers}
    ${vnfLcmOpOccId}=    Get VnfLcmOpOccId   ${response.headers}
    Check Operation Notification    STARTING    ${notification_ep}
    Create a new Grant - Synchronous mode
    Check Operation Notification    PROCESSING    ${notification_ep}
    Check Operation Notification    COMPLETED    ${notification_ep}
    Postcondition Checks

*** Keywords ***

Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE
    ${scaleInfo}=    Get Vnf Scale Info        ${vnfInstanceId}

Postcondition Checks
    Check resource instantiated
    ${newScaleInfo}=    Get Vnf Scale Info    ${vnfInstanceId}
    Compare ScaleInfos    SCALE_OUT    ${scaleInfo}    ${newScaleInfo}  
    
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
   
    
    