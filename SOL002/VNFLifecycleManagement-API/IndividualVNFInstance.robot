*** Settings ***
# Suite setup     Expect spec    SOL002-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/


*** Variables ***
${original_etag}    1234

*** Test Cases ***
POST Individual VNFInstance - Method not implemented
    [Documentation]    Test ID: 6.3.5.2.1
    ...    Test title: POST Individual VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.3.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    POST individual vnfInstance
    Check HTTP Response Status Code Is    405
    
GET Information about an individual VNF Instance
    [Documentation]    Test ID: 6.3.5.2.2
    ...    Test title: GET Information about an individual VNF Instance
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET individual vnfInstance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstance
    
PUT Individual VNFInstance - Method not implemented 
     [Documentation]    Test ID: 6.3.5.2.3
    ...    Test title: PUT Individual VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.3.3.3 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance not modified
    PUT individual vnfInstance
    Check HTTP Response Status Code Is    405

PATCH Individual VNFInstance
    [Documentation]    Test ID: 6.3.5.2.4
    ...    Test title: PATCH Individual VNFInstance
    ...    Test objective: This method modifies an individual VNF instance resource
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance modified
    PATCH individual vnfInstance
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

PATCH Individual VNFInstance Precondition failed
    [Documentation]    Test ID: 6.3.5.2.5
    ...    Test title: PATCH Individual VNFInstance Precondition failed
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions:  A precondition given in an HTTP request header is not fulfilled. Typically, this is due to an ETag mismatch, indicating that the resource was modified by another entity
    ...    Reference: clause 5.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance not modified
    PATCH individual vnfInstance
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is    ProblemDetails

PATCH Individual VNFInstance Conflict
    [Documentation]    Test ID: 6.3.5.2.6
    ...    Test title: PATCH Individual VNFInstance Conflict
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance not modified
     PATCH individual vnfInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails

DELETE Individual VNFInstance
    [Documentation]    Test ID: 6.3.5.2.7
    ...    Test title: DELETE Individual VNFInstance
    ...    Test objective: The objective is to delete a VNF instance
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.3.3.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance deleted
    DELETE individual vnfInstance
    Check HTTP Response Status Code Is    204

DELETE Individual VNFInstance Conflict
     [Documentation]    Test ID: 6.3.5.2.8
    ...    Test title: DELETE Individual VNFInstance
    ...    Test objective: The objective is to verify that The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: VNF instance resource is in INSTANTIATED state
    ...    Reference: clause 5.4.3.3.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE individual vnfInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
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

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfToLevelRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level    ${body}
    Integer    response status    202 
