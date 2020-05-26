*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Fail operation task
    [Documentation]    Test ID: 5.3.2.13.1
    ...    Test title: POST Fail operation task
    ...    Test objective: The objective is to test that POST method trigger a state change to "finally failed" on the NS LCM operation
    ...    Pre-conditions: NS instance status equal to FAILED_TEMP
    ...    Reference: Clause 6.4.14.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
	POST Fail operation task
	Check HTTP Response Status Code Is    202
	Check resource is finally failed
	
	
POST Fail operation task Not Found
    [Documentation]    Test ID: 5.3.2.13.2
    ...    Test title: POST Fail operation task Not Found
    ...    Test objective: The objective is to test that POST method fail if the NS LCM resource is not found
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.14.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
	POST Fail operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails
		
POST Fail operation task Conflict
    [Documentation]    Test ID: 5.3.2.13.3
    ...    Test title: POST Fail operation task Conflict
    ...    Test objective: The objective is to test that POST method fail in case of status conflict on the NS LCM operation (i.e NS instance status not equal to FAILED_TEMP)
    ...    Pre-conditions: NS instance status not equal to FAILED_TEMP
    ...    Reference: Clause 6.4.14.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
	POST Fail operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails

GET Fail operation task - Method not implemented 
     [Documentation]    Test ID: 5.3.2.13.4
    ...    Test title: GET Fail operation task - Method not implemented
    ...    Test objective: The objective is to test that GET method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.14.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET Fail operation task
	Check HTTP Response Status Code Is    405
	
PUT Fail operation task - Method not implemented
    [Documentation]    Test ID: 5.3.2.13.5
    ...    Test title: PUT Fail operation task - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.14.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Fail operation task
    Check HTTP Response Status Code Is    405

PATCH Fail operation task - Method not implemented
     [Documentation]    Test ID: 5.3.2.13.6
    ...    Test title: PATCH Fail operation task - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.14.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Fail operation task
    Check HTTP Response Status Code Is    405

DELETE Fail operation task - Method not implemented
     [Documentation]    Test ID: 5.3.2.13.7
    ...    Test title: DELETE Fail operation task - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.14.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    DELETE Fail operation task
    Check HTTP Response Status Code Is    405
    
	