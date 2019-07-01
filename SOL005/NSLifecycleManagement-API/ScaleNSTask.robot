*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Scale a nsInstance
    POST scale nsInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Instantiate a nsInstance Conflict
    [Setup]    Check resource not_instantiated
    POST scale nsInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET Scale NSInstance- Method not implemented
    GET scale NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Scale NSInstance - Method not implemented
    PUT scale NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Scale NSInstance - Method not implemented
    PATCH scale NSInstance
    Check HTTP Response Status Code Is    405

DELETE Scale NSInstance - Method not implemented
    DELETE scale NSInstance
    Check HTTP Response Status Code Is    405
    
    