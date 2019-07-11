*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Post Instantiate a nsInstance
    [Documentation]    Test ID: 5.3.2.3.1
    ...    Test title: Post Instantiate a nsInstance
    ...    Test objective: The objective is to test that POST method allow to create a new NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is created on the NFVO
    POST Instatiate nsInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Post Instantiate a nsInstance Conflict
    [Documentation]    Test ID: 5.3.2.3.2
    ...    Test title: Post Instantiate a nsInstance Conflict
    ...    Test objective: The objective is to test that the operation can't be performed due to a conflict with the state of resource
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not instantiated on the NFVO
    [Setup]    Check resource instantiated
    POST Instatiate nsInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Instantiate NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.3.3
    ...    Test title: GET Instantiate NSInstance - Method not implemented
    ...    Test objective: The objective is to test that the operation can't be performed due because method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none.
    GET Instantiate NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Instantiate NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.3.4
    ...    Test title: PUT Instantiate NSInstance - Method not implemented
    ...    Test objective: The objective is to test that the operation can't be performed due because method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.4.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified on the NFVO
    PUT Instantiate NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Instantiate NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.3.5
    ...    Test title: PATCH Instantiate NSInstance - Method not implemented
    ...    Test objective: The objective is to test that the operation can't be performed due because method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified on the NFVO
    PATCH Instantiate NSInstance
    Check HTTP Response Status Code Is    405

DELETE Instantiate NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.3.6
    ...    Test title: DELETE Instantiate NSInstance - Method not implemented
    ...    Test objective: The objective is to test that the operation can't be performed due because method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.4.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not deleted from the NFVO
    DELETE Instantiate NSInstance
    Check HTTP Response Status Code Is    405