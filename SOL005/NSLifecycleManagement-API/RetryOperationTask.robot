*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Retry operation task
    Depends on test    Check resource FAILED_TEMP
	Do POST Retry operation task
	Check HTTP Response Status Code Is    202
	Check HTTP Response Header Contains    Location
	
Post Retry operation task Not Found
    [Setup]    Check retry not supported
	Do POST Retry operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
		
Post Retry operation task Conflict
    Depends on test failure  Check resource FAILED_TEMP
	Do POST Retry operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
	
PUT Retry operation task - Method not implemented
    Do PUT Retry operation task
    Check HTTP Response Status Code Is    405

PATCH Retry operation task - Method not implemented
    Do PATCH Retry operation task
    Check HTTP Response Status Code Is    405

DELETE Retry operation task - Method not implemented
    Do DELETE Retry operation task
    Check HTTP Response Status Code Is    405
    
GET Retry operation task - Method not implemented 
	Do GET Retry operation task
	Check HTTP Response Status Code Is    405


	