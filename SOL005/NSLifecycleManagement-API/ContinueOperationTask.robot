*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Continue operation task
     [Documentation]    Test ID: 5.3.2.12.1
    ...    Test title: POST Continue a NS lifecycle operation
    ...    Test objective: The objective is to test that POST method trigger a continue on the LCM operation
    ...    Pre-conditions: NS instance status equal to FAILED_TEMP
    ...    Reference:  section 6.4.13.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Depends on test    Check resource FAILED_TEMP
	POST Continue operation task
	Check HTTP Response Status Code Is    202
	
Post Continue operation task Not Found
    [Documentation]    Test ID: 5.3.2.12.2
    ...    Test title: POST Continue a NS lifecycle operation
    ...    Test objective: The objective is to test that POST method fail if operation is not found
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.13.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    [Setup]    Check Continue not supported
	POST Continue operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails
		
Post Continue operation task Conflict
     [Documentation]    Test ID: 5.3.2.12.3
    ...    Test title: POST Continue a NS lifecycle operation
    ...    Test objective: The objective is to test that POST method fail in case of operation status conflict
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.13.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none     
    Depends on test failure  Check resource FAILED_TEMP
	POST Continue operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails
	
GET Continue operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.10.4
    ...    Test title: GET Continue NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.10.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
	GET Continue operation task
	Check HTTP Response Status Code Is    405	
	
PUT Continue operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.10.5
    ...    Test title: PUT Continue NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.13.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Continue operation task
    Check HTTP Response Status Code Is    405

PATCH Continue operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.10.5
    ...    Test title: PATCH Continue NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.14.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Continue operation task
    Check HTTP Response Status Code Is    405

DELETE Continue operation task - Method not implemented
        [Documentation]    Test ID: 5.3.2.10.5
    ...    Test title: DELETE Continue NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.14.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Continue operation task
    Check HTTP Response Status Code Is    405
    

	