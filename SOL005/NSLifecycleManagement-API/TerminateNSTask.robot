*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Terminate a NSInstance
    Do POST Terminate NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Terminate a NSInstance Conflict
    [Setup]    Check resource not_instantiated
    Do POST Terminate NSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header Contains    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
GET Terminate NSInstance- Method not implemented
    Do GET Terminate NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Terminate NSInstance - Method not implemented
    Do PUT Terminate NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Terminate NSInstance - Method not implemented
    Do PATCH Terminate NSInstance
    Check HTTP Response Status Code Is    405

DELETE Terminate NSInstance - Method not implemented
    Do DELETE Terminate NSInstance
    Check HTTP Response Status Code Is    405
    
    