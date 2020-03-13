*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt
Resource    VnfLcmMntOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Cancel operation task
    [Documentation]    Test ID: 7.3.1.16.1
    ...    Test title: POST Cancel operation task
    ...    Test objective: The POST method initiates cancelling an ongoing VNF lifecycle operation while it is being executed or rolled back, i.e. the "VNF LCM operation occurrence" is either in "PROCESSING" or "ROLLING_BACK" state.
    ...    Pre-conditions: the "VNF LCM operation occurrence" is either in "PROCESSING" or "ROLLING_BACK" state.
    ...    Reference: clause 5.4.17.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: VNF instance status equal to FAILED_TEMP     
    POST Cancel operation task
    Check HTTP Response Status Code Is    202
    Check operation resource state is FAILED_TEMP
    
POST Cancel operation task Conflict
    [Documentation]    Test ID: 7.3.1.16.2
    ...    Test title: POST Cancel operation task Conflict
    ...    Test objective: The POST method is NOT cancelling an ongoing VNF lifecycle operation due to the fact that the VNF instance resource is not in STARTING, PROCESSING or ROLLING_BACK state
    ...    Pre-conditions: operation is not in STARTING, PROCESSING or ROLLING_BACK state
    ...    Reference: clause 5.4.17.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Cancel operation task
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails

POST Cancel operation task Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
     [Documentation]    Test ID: 7.3.1.16.3
    ...    Test title: POST Cancel operation task Not Found
    ...    Test objective: The objective is to test that POST method cannot cancel a VNF lifecycle operation because the resource is not found
    ...    Pre-conditions: 
    ...    Reference: clause 5.4.17.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Cancel operation task
    Check HTTP Response Status Code Is    404
    
GET Cancel operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.16.4
    ...    Test title: GET Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.17.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET Cancel operation task
	Check HTTP Response Status Code Is    405

PUT Cancel operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.16.5
    ...    Test title: PUT Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.17.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT Cancel operation task
	Check HTTP Response Status Code Is    405

PATCH Cancel operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.16.6
    ...    Test title: PATCH Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.17.3.3 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH Cancel operation task
	Check HTTP Response Status Code Is    405
    
DELETE Cancel operation task - Method not implemented
    [Documentation]    Test ID: 7.3.1.16.7
    ...    Test title: DELETE Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.17.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE Cancel operation task
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
    
Check Fail not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    # how to check if Fail is not supported?

Check resource FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body operationState    FAILED_TEMP