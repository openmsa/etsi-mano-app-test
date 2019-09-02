*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Cancel operation task
    [Documentation]    Test ID: 5.3.2.14.1
    ...    Test title: POST Cancel operation task
    ...    Test objective: The objective is to test that POST method cancel the NS LCM operation
    ...    Pre-conditions: NS instance status equal to STARTING, PROCESSING or ROLLING_BACK
    ...    Reference:  section 6.4.15.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: NS instance status equal to FAILED_TEMP     
	POST Cancel operation task
	Check HTTP Response Status Code Is    202
	Check operation resource state is FAILED_TEMP
	
POST Cancel operation task Not Found
    [Documentation]    Test ID: 5.3.2.14.2
    ...    Test title: POST Cancel operation task Not Found
    ...    Test objective: The objective is to test that POST method fail completing the Cancel NS LCM operation if the resource is not found
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.15.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none       
	POST Cancel operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails
		
POST Cancel operation task Conflict
    [Documentation]    Test ID: 5.3.2.14.3
    ...    Test title: POST Cancel operation task Conflict
    ...    Test objective: The objective is to test that POST method fail if a status conflict exist on the NS LCM operation. (i.e. NS instance status not equal to STARTING, PROCESSING or ROLLING_BACK)
    ...    Pre-conditions: NS instance status not equal to STARTING, PROCESSING or ROLLING_BACK
    ...    Reference:  section 6.4.15.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
	POST Cancel operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails

GET Cancel operation task - Method not implemented 
    [Documentation]    Test ID: 5.3.2.14.4
    ...    Test title: GET Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.15.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET Cancel operation task
	Check HTTP Response Status Code Is    405
	
PUT Cancel operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.14.5
    ...    Test title: PUT Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.15.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    PUT Cancel operation task
    Check HTTP Response Status Code Is    405

PATCH Cancel operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.14.6
    ...    Test title: PATCH Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.15.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Cancel operation task
    Check HTTP Response Status Code Is    405

DELETE Cancel operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.14.7
    ...    Test title: DELETE Cancel operation task - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.15.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Cancel operation task
    Check HTTP Response Status Code Is    405
    
	