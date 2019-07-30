*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
POST Update a NSInstance
    [Documentation]    Test ID: 5.3.2.5.1
    ...    Test title: POST Update a NSInstance
    ...    Test objective: The objective is to test that POST method update a NS instance
    ...    Pre-conditions: an existing NS Instance 
    ...    Reference:  section 6.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The  NS instance is updated on the NFVO
    POST Update NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

POST Update a NSInstance Conflict
    [Documentation]    Test ID: 5.3.2.5.2
    ...    Test title: POST Update a NSInstance Conflict
    ...    Test objective: The objective is to test that POST method fail if a NS Instance is not existing or is not in NOT_INSTANTIATED state
    ...    Pre-conditions: an existing NS  Instance 
    ...    Reference:  section 6.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The  NS instance is not updated on the NFVO
    POST Update NSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Update NSInstance- Method not implemented
    [Documentation]    Test ID: 5.3.2.5.3
    ...    Test title: GET Update NSInstance- Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.6.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Update NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Update NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.5.4
    ...    Test title: PUT Update NSInstance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.6.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The  NS instance is not updated on the NFVO
    PUT Update NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Update NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.5.5
    ...    Test title: PATCH Update NSInstance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.6.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The  NS instance is not updated on the NFVO
    PATCH Update NSInstance
    Check HTTP Response Status Code Is    405

DELETE Update NSInstance - Method not implemented
        [Documentation]    Test ID: 5.3.2.5.6
    ...    Test title: DELETE Update NSInstance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.6.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The  NS instance is not deleted on the NFVO
    DELETE Update NSInstance
    Check HTTP Response Status Code Is    405
    
    