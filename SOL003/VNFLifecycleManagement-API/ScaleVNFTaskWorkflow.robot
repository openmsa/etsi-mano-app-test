*** Settings ***
Resource          environment/variables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    REST    http://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    JSONLibrary
   

*** Test Cases ***
Precondition Checks
    Check resource instantiated
    ${LccnSubscriptions}=    Check subscriptions about one VNFInstance and operation type    ${vnfInstanceId}    VnfLcmOperationOccurrenceNotification    operationType=SCALE
    Set Suite Variable    ${LccnSubscriptions}
    ${scaleInfo}=    Get Vnf Scale Info        ${vnfInstanceId}

POST Scale Out a vnfInstance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Scale out VNF operation
    ...    Test objective: The objective is to test a scale out of an existing VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: Scale operation is supported for the VNF (as capability in the VNFD)
    ...    NFVO is not subscribed for
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and VNF was scaled
    
    ${headers}    ${status}=    Send VNFScaleOut request
    Check Response Status    202    ${status}
    ${vnfLcmOpOccId}=    Get VnfLcmOpOccId   ${headers}
    
Wait for Notification - STARTING
    Deliver a notification - Operation Occurence
    ${VnfLcmOccInstance}=    Get VnfLcmOccInstance    ${vnfLcmOpOccId}
    Check operationState    STARTING    ${VnfLcmOccInstance}

Granting exchange
    Create a new Grant - Synchronous mode

Wait for Notification - PROCESSING
    Deliver a notification - Operation Occurence
    ${VnfLcmOccInstance}=    Get VnfLcmOccInstance    ${vnfLcmOpOccId}
    Check operationState    PROCESSING    ${VnfLcmOccInstance}

Wait for Notification - COMPLETED
    Deliver a notification - Operation Occurence
    ${VnfLcmOccInstance}=    Get VnfLcmOccInstance    ${vnfLcmOpOccId}
    Check operationState    COMPLETED    ${VnfLcmOccInstance}

Postcondition Checks
    Check resource instantiated
    ${newScaleInfo}=    Get Vnf Scale Info    ${vnfInstanceId}
    #TODO: How to check if VNF is scaled?
    

    