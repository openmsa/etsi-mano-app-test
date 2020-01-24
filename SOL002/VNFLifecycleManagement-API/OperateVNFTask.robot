*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library     OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
POST Operate a vnfInstance
    [Documentation]    Test ID: 6.3.5.9.1
    ...    Test title: POST Operate a vnfInstance
    ...    Test objective: The objective is to test that POST method operate a VNF instance
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.10.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: 
    POST Operate VNF
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

POST Operate a vnfInstance Conflict (Not-Instantiated)
    [Documentation]    Test ID: 6.3.5.9.2
    ...    Test title: POST Operate a vnfInstance Conflict (Not-Instantiated)
    ...    Test objective: The objective is to test that the operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: the VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference: clause 5.4.10.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions:
    POST Operate VNF
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 

    
POST Operate a vnfInstance Not Found
    [Documentation]    Test ID: 6.3.5.9.3
    ...    Test title: POST Operate a vnfInstance Not Found
    ...    Test objective: The objective is to test that the operation cannot be executed currently, because the resource is not existing
    ...    Pre-conditions: the VNF instance resource is in  not existing
    ...    Reference: clause 5.4.10.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions:
    POST Operate VNF
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
   
GET Operate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.9.4
    ...    Test title: GET Operate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.10.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions:
    GET Operate VNF
    Check HTTP Response Status Code Is    405

PUT Operate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.9.5
    ...    Test title: PUT Operate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.10.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions:
    PUT Operate VNF
    Check HTTP Response Status Code Is    405

PATCH Operate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.9.6
    ...    Test title: PATCH Operate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.10.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions:
    PATCH Operate VNF
    Check HTTP Response Status Code Is    405
    
DELETE Operate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.9.7
    ...    Test title: DELETE Operate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.10.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions:
    DELETE Operate VNF
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Check resource not instantiated
    [Arguments]    ${instanceId}
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${instanceId} 
    String    response body instantiationState    NOT_INSTANTIATED

Check operate not supported
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    # how to check if operate is not supported? "flavourId" doesn't exist?

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    Integer    response status    202