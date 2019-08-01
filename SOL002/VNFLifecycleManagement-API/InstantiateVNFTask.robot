*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance


*** Test Cases ***
Instantiate a vnfInstance
    [Documentation]    Test ID: 6.3.5.3.1
    ...    Test title: Post Instantiate Individual VNFInstance 
    ...    Test objective: The objective is to instantiate a VNF instance
    ...    Pre-conditions: none
    ...    Reference: section 5.4.4.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST instantiate individual vnfInstance
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

Instantiate a vnfInstance Conflict
    [Documentation]    Test ID: 6.3.5.3.2
    ...    Test title: Post Instantiate Individual VNFInstance 
    ...    Test objective: The objective is to verify that the instantiation of the vnf cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: VNF instance resource is in INSTANTIATED state
    ...    Reference: section 5.4.4.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST instantiate individual vnfInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 
    
GET Instantiate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.3.3
    ...    Test title: GET Instantiate Individual VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.4.3.2  - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405
    
PUT Instantiate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.3.4
    ...    Test title: PUT Instantiate Individual VNFInstance  - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.4.3.3  - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PUT instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405

PATCH Instantiate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.3.5
    ...    Test title: PATCH Instantiate Individual VNFInstance  - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.4.3.4  - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405
    
DELETE Instantiate VNFInstance - Method not implemented
     [Documentation]    Test ID: 6.3.5.3.6
    ...    Test title: DELETE Instantiate Individual VNFInstance  - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.4.3.5  - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Check resource instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    String    response body instantiationState    INSTANTIATED