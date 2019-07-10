*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Rollback operation task
     [Documentation]    Test ID: 5.3.2.11.1
    ...    Test title: POST Rollback a NS lifecycle operation
    ...    Test objective: The objective is to test that POST method trigger a rollback on the LCM operation
    ...    Pre-conditions: NS instance status equal to FAILED_TEMP
    ...    Reference:  section 6.4.12.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    Depends on test    Check resource FAILED_TEMP
	POST Rollback operation task
	Check HTTP Response Status Code Is    202

	
Post Rollback operation task Not Found
    [Documentation]    Test ID: 5.3.2.11.2
    ...    Test title: POST Rollback a NS lifecycle operation
    ...    Test objective: The objective is to test that POST method fail if operation is not found
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.12.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none  
    [Setup]    Check Rollback not supported
	POST Rollback operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails
		
Post Rollback operation task Conflict
    [Documentation]    Test ID: 5.3.2.11.3
    ...    Test title: POST Rollback a NS lifecycle operation
    ...    Test objective: The objective is to test that POST method fail in case of operation status conflict
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.12.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none      
    Depends on test failure  Check resource FAILED_TEMP
	POST Rollback operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails

GET Rollback operation task - Method not implemented 
    [Documentation]    Test ID: 5.3.2.11.4
    ...    Test title: GET Rollback NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.12.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET Rollback operation task
	Check HTTP Response Status Code Is    405
	
PUT Rollback operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.11.5
    ...    Test title: PUT Rollback NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.12.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Rollback operation task
    Check HTTP Response Status Code Is    405

PATCH Rollback operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.11.6
    ...    Test title: PATCH Rollback NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.12.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Rollback operation task
    Check HTTP Response Status Code Is    405

DELETE Rollback operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.11.7
    ...    Test title: DELETE Rollback NS lifecycle operation - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.12.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Rollback operation task
    Check HTTP Response Status Code Is    405
    



	