*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Scale a vnfInstance to level
    [Documentation]    Test ID: 6.3.5.5.1
    ...    Test title: POST Scale a vnfInstance to level
    ...    Test objective: The objective is to scale a VNF instance to a target level.
    ...    Pre-conditions: none
    ...    Reference: section 5.4.6.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:
    POST Scale vnfInstance to level     
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

Scale a vnfInstance to level Conflict (Not-Instantiated)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Test ID: 6.3.5.5.2
    ...    Test title: POST Scale a vnfInstance to level
    ...    Test objective: The objective is to verify that the operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference: section 5.4.6.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:
    POST Scale vnfInstance to level   
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 

    
Scale a vnfInstance Not Found
    [Documentation]    Test ID: 6.3.5.5.3
    ...    Test title: Scale a vnfInstance Not Found
    ...    Test objective: The objective is to verify that the operation cannot be executed , because the VNF instance resource can't be found.
    ...    Pre-conditions: VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference: section 5.4.6.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:
    POST Scale vnfInstance to level    
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 
   
    
GET Scale to level VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.5.4
    ...    Test title: GET Scale to level VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.6.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Scale vnfInstance to level
    Check HTTP Response Status Code Is    405

PUT Scale to level VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.5.5
    ...    Test title: GET Scale to level VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.6.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    PUT Scale vnfInstance to level
    Check HTTP Response Status Code Is    405

PATCH Scale to level VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.5.6
    ...    Test title: GET Scale to level VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.6.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH Scale vnfInstance to level
    Check HTTP Response Status Code Is    405
    
DELETE Scale to level VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.5.7
    ...    Test title: DELETE Scale to level VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.6.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE Scale vnfInstance to level
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

 Check scale to level not supported
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Missing    response body instantiatedVnfInfo scaleStatus

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    Integer    response status    202