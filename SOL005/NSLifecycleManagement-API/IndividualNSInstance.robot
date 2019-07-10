*** Settings ***
Resource   environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Post Individual NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.2.1
    ...    Test title: POST Individual NS instance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.3.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not created on the NFVO
    POST IndividualNSInstance
    Check HTTP Response Status Code Is    405

Get Information about an individual NS Instance
    [Documentation]    Test ID: 5.3.2.2.2
    ...    Test title: GET Individual NS instance
    ...    Test objective: The objective is to test that GET method allow to query an NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.3.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET IndividualNSInstance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    NsInstance
    
PUT Individual NSInstance - Method not implemented 
    [Documentation]    Test ID: 5.3.2.2.3
    ...    Test title: PUT Individual NS instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to create a new NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.3.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified on the NFVO
    PUT IndividualNSInstance
    Check HTTP Response Status Code Is    405

PATCH Individual NSInstance - Method not implemented 
    [Documentation]    Test ID: 5.3.2.2.4
    ...    Test title: PATCH Individual NS instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to create a new NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified on the NFVO
    PATCH IndividualNSInstance
    Check HTTP Response Status Code Is    405

DELETE Individual NSInstance
     [Documentation]    Test ID: 5.3.2.2.5
    ...    Test title: DELETE Individual NS instance
    ...    Test objective: The objective is to test that DELETE method is allowed to delete a NS instance
    ...    Pre-conditions: none.
    ...    Reference:  section 6.4.3.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is deleted from the NFVO
    DELETE IndividualNSInstance    
    Check HTTP Response Status Code Is    204

DELETE Individual NSInstance Conflict
    [Documentation]    Test ID: 5.3.2.2.5
    ...    Test title: DELETE Individual NS instance
    ...    Test objective: The objective is to test that DELETE method is allowed to delete a NS instance
    ...    Pre-conditions: At least one running instance of a NS
    ...    Reference:  section 6.4.3.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is deleted from the NFVO
    [Setup]    Check resource instantiated
    DELETE IndividualNSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails
