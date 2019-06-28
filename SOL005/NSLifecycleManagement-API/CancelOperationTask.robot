*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Cancel operation task
    Depends on test    Check resource FAILED_TEMP
	POST Cancel operation task
	Check HTTP Response Status Code Is    202
	
Post Cancel operation task Not Found
    [Setup]    Check Cancel not supported
	POST Cancel operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails
		
Post Cancel operation task Conflict
    Depends on test failure      Check resource FAILED_TEMP
	POST Cancel operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails
	
PUT Cancel operation task - Method not implemented
    PUT Cancel operation task
    Check HTTP Response Status Code Is    405

PATCH Cancel operation task - Method not implemented
    PATCH Cancel operation task
    Check HTTP Response Status Code Is    405

DELETE Cancel operation task - Method not implemented
    DELETE Cancel operation task
    Check HTTP Response Status Code Is    405
    
GET Cancel operation task - Method not implemented 
	GET Cancel operation task
	Check HTTP Response Status Code Is    405




	