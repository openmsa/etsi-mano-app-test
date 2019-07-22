*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Fail operation task  
    [Documentation]    Test ID: 6.3.5.15.1
    ...    Test title: Post Fail operation task
    ...    Test objective: The objective is to test that POST method mark as "finally failed" a VNF lifecycle operation if that operation has experienced a temporary failure
    ...    Pre-conditions: the related "VNF LCM operation occurrence" resource is in "FAILED_TEMP" state.
    ...    Reference:  section 5.4.16.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Fail operation
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

Post Fail operation task Conflict (Not-FAILED_TEMP)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Test ID: 6.3.5.15.2
    ...    Test title: Post Fail operation task
    ...    Test objective: The objective is to test that POST method cannot mark as "finally failed" a VNF lifecycle operation if that operation has experienced a temporary failure
    ...    Pre-conditions: the related "VNF LCM operation occurrence" resource is not in "FAILED_TEMP" state.
    ...    Reference:  section 5.4.16.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none     
    Post Fail operation
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails

Post Fail operation task Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
    [Documentation]    Test ID: 6.3.5.15.3
    ...    Test title: Post Fail operation task
    ...    Test objective: The objective is to test that POST method cannot mark as "finally failed" a VNF lifecycle operation because the operation is not supported
    ...    Pre-conditions: 
    ...    Reference:  section 5.4.16.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none  
    Post Fail operation
    Check HTTP Response Status Code Is    404

GET Fail operation task - Method not implemented
     [Documentation]    Test ID: 6.3.5.15.4
    ...    Test title: GET Fail operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.16.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Get Fail operation
    Check HTTP Response Status Code Is    405

PUT Fail operation task - Method not implemented
     [Documentation]    Test ID: 6.3.5.15.5
    ...    Test title: PUT Fail operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.16.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Put Fail operation
    Check HTTP Response Status Code Is    405

PATCH Fail operation task - Method not implemented
     [Documentation]    Test ID: 6.3.5.15.6
    ...    Test title: GET Fail operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.16.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Patch Fail operation
    Check HTTP Response Status Code Is    405
    
DELETE Fail operation task - Method not implemented
     [Documentation]    Test ID: 6.3.5.15.7
    ...    Test title: DELETE Fail operation task- Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.16.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    Delete Fail operation
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    Integer    response status    200

Launch another error handling action
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry
    Integer    response status    202
    
Check Fail not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    # how to check if Fail is not supported?

Check resource FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP