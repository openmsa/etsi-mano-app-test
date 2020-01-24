*** Settings ***
Resource    environment/variables.txt
Resource   NSFMOperationKeywords.robot  
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem

*** Test Cases ***
POST Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.1
    ...    Test title:POST Alarms - Method not implemented
    ...    Test objective: The objective is to test that Post method is not allowed to create Fault management alarms on NFV
    ...    Pre-conditions: none
    ...    Reference: clause 8.4.2.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none 
    ...    Post-Conditions:  alarm not created
    POST Alarms
    Check HTTP Response Status Code Is    405

GET information about multiple alarms
    [Documentation]    Test ID: 5.3.3.1.2
    ...    Test title: GET information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list and perform a JSON schema and content validation of the returned alarms data structure
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

GET information about multiple alarms with filters
     [Documentation]    Test ID: 5.3.3.1.3
    ...    Test title: GET information about multiple alarms with filters
    ...    Test objective: The objective is to retrieve information about the alarm list and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms With Filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.3.3.1.4
    ...    Test title: GET information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    ...    Test objective:  The objective is to try to retrieve information about the alarm list with invalid filters and perform a JSON schema and content validation of the returned problem details data structure
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:  none
    GET Alarms With Invalid Filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET information about multiple alarms with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.3.1.5
    ...    Test title: GET information about multiple alarms with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms with exclude_default attribute selector
    [Documentation]    Test ID: 5.3.3.1.6
    ...    Test title: GET information about multiple alarms with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

    
GET information about multiple alarms with fields attribute selector
    [Documentation]    Test ID: 5.3.3.1.7
    ...    Test title: GET information about multiple alarms with fields attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
     
GET information about multiple alarms with "exclude_fields" attribute selector
    [Documentation]    Test ID: 5.3.3.1.8
    ...    Test title: GET information about multiple alarms with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: none
    GET Alarms Task with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms  
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.5
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed for Fault management alarms on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    PUT Alarms
    Check HTTP Response Status Code Is    405
    
    
PATCH Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.6
    ...    Test title: PATCH Alarms - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed for Fault management alarms on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    PATCH Alarms
    Check HTTP Response Status Code Is    405

DELETE Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.7
    ...    Test title: DELETE Alarms - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed for Fault management alarms on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: alarm not deleted
    DELETE Alarms
    Check HTTP Response Status Code Is    405
    

