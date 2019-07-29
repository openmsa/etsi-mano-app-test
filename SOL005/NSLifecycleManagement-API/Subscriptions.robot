*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Create a new subscription
    [Documentation]    Test ID: 5.3.2.15.1
    ...    Test title: POST Create a new subscription
    ...    Test objective: The objective is to test that POST method create a subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.16.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: subscription is created in the NFVO     
    POST subscriptions
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    subscription
    

POST Create a new Subscription - DUPLICATION
    [Documentation]    Test ID: 5.3.2.15.2
    ...    Test title: POST Create a new subscription - DUPLICATION
    ...    Test objective: The objective is to test that POST method create a duplicate subscription if  NFVO is permitting duplication
    ...    Pre-conditions: a subscription have already to exist
    ...    Reference:  section 6.4.16.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: duplicate subscription is created in the NFVO     
    POST subscriptions DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    subscription

POST Create a new Subscription - NO-DUPLICATION
    [Documentation]    Test ID: 5.3.2.15.3
    ...    Test title: POST Create a new subscription - NO-DUPLICATION
    ...    Test objective: The objective is to test that POST method can't create a duplicate subscription if  NFVO is not permitting duplication
    ...    Pre-conditions: a subscription have already to exist
    ...    Reference:  section 6.4.16.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: duplicate subscription is not created in the NFVO     
    POST subscriptions NO DUPLICATION
    Check HTTP Response Status Code Is    303
    Check HTTP Response Header Contains    Location

GET Subscriptions
    [Documentation]    Test ID: 5.3.2.15.4
    ...    Test title: GET Subscriptions
    ...    Test objective: The objective is to test that GET method  retrive the list of existing subscriptions
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.16.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET Subscriptions
    Check HTTP Response Status Code Is  200
    Check HTTP Response Body Json Schema Is  subscriptions

GET Subscription - Filter
    [Documentation]    Test ID: 5.3.2.15.5
    ...    Test title: GET Subscription - Filter
    ...    Test objective: The objective is to test that GET method  retrive the list of existing subscriptions
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.16.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET Subscriptions with filter
    Check HTTP Response Status Code Is  200
    Check HTTP Response Body Json Schema Is  subscriptions
    
PUT subscriptions - Method not implemented
     [Documentation]    Test ID: 5.3.2.15.6
    ...    Test title: PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a NS lifecycle management subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.16.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not modified by the operation
    PUT subscriptions
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.2.15.7
    ...    Test title: PATCH subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a NS lifecycle management subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.16.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not modified by the operation
    PATCH subscriptions
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.2.15.6
    ...    Test title: DELETE subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to modify a NS lifecycle management subscription
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.16.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS lifecycle management subscription is not deleted by the operation
    DELETE subscriptions
    Check HTTP Response Status Code Is    405