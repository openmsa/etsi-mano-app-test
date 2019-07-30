*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
NS Instance Deletion
    [Documentation]    Test ID: 5.3.2.19
    ...    Test title: NS Instance Deletion
    ...    Test objective: The objective is to test the workflow for Deleting a NS instance
    ...    Pre-conditions: the resource is in NOT_INSTANTIATED state
    ...    Reference: section 6.4.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Check resource not_instantiated
    DELETE IndividualNSInstance
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body Json Schema Is    NsIdentifierDeletionNotification