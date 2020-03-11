*** Setting ***
Suite Setup       Initialize System
Suite Teardown    Terminate All Processes    kill=true
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    VnfLcmMntOperationKeywords.robot
Resource    SubscriptionKeywords.robot
Library    OperatingSystem
Library    MockServerLibrary
Library    Process
Library    BuiltIn
Library    Collections
Library    String
Library    JSONSchemaLibrary    schemas/
Library    JSONLibrary
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}


*** Test Cases ***
VNF Instantiation
    [Documentation]    Test ID: 7.3.1.26
    ...    Test title: VNF Instantiation worflow
    ...    Test objective: The objective is to test the workflow for the instantiation of a VNF instance
    ...    Pre-conditions: VNF instance resources is already created. NFVO is subscribed to VNF LCM Operation Occurrence notifications 
    ...    Reference: clause 5.4.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  NFVO is able to receive notifications from VNFM
    ...    Post-Conditions: VNF instance in INSTANTIATED state
    Send VNF Instantiation Request
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check Operation Occurrence Id existence
    Check Operation Notification For Instantiation  STARTING
    Check Operation Notification For Instantiation  PROCESSING
    Check Operation Notification For Instantiation  COMPLETED
    Check Postcondition VNF Status  INSTANTIATED
    
*** Keywords ***
Send VNF Instantiation Request
    Log    Instantiate a VNF Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/instantiateVnfRequest.json
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate    ${body}
    
Check Operation Notification For Instantiation
    [Arguments]    ${status}
    Check Operation Notification    VnfLcmOperationOccurrenceNotification   ${status}

Initialize System
    Create Sessions

Check Postcondition VNF Status
    [Arguments]    ${status}
    Log    Retrieve VNF Instance
    Check VNF Instance    ${vnfInstanceId}
    Should Not Be Empty    ${response}
    Check HTTP Response Status Code Is    200
    Should Be Equal    ${response.body.id}    ${vnfInstanceId}    
    Check HTTP Response Header Contains    Content-Type
    Check HTTP Response Body Json Schema Is    vnfInstance.schema.json
    Check VNF Status    ${response.body.instantiationState}    ${status}