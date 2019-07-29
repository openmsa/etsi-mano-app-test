*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
POST Heal a NSInstance
    [Documentation]    Test ID: 5.3.2.6.1
    ...    Test title: POST Heal a NSInstance
    ...    Test objective: The objective is to test that POST method allow to trigger a Heal NS instance
    ...    Pre-conditions: resource status is not in NOT_INSTANTIATED state
    ...    Reference:  section 6.4.7.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Heal NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

POST Heal a NSInstance Conflict
    [Documentation]    Test ID: 5.3.2.6.2
    ...    Test title: POST Heal a NSInstance Conflict
    ...    Test objective: The objective is to test that POST method fail if NS instance is not in NOT_INSTANTIATE state 
    ...    Pre-conditions: resource status is in NOT_INSTANTIATED state
    ...    Reference:  section 6.4.7.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Heal NSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header Contains    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Heal NSInstance- Method not implemented
    [Documentation]    Test ID: 5.3.2.6.3
    ...    Test title: GET Heal NSInstance- Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.7.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Heal NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Heal NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.6.4
    ...    Test title: PUT Heal NSInstance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.7.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Heal NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Heal NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.6.4
    ...    Test title: PATCH Heal NSInstance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.7.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Heal NSInstance
    Check HTTP Response Status Code Is    405

DELETE Heal NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.6.4
    ...    Test title: DELETE Heal NSInstance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.7.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Heal NSInstance
    Check HTTP Response Status Code Is    405
    
    