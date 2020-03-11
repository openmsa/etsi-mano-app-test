*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existence

*** Test Cases ***
POST Scale a nsInstance
    [Documentation]    Test ID: 5.3.2.4.1
    ...    Test title: POST Scale a nsInstance
    ...    Test objective: The objective is to test that POST method scales NS instance
    ...    Pre-conditions: the resource is in NOT_INSTANTIATED state
    ...    Reference: clause 6.4.5.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST scale nsInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check resource existence
    
POST Instantiate a nsInstance Conflict
    [Documentation]    Test ID: 5.3.2.4.2
    ...    Test title: POST Instantiate a nsInstance Conflict
    ...    Test objective: The objective is to test that POST method cannot scale NS instance because of conflict in resource status (i.e. because the resource is in not in NOT_INSTANTIATED state)
    ...    Pre-conditions: the resource is in not in NOT_INSTANTIATED state
    ...    Reference: clause 6.4.5.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Scale NS operation is not triggered on the NFVO
    POST scale nsInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Scale NSInstance- Method not implemented
     [Documentation]    Test ID: 5.3.2.4.3
    ...    Test title: GET Scale NSInstance- Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
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
    ...    Reference: clause 6.4.5.3.3 - ETSI GS NFV-SOL 005 [3] v2.4.1
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
    ...    Reference: clause 6.4.5.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
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
    ...    Reference: clause 6.4.5.3.5 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE scale NSInstance
    Check HTTP Response Status Code Is    405
    
    