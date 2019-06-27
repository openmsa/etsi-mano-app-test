*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Update a NSInstance
    POST Update NSInstance
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location

Update a NSInstance Conflict
    [Setup]    Check resource not_instantiated
    POST Update NSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header Contains    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
GET Update NSInstance- Method not implemented
    GET Update NSInstance
    Check HTTP Response Status Code Is    405
    
PUT Update NSInstance - Method not implemented
    PUT Update NSInstance
    Check HTTP Response Status Code Is    405
    
PATCH Update NSInstance - Method not implemented
    PATCH Update NSInstance
    Check HTTP Response Status Code Is    405

DELETE Update NSInstance - Method not implemented
    DELETE Update NSInstance
    Check HTTP Response Status Code Is    405
    
    