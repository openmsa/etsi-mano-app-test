*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource   environment/variables.txt
Resource   FaultManagement-APIKeyword.robot  
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem


*** Test Cases ***
POST Alarms - Method not implemented
     [Documentation]    Test ID: 7.3.5.1.1
    ...    Test title: POST Alarms - Method not implemented 
    ...    Test objective: The objective is to test that Post method is not allowed to create Fault management alarms on VNF 
    ...    Pre-conditions: none
    ...    Reference: section 7.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none
    Send POST request for fault management Alarms
    Check HTTP Response Status Code Is    405

Get information about multiple alarms  
    [Documentation]    Test ID: 7.3.5.1.2
    ...    Test title: Get information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list and perform a JSON schema and content validation of the returned alarms data structure
    ...    Pre-conditions: none
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Fault Management Alarms
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Alarms

Get information about multiple alarms with filter 
    [Documentation]    Test ID: 7.3.5.1.3
    ...    Test title: Get information about multiple alarms with filter
    ...    Test objective: The objective is to retrieve information about the alarm list and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: none 
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Fault Management Alarms With Filters 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Alarms

Get information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.5.1.4
    ...    Test title:  Get information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to try to retrieve information about the alarm list with invalid filters and perform a JSON schema and content validation of the returned problem details data structure
    ...    Pre-conditions: none
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Fault Management Alarms With Invalid Filters 
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET information about multiple alarms with "all_fields" attribute selector
    [Documentation]    Test ID: 7.3.5.1.5
    ...    Test title: GET information about multiple alarms with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms with exclude_default attribute selector
    [Documentation]    Test ID: 7.3.5.1.6
    ...    Test title: GET information about multiple alarms with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms with fields attribute selector
    [Documentation]    Test ID: 7.3.5.1.7
    ...    Test title: GET information about multiple alarms with fields attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
     
GET information about multiple alarms with "exclude_fields" attribute selector
    [Documentation]    Test ID: 7.3.5.1.8
    ...    Test title: GET information about multiple alarms with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 7.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    GET Alarms Task with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms 
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 7.3.5.1.9
    ...    Test title: PUT Alarms - Method not implemented 
    ...    Test objective: The objective is to test that PUT method is not allowed to for Fault management alarms on VNF 
    ...    Pre-conditions: none
    ...    Reference: section 7.4.2.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none
    PUT Fault management Alarms
    Check HTTP Response Status Code Is    405

PATCH Alarms - Method not implemented
     [Documentation]    Test ID: 7.3.5.1.6
    ...    Test title: PATCH Alarms - Method not implemented 
    ...    Test objective: The objective is to test that PATCH method is not allowed to for Fault management alarms on VNF 
    ...    Pre-conditions: none
    ...    Reference: section 7.4.2.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none
    PATCH Fault management Alarms
    Check HTTP Response Status Code Is    405

DELETE Alarms - Method not implemented
     [Documentation]    Test ID: 7.3.5.1.7
    ...    Test title: POST Alarms - Method not implemented 
    ...    Test objective: The objective is to test that DELETE method is not allowed for Fault management alarms on VNF 
    ...    Pre-conditions: none
    ...    Reference: section 7.4.2.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none
    DELETE Fault management Alarms
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF fault management alarms Exists
    