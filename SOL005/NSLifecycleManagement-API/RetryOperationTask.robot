*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Retry operation task
     [Documentation]    Test ID: 5.3.2.10.1
    ...    Test title: Post Retry operation task
    ...    Test objective: The objective is to test that POST method trigger a retry of NS lifecycle operation in case of temporary failure
    ...    Pre-conditions: NS instance status equal to FAILED_TEMP
    ...    Reference:  section 6.4.11.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: NS instance status not equal to FAILED_TEMP
	POST Retry operation task
	Check HTTP Response Status Code Is    202
	Check HTTP Response Header Contains    Location
	Check operation resource state is not FAILED_TEMP
	
Post Retry operation task Not Found
    [Documentation]    Test ID: 5.3.2.10.2
    ...    Test title: Post Retry operation task Not Found
    ...    Test objective: The objective is to test that POST method fail in case of NS lifecycle operation not found
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.11.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	POST Retry operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails
		
Post Retry operation task Conflict
    [Documentation]    Test ID: 5.3.2.10.3
    ...    Test title: Post Retry operation task Conflict
    ...    Test objective: The objective is to test that POST method fail in case of NS lifecycle operation status conflict (i.e.  NS instance status not equal to FAILED_TEMP)
    ...    Pre-conditions:  NS instance status not equal to FAILED_TEMP
    ...    Reference:  section 6.4.11.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	POST Retry operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails

GET Retry operation task - Method not implemented 
    [Documentation]    Test ID: 5.3.2.10.4
    ...    Test title: GET Retry operation task - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.11.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET Retry operation task
	Check HTTP Response Status Code Is    405
	
PUT Retry operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.10.5
    ...    Test title: PUT Retry operation task - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.11.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Retry operation task
    Check HTTP Response Status Code Is    405

PATCH Retry operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.10.6
    ...    Test title: PATCH Retry operation task - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.11.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Retry operation task
    Check HTTP Response Status Code Is    405

DELETE Retry operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.10.7
    ...    Test title: DELETE Retry operation task - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.11.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Retry operation task
    Check HTTP Response Status Code Is    405
    



	