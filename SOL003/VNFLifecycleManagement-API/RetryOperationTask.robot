*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Resource    VnfLcmMntOperationKeywords.robot

Documentation    This task resource represents the "Retry operation" operation. The client can use this resource to initiate retrying a VNF lifecycle operation.
Suite Setup    Check resource existance

*** Test Cases ***
Post Retry operation task  
    [Documentation]    Test ID: 7.3.1.13.1
    ...    Test title: Post Retry operation task
    ...    Test objective: The objective is to test that POST method The POST method initiates retrying a VNF lifecycle operation if that operation has experienced a temporary failure
    ...    Pre-conditions: the related "VNF LCM operation occurrence" resource is in "FAILED_TEMP" state.
    ...    Reference:  section 5.4.14.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Depends on test    Check resource FAILED_TEMP
    Post Retry operation
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

Post Retry operation task Conflict (Not-FAILED_TEMP)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Test ID: 7.3.1.13.2
    ...    Test title: Post Retry operation task
    ...    Test objective: The objective is to test that the retry operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. (i.e. the VNF instance resource is not in FAILED_TEMP state)
    ...    Pre-conditions: the related "VNF LCM operation occurrence" resource is not in "FAILED_TEMP" state.
    ...    Reference:  section 5.4.14.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Depends on test failure  Check resource FAILED_TEMP
    Post Retry operation
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails


Post Retry operation task Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
    [Documentation]    Test ID: 7.3.1.13.3
    ...    Test title: Post Retry operation task
    ...    Test objective: The objective is to test that the retry operation cannot be executed because the operation is not supported
    ...    Pre-conditions: 
    ...    Reference:  section 5.4.14.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    [Setup]    Check retry not supported
    Post Retry operation
    Check HTTP Response Status Code Is    404

GET Retry operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.13.4
    ...    Test title: GET Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.9.14.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    Get Retry operation
    Check HTTP Response Status Code Is    405

PUT Retry operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.13.5
    ...    Test title: PUT Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.9.14.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    Put Retry operation
    Check HTTP Response Status Code Is    405

PATCH Retry operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.13.6
    ...    Test title: PATCH Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.9.14.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    Patch Retry operation
    Check HTTP Response Status Code Is    405
    
DELETE Retry operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.13.7
    ...    Test title: DELETE Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.9.14.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    Delete Retry operation
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Integer    response status    200

Launch another error handling action
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/rollback
    Integer    response status    202
    
Check retry not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    # how to check if retry is not supported?

Check resource FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP