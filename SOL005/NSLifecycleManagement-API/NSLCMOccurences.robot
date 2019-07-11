*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post NS LCM occurences - Method not implemented
    [Documentation]    Test ID: 5.3.2.8.1
    ...    Test title: Post NS LCM occurences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Terminate NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
	POST NS LCM OP Occurences
	Check HTTP Response Status Code Is    405

Get status information about multiple NS LCM OP OCC   
     [Documentation]    Test ID: 5.3.2.8.2
    ...    Test title: Get status information about multiple NS LCM OP OCC
    ...    Test objective: The objective is to test that GET method return a list of LCM occurrences of the NS
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET NS LCN OP Occurences
	Check HTTP Response Status Code Is    200
	Check HTTP Response Body Json Schema Is    NsLcmOpOccs

Get status information about multiple NS LCM OP OCC Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.3.2.8.3
    ...    Test title: Get status information about multiple NS LCM OP OCC Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to test that GET method fail because the query parameter is not existing
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET NS LCN OP Occurences Invalid attribute-based filtering parameters
	Check HTTP Response Status Code Is    400
	Check HTTP Response Body Json Schema Is    ProblemDetails

Get status information about multiple NS LCM OP OCC Bad Request Invalid attribute selector
    [Documentation]    Test ID: 5.3.2.8.4
    ...    Test title: Get status information about multiple NS LCM OP OCC Bad Request Invalid attribute selector
    ...    Test objective: The objective is to test that GET method fail because the attributes selector is not existing
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET NS LCN OP Occurences Invalid attribute selector
	Check HTTP Response Status Code Is    400
	Check HTTP Response Body Json Schema Is    ProblemDetails
	

PUT status information about multiple NS LCM OP OCC - Method not implemented
    [Documentation]    Test ID: 5.3.2.8.5
    ...    Test title: PUT status information about multiple NS LCM OP OCC - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT NS LCM OP Occurences
    Check HTTP Response Status Code Is    405

PATCH status information about multiple NS LCM OP OCC - Method not implemented
    [Documentation]    Test ID: 5.3.2.8.6
    ...    Test title: PATCH status information about multiple NS LCM OP OCC - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH NS LCM OP Occurences
    Check HTTP Response Status Code Is    405

DELETE status information about multiple NS LCM OP OCC - Method not implemented
    [Documentation]    Test ID: 5.3.2.8.7
    ...    Test title: DELETE status information about multiple NS LCM OP OCC - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.9.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE NS LCM OP Occurences
    Check HTTP Response Status Code Is    405
    
