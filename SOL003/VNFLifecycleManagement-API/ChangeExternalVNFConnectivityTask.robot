*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Resource    VnfLcmMntOperationKeywords.robot
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Change external VNF connectivity 
    [Documentation]    Test ID: 7.3.1.10.1
    ...    Test title: POST Change external VNF connectivity
    ...    Test objective: The objective is to test that POST method trigger a change in VNF external connectivity. Supported types of changes that this operation are: 1. Disconnect the external CPs that are connected to a particular external VL, and connect them to a different external VL. 2. Change the connectivity parameters of the existing external CPs, including changing addresses.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.11.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: in response header Location shall not be null         
    POST Change External VNF Connectivity
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id
    
GET Change external VNF connectivity - Method not implemented
    [Documentation]    Test ID: 7.3.1.10.2
    ...    Test title: GET Change external VNF connectivity - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.11.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET Change External VNF Connectivity
    Check HTTP Response Status Code Is    405

PUT Change external VNF connectivity - Method not implemented
    [Documentation]    Test ID: 7.3.1.10.3
    ...    Test title: PUT Change external VNF connectivity - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.11.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT Change External VNF Connectivity
    Check HTTP Response Status Code Is    405

PATCH Change external VNF connectivity - Method not implemented
    [Documentation]    Test ID: 7.3.1.10.4
    ...    Test title: PATCH Change external VNF connectivity - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.11.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH Change External VNF Connectivity
    Check HTTP Response Status Code Is    405
    
DELETE Change external VNF connectivity - Method not implemented
    [Documentation]    Test ID: 7.3.1.10.5
    ...    Test title: DELETE Change external VNF connectivity - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.11.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE Change External VNF Connectivity
    Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 
    Integer    response status    200

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
    Integer    response status    202