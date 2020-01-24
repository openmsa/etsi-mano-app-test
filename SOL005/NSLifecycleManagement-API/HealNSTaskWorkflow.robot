*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup       Initialize System
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Heal Flow of NS lifecycle management operations
     [Documentation]    Test ID: 5.3.2.19
    ...    Test title: Heal Flow of NS lifecycle management operations
    ...    Test objective: The objective is to test the workflow for Healing a NS instance
    ...    Pre-conditions: the resource is in INSTANTIATED state
    ...    Reference: clause 6.4.7 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Check resource instantiated
    POST Heal NSInstance
    Check HTTP Response Status Code Is    202
    Check Operation Occurrence Id
    Check Operation Notification Status is    START
    Check Operation Notification Status is    RESULT
    Check resource instantiated
    
    
    
    
    
    
    
    
    
    
    