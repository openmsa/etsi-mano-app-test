*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This task resource represents the "Retry operation" operation. The client can use this resource to initiate retrying a VNF lifecycle operation.
Suite Setup    Check resource existence

*** Test Cases ***
POST Retry operation task  
    [Documentation]    Test ID: 6.3.5.13.1
    ...    Test title: POST Retry operation task
    ...    Test objective: The objective is to test that POST method The POST method initiates retrying a VNF lifecycle operation if that operation has experienced a temporary failure
    ...    Pre-conditions: the "VNF LCM operation occurrence" resource is in "FAILED_TEMP" state.
    ...    Reference: clause 5.4.14.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Retry operation
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

POST Retry operation task Conflict (Not-FAILED_TEMP)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Test ID: 6.3.5.13.2
    ...    Test title: POST Retry operation task Conflict (Not-FAILED_TEMP)
    ...    Test objective: The objective is to test that the retry operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. (i.e. the VNF instance resource is not in FAILED_TEMP state)
    ...    Pre-conditions: the "VNF LCM operation occurrence" resource is not in "FAILED_TEMP" state.
    ...    Reference: clause 5.4.14.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Retry operation
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails


POST Retry operation task Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
    [Documentation]    Test ID: 6.3.5.13.3
    ...    Test title: POST Retry operation task Not Found
    ...    Test objective: The objective is to test that the retry operation cannot be executed because the operation is not supported
    ...    Pre-conditions: 
    ...    Reference: clause 5.4.14.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Retry operation
    Check HTTP Response Status Code Is    404

GET Retry operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.13.4
    ...    Test title: GET Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.14.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Get Retry operation
    Check HTTP Response Status Code Is    405

PUT Retry operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.13.5
    ...    Test title: PUT Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.14.3 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Put Retry operation
    Check HTTP Response Status Code Is    405

PATCH Retry operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.13.6
    ...    Test title: PATCH Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.14.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Patch Retry operation
    Check HTTP Response Status Code Is    405
    
DELETE Retry operation task - Method not implemented
    [Documentation]    Test ID: 6.3.5.13.7
    ...    Test title: DELETE Retry operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.14.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Delete Retry operation
    Check HTTP Response Status Code Is    405
*** Keywords ***
Check resource existence
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