*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt  
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new vnfInstance
    [Documentation]    Test ID: 6.3.5.1.1
    ...    Test title: Create a new vnfInstance
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance created
    POST Create a new vnfInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    vnfInstance

Get information about multiple VNF instances  
    [Documentation]    Test ID: 6.3.5.1.2
    ...    Test title: Get information about multiple VNF instances
    ...    Test objective: The objective is to get informations about multiples VNF instances
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstances
    

Get information about multiple VNF instances Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 6.3.5.1.3
    ...    Test title: Get information about multiple VNF instances Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to get informations about multiples VNF instances with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with bad attribute
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get information about multiple VNF instances Bad Request Invalid attribute selector
    [Documentation]    Test ID: 6.3.5.1.4
    ...    Test title: Get information about multiple VNF instances Bad Request Invalid attribute selector
    ...    Test objective: The objective is to get informations about multiples VNF instances with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with bad filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails
    
PUT VNFInstances - Method not implemented
    [Documentation]    Test ID: 6.3.5.1.5
    ...    Test title: PUT multiples VNFInstances - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PUT multiple vnfInstances
    Check HTTP Response Status Code Is    405

PATCH VNFInstances - Method not implemented
    [Documentation]    Test ID: 6.3.5.1.6
    ...    Test title: PATCH multiples VNFInstances - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH multiple vnfInstances
    Check HTTP Response Status Code Is    405

DELETE VNFInstances - Method not implemented
    [Documentation]    Test ID: 6.3.5.1.7
    ...    Test title: PUT multiples VNFInstances - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    DELETE multiple vnfInstances
    Check HTTP Response Status Code Is    405