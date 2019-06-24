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
    [Documentation]    Test ID: 5.3.3.4.1
    ...    Test title:Post Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed for Fault management subscription on NFV  
    ...    Pre-conditions:none 
    ...    Reference: section 8.4.5.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Individual Subscription
    Check HTTP Response Status Code Is    405

Get Information about an individual subscription
    [Documentation]    Test ID: 5.3.3.4.2
    ...    Test title: Get Information about an individual subscription
    ...    Test objective: The objective is to read an individual subscription for NFVO alarms subscribed by the client and perform a JSON schema and content validation of the returned fault management individual subscription data structure
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: section 8.4.5.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Individual Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscription
    
PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 5.3.3.4.3
    ...    Test title:PUT an individual subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed for Fault management subscription on NFV   
    ...    Pre-conditions: none
    ...    Reference: section 8.4.5.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Individual Subscription
    Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 5.3.3.4.4
    ...    Test title:PATCH an individual subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed for Fault management subscription on NFV  
    ...    Pre-conditions: none
    ...    Reference: section 8.4.5.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Individual Subscription
    Check HTTP Response Status Code Is    405
    
DELETE an individual subscription
    [Documentation]    Test ID: 5.3.3.4.5
    ...    Test title:DELETE an individual subscription
    ...    Test objective: The objective is to DELETE an individual subscription 
    ...    Pre-conditions: The Subsbcription already exists
    ...    Reference: section 8.4.5.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    DELETE Individual Subscription
    Check HTTP Response Status Code Is    204
    