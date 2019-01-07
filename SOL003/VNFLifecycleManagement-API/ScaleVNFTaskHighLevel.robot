*** Settings ***
Resource          environment/variables.txt
Library           REST    http://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library           OperatingSystem
Library           BuiltIn
Library           JSONLibrary

*** Variables ***
${GRANT_POLLING_TOT}    2
${GRANT_POLLING_INTERVAL}    5s
${SCALE_POLLING_TOT}    10
${SCALE_POLLING_INTERVAL}    15s
${headers} 
${vnfLcmOpOccId}
${status}   

*** Test Cases ***
Scale Out a vnfInstance
    [Documentation]    Test ID: 5.x.y.x
    ...    Test title: Scale out VNF operation
    ...    Test objective: The objective is to test a scale out of an existing VNF instance
    ...    Pre-conditions: VNF instance in INSTANTIATED state (Test ID: 5.a.b.c)
    ...    Reference: section 5.4.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: Scale operation is supported for the VNF (as capability in the VNFD)
    ...    NFVO is not subscribed for
    ...    Post-Conditions: VNF instance still in INSTANTIATED state and VNF was scaled
    [Setup]     Check resource existance
    Send VNFScaleOut request
    Check Response Status    202    ${status}
    Get VnfLcmOpOccId
    Check Operation Status Transition from starting to processing
    Check Operation Status Transition from processing to completed

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Check Response Status
    [Arguments]    ${expected_status}    ${status}
    Should Be Equal    ${expected_status}    ${status}

Send VNFscaleOut Request
    Log    Trying to scale a vnf Instance
    Set Headers    {"Accept":"${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/scaleVnfOutRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    ${headers}=    Output    response headers
    ${headers}=    evaluate    json.loads('''${headers}''')    json
    ${status}=    Output    response status

Get VnfLcmOpOccId
    ${vnfLcmOpOccId}=    Get Value From Json    ${headers}    $..Location
    Should Not Be Empty    ${vnfLcmOpOccId}

Check Operation Status Transition from starting to processing
    Check Operation Status Transition    ${vnfLcmOpOccId}    STARTING    PROCESSING    ${GRANT_POLLING_TOT}    ${GRANT_POLLING_INTERVAL}

Check Operation Status Transition from processing to completed
    Check Operation Status Transition    ${vnfLcmOpOccId}    PROCESSING    COMPLETED    ${SCALE_POLLING_TOT}    ${SCALE_POLLING_INTERVAL}
    
Check Operation Status Transition
    [Arguments]    ${vnfLcmOpOccId}    ${initial_status}    ${final_status}    ${POLLING_TOT}    ${POLLING_INTERVAL}
    :FOR    ${INDEX}    IN RANGE    1    ${POLLING_TOT}
    \    GET    ${apiRoot}/${apiName}/${apiVersion}/${vnfLcmOpOccId}
    \    ${status}=    Output    response status
    \    Check Response Status    200    ${status}
    \    ${body}=    Output    response body
    \    ${json}=    evaluate    json.loads('''${body}''')    json
    \    ${operationState}=    Get Value From Json    ${json}    $..operationState
    \    Run Keyword If    Should Not Be Equal    ${initial_status}    ${operationState}    Exit For Loop
    \    Sleep    ${POLLING_INTERVAL}
    Should Be Equal    ${final_status}    ${operationState}
