*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library     OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Resource    VnfLcmMntOperationKeywords.robot

*** Test Cases ***
POST Heal a vnfInstance
     [Documentation]    Test ID: 7.3.1.8.1
    ...    Test title: POST Heal a vnfInstance
    ...    Test objective: The objective is to test that POST method heal a VNF instance
    ...    Pre-conditions: the VNF instance resource is not in NOT-INSTANTIATED state
    ...    Reference: clause 5.4.9.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    POST Heal VNF
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id existence

POST Heal a vnfInstance Conflict (Not-Instantiated)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
     [Documentation]    Test ID: 7.3.1.8.2
    ...    Test title: POST Heal a vnfInstance Conflict (Not-Instantiated)
    ...    Test objective: The objective is to test that the operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: the VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference: clause 5.4.9.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    POST Heal VNF
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 


    
POST Heal a vnfInstance Not Found
    [Documentation]    Test ID: 7.3.1.8.3
    ...    Test title: POST Heal a vnfInstance Not Found
    ...    Test objective: The objective is to test that the operation cannot be executed because the VNF instance resource is not found. 
    ...    Pre-conditions: the VNF instance resource is not existing
    ...    Reference: clause 5.4.9.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    POST Heal VNF
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is    ProblemDetails 
    
   
GET Heal VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.8.4
    ...    Test title: GET Heal a vnfInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    GET Heal VNF  
    Check HTTP Response Status Code Is    405

PUT Heal VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.8.5
    ...    Test title: PUT Heal a vnfInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:
    PUT Heal VNF  
    Check HTTP Response Status Code Is    405

PATCH Heal VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.8.6
    ...    Test title: PATCH Heal a vnfInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:
    PATCH Heal VNF  
    Check HTTP Response Status Code Is    405
    
DELETE Heal VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.8.7
    ...    Test title: DELETE Heal a vnfInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.9.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:
    DELETE Heal VNF  
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Check resource not instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    String    response body instantiationState    NOT_INSTANTIATED

Check heal not supported
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    # how to check if heal is not supported? "flavourId" doesn't exist?

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    Integer    response status    202