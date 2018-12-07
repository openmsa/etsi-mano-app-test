*** Settings ***
Resource          variables.txt
Library           REST    http://${VNFM_HOST}:${VNFM_PORT}    spec=SOL003-VNFLifecycleManagement-API.yaml
Library           OperatingSystem
Library           BuiltIn
Library           JSONLibrary

*** Variables ***
${GRANT_POLLING_TOT}    2
${GRANT_POLLING_INTERVAL}    5s
${SCALE_POLLING_TOT}    10
${SCALE_POLLING_INTERVAL}    15s

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
    ${headers}=    Send VNFScaleOut request
    Check Response Status    202    ${headers}
    ${vnfLcmOpOccId}=    Get VnfLcmOpOccId    ${headers}
    Check Operation Status Transition    ${vnfLcmOpOccId}    STARTING    PROCESSING    ${GRANT_POLLING_TOT}    ${GRANT_POLLING_INTERVAL}
    Check Operation Status Transition    ${vnfLcmOpOccId}    PROCESSING    COMPLETED    ${SCALE_POLLING_TOT}    ${SCALE_POLLING_INTERVAL}

*** Keywords ***
Check Response Status
    [Arguments]    ${expected_status}    ${headers}
    ${status}=    Get Value From Json    ${headers}    $..status
    Should Be Equal    ${expected_status}    ${status}

Send VNFscaleOut Request
    Log    Trying to scale a vnf Instance
    Set Headers    {"Accept":"${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/scaleVnfOutRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    ${headers}=    Output    response headers
    ${json}=    evaluate    json.loads('''${headers}''')    json
    [Return]    ${json}

Get VnfLcmOpOccId
    [Arguments]    ${headers}
    ${vnfLcmOpOccId}=    Get Value From Json    ${headers}    $..Location
    Should Not Be Empty    ${vnfLcmOpOccId}
    [Return]    ${vnfLcmOpOccId}

Check Operation Status Transition
    [Arguments]    ${vnfLcmOpOccId}    ${initial_status}    ${final_status}    ${POLLING_TOT}    ${POLLING_INTERVAL}
    ${INDEX}=    1
    : FOR    ${INDEX}    IN RANGE    1    ${POLLING_TOT}
    \    GET    ${apiRoot}/${apiName}/${apiVersion}/${vnfLcmOpOccId}
    \    Check Response Status    200    response code
    \    ${body}=    Output    response body
    \    ${json}=    evaluate    json.loads('''${body}''')    json
    \    ${operationState}=    Get Value From Json    ${json}    $..operationState
    \    Run Keyword If    Should Not Be Equal    ${initial_status}    ${operationState}    Exit For Loop
    \    Sleep    ${POLLING_INTERVAL}
    Should Be Equal    ${final_status}    ${operationState}
