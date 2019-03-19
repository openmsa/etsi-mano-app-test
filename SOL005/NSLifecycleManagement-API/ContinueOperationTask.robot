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
    Depends on test    Check resource FAILED_TEMP
	Do POST Continue operation task
	Check HTTP Response Status Code Is    202
	
Post Continue operation task Not Found
    [Setup]    Check Continue not supported
	Do POST Continue operation task
	Check HTTP Response Status Code Is    404
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
		
Post Continue operation task Conflict
    Depends on test failure  Check resource FAILED_TEMP
	Do POST Continue operation task
	Check HTTP Response Status Code Is    409
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
	
PUT Continue operation task - Method not implemented
    Do PUT Continue operation task
    Check HTTP Response Status Code Is    405

PATCH Continue operation task - Method not implemented
    Do PATCH Continue operation task
    Check HTTP Response Status Code Is    405

DELETE Continue operation task - Method not implemented
    Do DELETE Continue operation task
    Check HTTP Response Status Code Is    405
    
GET Continue operation task - Method not implemented 
	Do GET Continue operation task
	Check HTTP Response Status Code Is    405


	