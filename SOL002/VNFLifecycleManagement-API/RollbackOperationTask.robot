*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This task resource represents the "Rollback operation" operation. The client can use this resource to initiate rolling back a VNF lifecycle operation
Suite Setup    Check resource existence

*** Test Cases ***
POST Rollback operation task  
    [Documentation]    Test ID: 6.3.5.14.1
    ...    Test title: POST Rollback operation task
    ...    Test objective: The objective is to test that POST method The POST method initiates rollback a VNF lifecycle operation if that operation has experienced a temporary failure
    ...    Pre-conditions: the "VNF LCM operation occurrence" resource is in "FAILED_TEMP" state.
    ...    Reference: clause 5.4.15.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Rollback operation
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

POST Rollback operation task Conflict (Not-FAILED_TEMP)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Test ID: 6.3.5.14.2
    ...    Test title: POST Rollback operation task Conflict (Not-FAILED_TEMP)
    ...    Test objective: The objective is to test that POST method The POST method initiates rollback a VNF lifecycle operation if that operation has experienced a temporary failure
    ...    Pre-conditions: the "VNF LCM operation occurrence" resource is not in "FAILED_TEMP" state.
    ...    Reference: clause 5.4.15.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Rollback operation
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails


POST Rollback operation task Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
    [Documentation]    Test ID: 6.3.5.14.3
    ...    Test title: POST Rollback operation task Not Found
    ...    Test objective: The objective is to test that the retry operation cannot be executed because the operation is not supported
    ...    Pre-conditions: 
    ...    Reference: clause 5.4.15.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Rollback operation
    Check HTTP Response Status Code Is    404

GET Rollback operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.14.4
    ...    Test title: GET Rollback operation task - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.15.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Get Rollback operation
    Check HTTP Response Status Code Is    405
    
PUT Rollback operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.14.5
    ...    Test title: PUT Rollback operation task - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.15.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Put Rollback operation
    Check HTTP Response Status Code Is    405

PATCH Rollback operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.14.6
    ...    Test title: PATCH Rollback operation task - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.15.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Patch Rollback operation
    Check HTTP Response Status Code Is    405
    
DELETE Rollback operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.14.7
    ...    Test title: DELETE Rollback operation task - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.15.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Delete Rollback operation
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existence
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Integer    response status    200

Launch another error handling action
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry
    Integer    response status    202
    
Check Rollback not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    # how to check if Rollback is not supported?
    
Check resource FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP