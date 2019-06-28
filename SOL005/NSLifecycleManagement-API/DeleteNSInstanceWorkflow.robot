*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
NS Instance Deletion
    Check resource not_instantiated
    DELETE IndividualNSInstance
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body Json Schema Is    NsIdentifierDeletionNotification
   
    
    