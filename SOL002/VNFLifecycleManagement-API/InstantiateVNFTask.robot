*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    DependencyLibrary
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existence


*** Test Cases ***
POST Instantiate a vnfInstance
    [Documentation]    Test ID: 6.3.5.3.1
    ...    Test title: POST Instantiate a vnfInstance
    ...    Test objective: The objective is to instantiate a VNF instance
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.4.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST instantiate individual vnfInstance
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

POST Instantiate a vnfInstance Conflict
    [Documentation]    Test ID: 6.3.5.3.2
    ...    Test title: POST Instantiate a vnfInstance Conflict
    ...    Test objective: The objective is to verify that the instantiation of the vnf cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: VNF instance resource is in INSTANTIATED state
    ...    Reference: clause 5.4.4.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST instantiate individual vnfInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails 
    
GET Instantiate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.3.3
    ...    Test title: GET Instantiate VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.4.3.2  - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405
    
PUT Instantiate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.3.4
    ...    Test title: PUT Instantiate VNFInstance  - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.4.3.3  - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: vnf instance not modified
    PUT instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405

PATCH Instantiate VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.3.5
    ...    Test title: PATCH Instantiate VNFInstance  - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.4.3.4  - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: vnf instance not modified
    PATCH instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405
    
DELETE Instantiate VNFInstance - Method not implemented
     [Documentation]    Test ID: 6.3.5.3.6
    ...    Test title: DELETE Instantiate VNFInstance  - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions:  
    ...    Reference: clause 5.4.4.3.5  - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: vnf instance not deleted
    DELETE instantiate individual vnfInstance   
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existence
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