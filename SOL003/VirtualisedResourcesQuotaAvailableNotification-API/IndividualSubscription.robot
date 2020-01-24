*** Settings ***
Resource    environment/variables.txt
Resource    VRQANOperationKeywords.robot 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Documentation    This resource represents an individual subscription. The client can use this resource to read and to terminate a
...    subscription to notifications related to the availability of the virtualised resources quotas.
Suite Setup    Check Individual Subscription existance

*** Test Cases ***
Create new Virtualised Resources Quota Available Notification individual subscription
    [Documentation]    Test ID: 7.3.7.2.1
    ...    Test title: Create new Virtualised Resources Quota Available Notification individual subscription
    ...    Test objective: The objective is to test that POST method is not allowed to create a new Virtualised Resources Quota Available Notification individual subscription instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 11.4.3.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Post request for Virtualised Resources Quota Available Notification Individual Subscription
    Check HTTP Response Status Code Is    405

Get Information about an individual subscription
    [Documentation]    Test ID: 7.3.7.2.2
    ...    Test title: Get Information about an individual subscription
    ...    Test objective: The objective is to read an individual Virtualised Resources Quota Available Notification subscription subscribed by the client and perform a JSON schema and content validation of the returned individual subscription data structure 
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: clause 11.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none 
    ...    Post-Conditions: none
    Get Virtualised Resources Quota Available Notification individual subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription

PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 7.3.7.2.3
    ...    Test title: PUT an individual subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update a existing Virtualised Resources Quota Available Notification individual subscription instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 11.4.3.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Put Virtualised Resources Quota Available Notification individual Subscription
    Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 7.3.7.2.4
    ...    Test title: PATCH an individual subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify a existing Virtualised Resources Quota Available Notification individual subscription instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 11.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Patch Virtualised Resources Quota Available Notification individual subscription
    Check HTTP Response Status Code Is    405
    
DELETE an individual subscription
        [Documentation]    Test ID: 7.3.7.2.5
    ...    Test title: DELETE an individual subscription
    ...    Test objective: The objective is to test that Delete method is allowed to remove a existing Virtualised Resources Quota Available Notification individual subscription instance on VNF  
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: clause 11.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Delete Virtualised Resources Quota Available Notification individual subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition VNF Virtualised Resources Quota Available Notification individual Subscriptions is Deleted
    