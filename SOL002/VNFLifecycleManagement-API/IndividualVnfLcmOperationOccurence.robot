*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
*** Test Cases ***
Post Individual VNF LCM OP occurences - Method not implemented
    [Documentation]    Test ID: 6.3.5.12.1
    ...    Test title: Post Individual VNF LCM OP occurences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.13.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Individual VNF LCM OP occurences
    Check HTTP Response Status Code Is    405
    
Get status information about multiple VNF instances 
    [Documentation]    Test ID: 6.3.5.12.2
    ...    Test title: Get status information about multiple VNF instances
    ...    Test objective: The objective is to test that this method retrieve status information about a VNF lifecycle management operation occurrence 
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.13.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get multiple VNF instances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VnfLcmOpOcc 

PUT status information about multiple VNF instances - Method not implemented
    [Documentation]    Test ID: 6.3.5.12.3
    ...    Test title: Put Individual VNF LCM OP occurences - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.13.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none  
    Put multiple VNF instances
    Check HTTP Response Status Code Is    405

PATCH status information about multiple VNF instances - Method not implemented 
    [Documentation]    Test ID: 6.3.5.12.4
    ...    Test title: Patch Individual VNF LCM OP occurences - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.13.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none      
    Patch multiple VNF instances
    Check HTTP Response Status Code Is    405
    
DELETE status information about multiple VNF instances - Method not implemented 
    [Documentation]    Test ID: 6.3.5.12.5
    ...    Test title: Delete Individual VNF LCM OP occurences - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.13.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none  
    Delete multiple VNF instances
    Check HTTP Response Status Code Is    405