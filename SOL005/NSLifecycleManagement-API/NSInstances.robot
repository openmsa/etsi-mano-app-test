*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new NsInstance
    Do POST New vnfInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    NsInstance.schema.json

Get information about multiple NS instances  
    Do GET NsInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    vnfInstances.schema.json  
    Log    Validation OK

