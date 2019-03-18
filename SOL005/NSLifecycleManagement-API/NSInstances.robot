*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new NsInstance
    Do POST New nsInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    NsInstance.schema.json

Get information about multiple NS instances  
    Do GET NsInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    NsInstances.schema.json  
    
Get information about multiple NS instances Bad Request Invalid attribute-based filtering parameters
    Do GET NsInstance Invalid Attribute-Based filtering parameter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
Get information about multiple NS instances Bad Request Invalid attribute selector
    Do GET NsInstance Invalid Attribute Selector
    Check HTTP Response Status Code Is    400
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
PUT NSInstances - Method not implemented
    Do PUT NSInstances
    Check HTTP Response Status Code Is    405
    
PATCH NSInstances - Method not implemented
    Do PATCH NSInstances
    Check HTTP Response Status Code Is    405

DELETE NSInstances - Method not implemented
    Do DELETE NSInstances
    Check HTTP Response Status Code Is    405