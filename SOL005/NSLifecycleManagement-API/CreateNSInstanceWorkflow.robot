*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/


*** Test Cases ***
NS Instance Creation
    POST New nsInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    NsIdentifierCreationNotification
    Check resource not_instantiated
    
    