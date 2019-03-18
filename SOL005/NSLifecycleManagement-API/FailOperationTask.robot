*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Fail operation task
    Depends on test    Check resource FAILED_TEMP
	Do POST Fail operation task
	Check HTTP Response Status Code Is    202
	
Post Fail operation task Not Found
    [Setup]    Check Fail not supported
	Do POST Fail operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
		
Post Fail operation task Conflict
    Depends on test failure      Check resource FAILED_TEMP
	Do POST Fail operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
	
PUT Fail operation task - Method not implemented
    Do PUT Fail operation task
    Check HTTP Response Status Code Is    405

PATCH Fail operation task - Method not implemented
    Do PATCH Fail operation task
    Check HTTP Response Status Code Is    405

DELETE Fail operation task - Method not implemented
    Do DELETE Fail operation task
    Check HTTP Response Status Code Is    405
    
GET Fail operation task - Method not implemented 
	Do GET Fail operation task
	Check HTTP Response Status Code Is    405



	