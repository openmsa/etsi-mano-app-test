*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

Suite Setup    Check subscription existance 

*** Test Cases ***
Post Individual Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.2.16.1
    ...    Test title: POST Individual NS lifecycle management subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NS lifecycle management subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.17.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not created on the NFVO
    POST Individual Subscription
    Check HTTP Response Status Code Is    405

Get Information about an individual subscription
     [Documentation]    Test ID: 5.3.2.16.2
    ...    Test title: GET Individual NS lifecycle management subscription
    ...    Test objective: The objective is to test the retrieval of NS lifecycle management subscription and perform a JSON schema validation of the returned subscription data structure
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.17.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   subscription

PUT an individual subscription - Method not implemented
     [Documentation]    Test ID: 5.3.2.16.3
    ...    Test title: PUT Individual NS lifecycle management subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a NS lifecycle management subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.17.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not modified by the operation
    PUT Individual Subscription
    Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
     [Documentation]    Test ID: 5.3.2.16.4
    ...    Test title: PATCH Individual NS lifecycle management subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify a new NS lifecycle management subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.17.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not modified by the operation
    PATCH Individual Subscription
    Check HTTP Response Status Code Is    405
    
DELETE an individual subscription
     [Documentation]    Test ID: 5.3.2.16.5
    ...    Test title: POST Individual NS lifecycle management subscription - Method not implemented
    ...    Test objective: The objective is to test the deletion of an individual NS lifecycle management subscription
    ...    Pre-conditions: At least one lifecycle management subscription is available in the NFVO
    ...    Reference:  section 6.4.17.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not available anymore on NFVO
    DELETE Individual Subscription
    Check HTTP Response Status Code Is    204