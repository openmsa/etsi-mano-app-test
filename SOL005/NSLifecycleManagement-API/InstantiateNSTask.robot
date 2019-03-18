*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Instantiate a nsInstance
    Do POST Instatiate nsInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Instantiate a nsInstance Conflict
    [Setup]    Check resource instantiated
    Do POST Instatiate nsInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header Contains    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
GET Instantiate NSInstance - Method not implemented
    Do GET Instantiate NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Instantiate NSInstance - Method not implemented
    Do PUT Instantiate NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Instantiate NSInstance - Method not implemented
    Do PATCH Instantiate NSInstance
    Check HTTP Response Status Code Is    405

DELETE Instantiate NSInstance - Method not implemented
    Do DELETE Instantiate NSInstance
    Check HTTP Response Status Code Is    405