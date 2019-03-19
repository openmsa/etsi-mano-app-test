*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance
Suite Setup       Initialize System
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Scale Flow of NS lifecycle management operations
    Check resource instantiated
    Do POST scale nsInstance
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id
    Check Operation Notification Status is    START
    Check Operation Notification Status is    RESULT
    Check resource instantiated
    
    
    
    
    
    
    
    
    
    
    