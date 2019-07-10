*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Terminate a NSInstance
    [Documentation]    Test ID: 5.3.2.7.1
    ...    Test title: POST Terminate Individual NS instance
    ...    Test objective: The objective is to test that POST method allow to terminate the NS
    ...    Pre-conditions: NS instance in INSTANTIATED state
    ...    Reference:  section 6.4.8.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: NS instance has NOT_INSTANTIATED state
    POST Terminate NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Terminate a NSInstance Conflict
    [Documentation]    Test ID: 5.3.2.7.2
    ...    Test title: POST Terminate Individual NS instance
    ...    Test objective: The objective is to test that POST method can't terminate the NS because the resource is not in INSTANTIATED state 
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.8.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    [Setup]    Check resource not_instantiated
    POST Terminate NSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Terminate NSInstance- Method not implemented
     [Documentation]    Test ID: 5.3.2.7.3
    ...    Test title: GET Terminate NS instance - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Terminate NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Terminate NSInstance - Method not implemented
     [Documentation]    Test ID: 5.3.2.7.4
    ...    Test title: PUT Terminate NS instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.8.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Terminate NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Terminate NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.7.5
    ...    Test title: PATCH Terminate NS instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.8.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Terminate NSInstance
    Check HTTP Response Status Code Is    405

DELETE Terminate NSInstance - Method not implemented
         [Documentation]    Test ID: 5.3.2.7.5
    ...    Test title: DELETE Terminate NS instance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.8.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Terminate NSInstance
    Check HTTP Response Status Code Is    405
    
    