*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
POST Scale a vnfInstance
    [Documentation]    Test ID: 6.3.5.4.1
    ...    Test title: POST Scale a vnfInstance
    ...    Test objective: The objective is to scale a VNF instance
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.5.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST Scale vnfInstance  
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

POST Scale a vnfInstance Conflict (Not-Instantiated)
    [Documentation]    Test ID: 6.3.5.4.2
    ...    Test title: POST Scale a vnfInstance Conflict (Not-Instantiated)
    ...    Test objective: The objective is to verify that the operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions:  VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference: clause 5.4.5.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST Scale vnfInstance  
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 

    
POST Scale a vnfInstance Not Found
    [Documentation]    Test ID: 6.3.5.4.3
    ...    Test title: POST Scale a vnfInstance Not Found
    ...    Test objective: The objective is to verify that the operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.5.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST Scale vnfInstance  
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is    ProblemDetails 
   
GET Scale VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.4.4
    ...    Test title: GET Scale VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Scale vnfInstance
    Check HTTP Response Status Code Is    405

PUT Scale VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.4.5
    ...    Test title: PUT Scale VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.5.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PUT Scale vnfInstance
    Check HTTP Response Status Code Is    405

PATCH Scale VNFInstance - Method not implemented
     [Documentation]    Test ID: 6.3.5.4.6
    ...    Test title: PATCH Scale VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.5.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH Scale vnfInstance
    Check HTTP Response Status Code Is    405
    
DELETE Scale VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.4.7
    ...    Test title: DELETE Scale VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.5.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE Scale vnfInstance
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

Check scale not supported
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Missing    response body instantiatedVnfInfo scaleStatus

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfToLevelRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level    ${body}
    Integer    response status    202