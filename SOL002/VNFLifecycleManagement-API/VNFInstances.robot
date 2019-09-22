*** Settings ***
Resource    environment/variables.txt  
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Create a new vnfInstance
    [Documentation]    Test ID: 6.3.5.1.1
    ...    Test title: POST Create a new vnfInstance
    ...    Test objective: The objective is to create a new VNF instance resource
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: VNF instance created
    POST Create a new vnfInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    vnfInstance

GET information about multiple VNF instances  
    [Documentation]    Test ID: 6.3.5.1.2
    ...    Test title: GET information about multiple VNF instances
    ...    Test objective: The objective is to get informations about multiples VNF instances
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstances
    

GET information about multiple VNF instances Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 6.3.5.1.3
    ...    Test title: GET information about multiple VNF instances Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to get informations about multiples VNF instances with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with bad attribute
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET information about multiple VNF instances Bad Request Invalid attribute selector
    [Documentation]    Test ID: 6.3.5.1.4
    ...    Test title: GET information about multiple VNF instances Bad Request Invalid attribute selector
    ...    Test objective: The objective is to get informations about multiples VNF instances with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with bad filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET information about multiple VNF instances with "all_fields" attribute selector
    [Documentation]    Test ID: 6.3.5.1.5
    ...    Test title: GET information about multiple VNF instances with "all_fields" attribute selector
    ...    Test objective: The objective is to query information about multiple VNF instances
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstances

GET information about multiple VNF instances with "exclude_default" attribute selector
    [Documentation]    Test ID: 6.3.5.1.6
    ...    Test title: GET information about multiple VNF instances with "exclude_default" attribute selector
    ...    Test objective: The objective is to query information about multiple VNF instances
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstances
    
GET information about multiple VNF instances with "fields" attribute selector
    [Documentation]    Test ID: 6.3.5.1.7
    ...    Test title: GET information about multiple VNF instances with "fields" attribute selector
    ...    Test objective: The objective is to query information about multiple VNF instances
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstances

GET information about multiple VNF instances with "exclude_fields" attribute selector
    [Documentation]    Test ID: 6.3.5.1.8
    ...    Test title: GET information about multiple VNF instances with "exclude_fields" attribute selector
    ...    Test objective: The objective is to query information about multiple VNF instances
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    GET multiple vnfInstances with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    vnfInstances  
        
PUT VNFInstances - Method not implemented
    [Documentation]    Test ID: 6.3.5.1.9
    ...    Test title: PUT VNFInstances - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PUT multiple vnfInstances
    Check HTTP Response Status Code Is    405

PATCH VNFInstances - Method not implemented
    [Documentation]    Test ID: 6.3.5.1.10
    ...    Test title: PATCH VNFInstances - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: 
    PATCH multiple vnfInstances
    Check HTTP Response Status Code Is    405

DELETE VNFInstances - Method not implemented
    [Documentation]    Test ID: 6.3.5.1.11
    ...    Test title: DELETE VNFInstances - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions:  
    ...    Reference: section 5.4.2.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: 
    ...    Post-Conditions: vnf instance not deleted
    DELETE multiple vnfInstances
    Check HTTP Response Status Code Is    405