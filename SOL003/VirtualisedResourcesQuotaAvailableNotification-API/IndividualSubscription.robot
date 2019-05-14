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
Post Individual Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.7.2.1
    ...    Test title: Post Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new individual subscription instance on NFV 
    ...    Pre-conditions: A NFV instance is instantiated
    ...    Reference:  section 11.4.3.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Post Individual Subscription
    Check HTTP Response Status Code Is    405

Get Information about an individual subscription
    [Documentation]    Test ID: 7.3.7.2.2
    ...    Test title: Get Information about an individual subscription
    ...    Test objective: The objective is to read an individual subscription subscribed by the client
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: section 11.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none 
    ...    Post-Conditions: none
    Do Get individual subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription.schema.json

PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 7.3.7.2.3
    ...    Test title: Put Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update a existing individual subscription instance on NFV 
    ...    Pre-conditions: A NFV instance is instantiated
    ...    Reference:  section 11.4.3.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Put Individual Subscription
    Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 7.3.7.2.4
    ...    Test title: Patch Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify a existing individual subscription instance on NFV 
    ...    Pre-conditions: A NFV instance is instantiated
    ...    Reference:  section 11.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Patch Individual Subscription
    Check HTTP Response Status Code Is    405
    
DELETE an individual subscription
        [Documentation]    Test ID: 7.3.7.2.5
    ...    Test title: Delete an Individual Subscription
    ...    Test objective: The objective is to test that Delete method is allowed to remove a existing individual subscription instance on NFV 
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference:  section 11.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Delete an individual subscription 
    Check HTTP Response Status Code Is    204