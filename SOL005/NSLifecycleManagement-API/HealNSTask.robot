*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Heal a NSInstance
    Do POST Heal NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Heal a NSInstance Conflict
    [Setup]    Check resource not_instantiated
    Do POST Heal NSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header Contains    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
GET Heal NSInstance- Method not implemented
    Do GET Heal NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Heal NSInstance - Method not implemented
    Do PUT Heal NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Heal NSInstance - Method not implemented
    Do PATCH Heal NSInstance
    Check HTTP Response Status Code Is    405

DELETE Heal NSInstance - Method not implemented
    Do DELETE Heal NSInstance
    Check HTTP Response Status Code Is    405
    
    