*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new NsInstance
    POST New nsInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    NsInstance

Get information about multiple NS instances  
    GET NsInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsInstances  
    
Get information about multiple NS instances Bad Request Invalid attribute-based filtering parameters
    GET NsInstance Invalid Attribute-Based filtering parameter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
Get information about multiple NS instances Bad Request Invalid attribute selector
    GET NsInstance Invalid Attribute Selector
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT NSInstances - Method not implemented
    PUT NSInstances
    Check HTTP Response Status Code Is    405
    
PATCH NSInstances - Method not implemented
    PATCH NSInstances
    Check HTTP Response Status Code Is    405

DELETE NSInstances - Method not implemented
    DELETE NSInstances
    Check HTTP Response Status Code Is    405