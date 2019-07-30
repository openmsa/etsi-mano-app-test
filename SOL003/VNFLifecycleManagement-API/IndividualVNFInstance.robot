*** Settings ***
Resource    environment/configuration.txt
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}  
Resource    VnfLcmMntOperationKeywords.robot
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Variables ***
${original_etag}    1234

*** Test Cases ***
Post Individual VNFInstance - Method not implemented
    [Documentation]    Test ID: 7.3.1.2.1
    ...    Test title: Post Individual VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: section 5.4.3.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    POST individual vnfInstance
	Check HTTP Response Status Code Is    405

Get Information about an individual VNF Instance
     [Documentation]    Test ID: 7.3.1.2.2
    ...    Test title: Get Information about an individual VNF Instance
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: none
    ...    Reference: section 5.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET individual vnfInstance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstance
    SET etag
    
PUT Individual VNFInstance - Method not implemented 
    [Documentation]    Test ID: 7.3.1.2.3
    ...    Test title: PUT Individual VNFInstance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: section 5.4.3.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    PUT individual vnfInstance
    Check HTTP Response Status Code Is    405
    
PATCH Individual VNFInstance
     [Documentation]    Test ID: 7.3.1.2.4
    ...    Test title: PATCH Individual VNFInstance
    ...    Test objective: This method modifies an individual VNF instance resource
    ...    Pre-conditions: an existing VNF instance resource
    ...    Reference: section 5.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH individual vnfInstance
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id

PATCH Individual VNFInstance Precondition failed
     [Documentation]    Test ID: 7.3.1.2.5
    ...    Test title: PATCH Individual VNFInstance Precondition failed
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions:  A precondition given in an HTTP request header is not fulfilled. Typically, this is due to an ETag mismatch, indicating that the resource was modified by another entity
    ...    Reference: section 5.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH individual vnfInstance
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is    ProblemDetails

PATCH Individual VNFInstance Conflict
     [Documentation]    Test ID: 7.3.1.2.6
    ...    Test title: PATCH Individual VNFInstance Precondition failed
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: none
    ...    Reference: section 5.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH individual vnfInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    #[Teardown]    #We cannot know if the "scale" operation is finished easily because the 202 indicates only whether the operation has been accepted, not whether the operation has been finished

DELETE Individual VNFInstance
     [Documentation]    Test ID: 7.3.1.2.7
    ...    Test title: DELETE Individual VNFInstance
    ...    Test objective: The objective is to delete a VNF instance
    ...    Pre-conditions: the VNF instance resource is existing
    ...    Reference: section 5.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE individual vnfInstance
    Check HTTP Response Status Code Is    204

DELETE Individual VNFInstance Conflict
     [Documentation]    Test ID: 7.3.1.2.8
    ...    Test title: DELETE Individual VNFInstance
    ...    Test objective: The objective is to verify that The operation cannot be executed currently, due to a conflict with the state of the VNF instance resource. 
    ...    Pre-conditions: VNF instance resource is in INSTANTIATED state
    ...    Reference: section 5.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE individual vnfInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
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

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfToLevelRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level    ${body}
    Integer    response status    202
SET etag
    ${etag}    Output    response headers ETag
    Set Suite Variable    ${original_etag}    ${etag}    
