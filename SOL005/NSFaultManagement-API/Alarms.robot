*** Settings ***
Resource    environment/variables.txt
Resource   NSFMOperationKeywords.robot  
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem

*** Test Cases ***
POST Alarms - Method not implemented
    [Documentation]    Test ID: 8.4.2.1
    ...    Test title:POST Alarms - Method not implemented
    ...    Test objective: The objective is to post alarms
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do POST Alarms
    Check HTTP Response Status Code Is    405

Get information about multiple alarms 
    [Documentation]    Test ID: 8.4.2.2
    ...    Test title: Get information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID: 
    ...    Applicability: 
    ...    Post-Conditions:
    Do GET Alarms
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    alarms.schema.json


Get information about multiple alarms with filters 
     [Documentation]    Test ID: 8.4.2.2-2
    ...    Test title: Get information about multiple alarms with filters
    ...    Test objective: The objective is to retrieve information about the alarm list with filters
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID: 
    ...    Applicability: 
    ...    Post-Conditions:  
    Do GET Alarms With Filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    alarms.schema.json
    

Get information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 8.4.2.2-3
    ...    Test title: Get information about multiple alarms - with Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: 
    Do GET Alarms With Invalid Filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 8.4.2.3
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to put alarms
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do PUT Alarms
    Check HTTP Response Status Code Is    405
    
    
PATCH Alarms - Method not implemented
    [Documentation]    Test ID: 8.4.2.4
    ...    Test title: PATCH Alarms - Method not implemented
    ...    Test objective: The objective is to post alarms
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do PATCH Alarms
    Check HTTP Response Status Code Is    405

DELETE Alarms - Method not implemented
    [Documentation]    Test ID: 8.4.2.5
    ...    Test title: DELETE Alarms - Method not implemented
    ...    Test objective: The objective is to DELETE alarms
    ...    Pre-conditions: 
    ...    Reference: section 8.4.2 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do DELETE Alarms
    Check HTTP Response Status Code Is    405

