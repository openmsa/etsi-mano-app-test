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
    ...    Test objective: The objective is to test that POST method The POST method initiates retrying a VNF lifecycle operation if the operation is in FAILED_TEMP state
    ...    Pre-conditions: the "VNF LCM operation occurrence" resource is in "FAILED_TEMP" state.
    ...    Reference: clause 5.4.14.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Retry operation
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id existence

Post Retry operation task Conflict (Not-FAILED_TEMP)
    [Documentation]    Test ID: 7.3.1.13.2
    ...    Test title: Post Retry operation task Conflict (Not-FAILED_TEMP)
    ...    Test objective: The objective is to test that the retry operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. (i.e. the VNF instance resource is not in FAILED_TEMP state)
    ...    Pre-conditions: the "VNF LCM operation occurrence" resource is not in "FAILED_TEMP" state.
    ...    Reference: clause 5.4.14.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Retry operation
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails


Post Retry operation task Not Found
    [Documentation]    Test ID: 7.3.1.13.3
    ...    Test title: Post Retry operation task Not Found
    ...    Test objective: The objective is to test that the retry operation cannot be executed because the operation is not supported
    ...    Pre-conditions: 
    ...    Reference: clause 5.4.14.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Retry operation
    Check HTTP Response Status Code Is    404

GET Retry operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.13.4
    ...    Test title: GET Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.14.3.2 - SOL003 v2.4.1
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
    ...    Reference: clause 5.4.14.3.3 - SOL003 v2.4.1
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
    ...    Reference: clause 5.4.14.3.4 - SOL003 v2.4.1
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
    ...    Reference: clause 5.4.14.3.5 - SOL003 v2.4.1
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

