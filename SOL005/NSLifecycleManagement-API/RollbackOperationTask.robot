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
    Depends on test    Check resource FAILED_TEMP
	Do POST Rollback operation task
	Check HTTP Response Status Code Is    202

	
Post Rollback operation task Not Found
    [Setup]    Check Rollback not supported
	Do POST Rollback operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
		
Post Rollback operation task Conflict
    Depends on test failure  Check resource FAILED_TEMP
	Do POST Rollback operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
	
PUT Rollback operation task - Method not implemented
    Do PUT Rollback operation task
    Check HTTP Response Status Code Is    405

PATCH Rollback operation task - Method not implemented
    Do PATCH Rollback operation task
    Check HTTP Response Status Code Is    405

DELETE Rollback operation task - Method not implemented
    Do DELETE Rollback operation task
    Check HTTP Response Status Code Is    405
    
GET Rollback operation task - Method not implemented 
	Do GET Rollback operation task
	Check HTTP Response Status Code Is    405


	