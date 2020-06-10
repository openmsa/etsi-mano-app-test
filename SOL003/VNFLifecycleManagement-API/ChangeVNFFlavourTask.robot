*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Resource    VnfLcmMntOperationKeywords.robot
Library     OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Change deployment flavour of a vnfInstance
    [Documentation]    Test ID: 7.3.1.6.1
    ...    Test title: POST Change deployment flavour of a vnfInstance
    ...    Test objective: The objective is to test that POST method trigger a change in VNF deployment flavour
    ...    Pre-conditions: VNF instance resource is not in NOT-INSTANTIATED state
    ...    Reference: Clause 5.4.7.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: in response header Location shall not be null  
    POST Change VNF deployment flavour   
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id existence

POST Change deployment flavour of a vnfInstance Conflict (Not-Instantiated)
    [Documentation]    Test ID: 7.3.1.6.2
    ...    Test title: POST Change deployment flavour of a vnfInstance Conflict (Not-Instantiated)
    ...    Test objective: The objective is to test that POST method cannot trigger a change in VNF deployment flavour because of a conflict with the state of the VNF instance resource. (VNF instance resource is not in NOT-INSTANTIATED state)
    ...    Pre-conditions: VNF instance resource is in NOT-INSTANTIATED state
    ...    Reference: Clause 5.4.7.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none  
    POST Change VNF deployment flavour   
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails

  
POST Change deployment flavour of a vnfInstance Not Found
    # TODO: Need to create a vnfInstance which's instantiatedVnfInfo.scaleStatus is absent
    [Documentation]    Test ID: 7.3.1.6.3
    ...    Test title: POST Change deployment flavour of a vnfInstance Not Found
    ...    Test objective: The objective is to test that POST method cannot trigger a change in VNF deployment flavour because the VNF instance resource is not found. 
    ...    Pre-conditions: the VNF instance resource is not existing
    ...    Reference: Clause 5.4.7.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none  
    POST Change VNF deployment flavour  
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is    ProblemDetails
   
    
GET Change deployment flavour VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.6.4
    ...    Test title: GET Change deployment flavour VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.7.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET Change VNF deployment flavour   
    Check HTTP Response Status Code Is    405

PUT Change deployment flavour VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.6.5
    ...    Test title: PUT Change deployment flavour VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.7.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT Change VNF deployment flavour   
    Check HTTP Response Status Code Is    405

PATCH Change deployment flavour VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.6.6
    ...    Test title: PATCH Change deployment flavour VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.7.3.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH Change VNF deployment flavour   
    Check HTTP Response Status Code Is    405
    
DELETE Change deployment flavour VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.6.7
    ...    Test title: DELETE Change deployment flavour VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.7.3.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE Change VNF deployment flavour   
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existence
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

Check resource instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    String    response body instantiationState    INSTANTIATED    

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