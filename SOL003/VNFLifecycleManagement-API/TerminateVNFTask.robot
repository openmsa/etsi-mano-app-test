*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Resource    VnfLcmMntOperationKeywords.robot
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
POST Terminate a vnfInstance
    [Documentation]    Test ID: 7.3.1.7.1
    ...    Test title: POST Terminate a vnfInstance
    ...    Test objective: The objective is to test that POST method terminate a VNF instance
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.8.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    POST Terminate VNF  
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

Terminate a vnfInstance Conflict (Not-Instantiated)
    # TODO: Need to set the pre-condition of the test. VNF instance shall be in INSTANTIATED state
    [Documentation]    Test ID: 7.3.1.7.2
    ...    Test title: POST Terminate a vnfInstance
    ...    Test objective: The objective is to test that the operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions:  VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference:  section 5.4.8.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: 
    [Setup]    Check resource not instantiated
    POST Terminate VNF  
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    ProblemDetails

       
GET Terminate VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.7.3
    ...    Test title:  GET Terminate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  none
    ...    Reference:  section 5.4.8.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Scale vnfInstance to level
    Check HTTP Response Status Code Is    405

PUT Terminate VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.7.4
    ...    Test title:  GET Terminate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  none
    ...    Reference:  section 5.4.8.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Scale vnfInstance to level
    Check HTTP Response Status Code Is    405

PATCH Terminate VNFInstance - Method not implemented
     [Documentation]    Test ID: 7.3.1.7.5
    ...    Test title:  GET Terminate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  none
    ...    Reference:  section 5.4.8.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Scale vnfInstance to level
    Check HTTP Response Status Code Is    405
    
DELETE Terminate VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.7.6
    ...    Test title:  GET Terminate VNFInstance - Method not implemented
    ...    Test objective: The objective is to verify that the method is not implemented
    ...    Pre-conditions:  none
    ...    Reference:  section 5.4.8.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
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
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    String    response body instantiationState    NOT_INSTANTIATED

Check change flavour not supported
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    # how to check if change floavour is not supported? "flavourId" doesn't exist?

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    Integer    response status    202