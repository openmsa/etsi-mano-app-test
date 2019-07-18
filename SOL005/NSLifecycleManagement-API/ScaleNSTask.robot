*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
POST Scale a nsInstance
    [Documentation]    Test ID: 5.3.2.4.1
    ...    Test title: POST Scale a nsInstance
    ...    Test objective: The objective is to test that POST method allow to create a Scale NS instance
    ...    Pre-conditions: the resource is in NOT_INSTANTIATED state
    ...    Reference:  section 6.4.5.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Scale NS instance is created on the NFVO
    POST scale nsInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

POST Instantiate a nsInstance Conflict
    [Documentation]    Test ID: 5.3.2.4.2
    ...    Test title: POST Instantiate a nsInstance Conflict
    ...    Test objective: The objective is to test that POST method can't Scale NS instance because of conflict in resource status (i.e. because the resource is in not in NOT_INSTANTIATED state)
    ...    Pre-conditions: the resource is in not in NOT_INSTANTIATED state
    ...    Reference:  section 6.4.5.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Scale NS instance is not created on the NFVO
    POST scale nsInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Scale NSInstance- Method not implemented
     [Documentation]    Test ID: 5.3.2.4.3
    ...    Test title: GET Scale NSInstance- Method not implemented
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
    ...    Test title: PUT Scale NSInstance - Method not implemented
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
    ...    Test title: PATCH Scale NSInstance - Method not implemented
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
    ...    Test title: DELETE Scale NSInstance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.5.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE scale NSInstance
    Check HTTP Response Status Code Is    405
    
    