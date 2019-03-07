*** Settings ***
Resource    environment/variables.txt
Resource   NSFMOperationKeywords.robot   
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}   

Documentation    This resource represents an individual subscription for NFVO alarms. 
...    The client can use this resource to read and to terminate a subscription to notifications related to NFVO fault management.
Suite Setup    Check Individual Subscription existance

*** Test Cases ***
Post Individual Subscription - Method not implemented
    [Documentation]    Test ID: 8.4.5.1
    ...    Test title:POST Individual subscription - Method not implemented
    ...    Test objective: The objective is to POST an individual subscription 
    ...    Pre-conditions: 
    ...    Reference: section 8.4.5 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: 
    Do POST Individual Subscription
    Check HTTP Response Status Code Is    405

Get Information about an individual subscription
    [Documentation]    Test ID: 8.4.5.2
    ...    Test title: Retrieve the alarm subscription
    ...    Test objective: The objective is to read an individual subscription for NFVO alarms subscribed by the client
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: section 8.4.5 - SOL005 v2.4.1
    ...    Config ID: 
    ...    Applicability:  
    ...    Post-Conditions: 
    Do GET Individual Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    FmSubscription.schema.json

PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 8.4.5.3
    ...    Test title:PUT Individual subscription - Method not implemented
    ...    Test objective: The objective is to PUT an individual subscription 
    ...    Pre-conditions: 
    ...    Reference: section 8.4.5 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: 
    Do PUT Individual Subscription
    Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 8.4.5.4
    ...    Test title:PATCH Individual subscription - Method not implemented
    ...    Test objective: The objective is to PATCH an individual subscription 
    ...    Pre-conditions: 
    ...    Reference: section 8.4.5 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: 
    Do PATCH Individual Subscription
    Check HTTP Response Status Code Is    405
    
DELETE an individual subscription
    [Documentation]    Test ID: 8.4.5.5
    ...    Test title:DELETE an individual subscription
    ...    Test objective: The objective is to DELETE an individual subscription 
    ...    Pre-conditions: The Subsbcription already exists
    ...    Reference: section 8.4.5 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: 
    Do DELETE Individual Subscription
    Check HTTP Response Status Code Is    204
    