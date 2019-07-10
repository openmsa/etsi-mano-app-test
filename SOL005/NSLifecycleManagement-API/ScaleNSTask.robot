*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Scale a nsInstance
    [Documentation]    Test ID: 5.3.2.4.1
    ...    Test title: POST Individual Scale NS instance
    ...    Test objective: The objective is to test that POST method allow to create a Scale NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Scale NS instance is created on the NFVO
    POST scale nsInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Instantiate a nsInstance Conflict
    [Documentation]    Test ID: 5.3.2.4.2
    ...    Test title: POST Individual Scale NS instance
    ...    Test objective: The objective is to test that POST method allow to create a Scale NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Scale NS instance is not created on the NFVO
    [Setup]    Check resource not_instantiated
    POST scale nsInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Scale NSInstance- Method not implemented
     [Documentation]    Test ID: 5.3.2.4.3
    ...    Test title: GET Individual Scale NS instance - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET scale NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Scale NSInstance - Method not implemented
     [Documentation]    Test ID: 5.3.2.4.4
    ...    Test title: PUT Individual Scale NS instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT scale NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Scale NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.4.5
    ...    Test title: PATCH Individual Scale NS instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH scale NSInstance
    Check HTTP Response Status Code Is    405

DELETE Scale NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.4.6
    ...    Test title: DELETE Individual Scale NS instance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE scale NSInstance
    Check HTTP Response Status Code Is    405
    
    