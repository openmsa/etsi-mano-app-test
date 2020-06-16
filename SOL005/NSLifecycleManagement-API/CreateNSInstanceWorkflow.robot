*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}     ssl_verify=false
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/


*** Test Cases ***

NS Instance Creation
    [Documentation]    Test ID: 5.3.2.18.1
    ...    Test title: NS Instance Creation
    ...    Test objective: The objective is to test the workflow for Creating a NS instance
    ...    Pre-conditions: none
    ...    Reference: Clause 6.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management operation occurrence is in NOT_ISTANTIATED state
    POST New nsInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    NsIdentifierCreationNotification
    Check resource not_instantiated
    
    