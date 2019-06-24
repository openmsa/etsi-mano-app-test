*** Settings ***
Resource    environment/variables.txt
Resource   NSFMOperationKeywords.robot  
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library     OperatingSystem
Library  DependencyLibrary
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new alarm subscription
    [Documentation]    Test ID: 5.3.3.3.1
    ...    Test title: Create a new alarm subscription
    ...    Test objective: The objective is to create a new Fault management alarm subscriptions and perform a JSON schema and content validation of the returned fault management alarms subscription data structure
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: section 8.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is  FmSubscription
  

Create a new alarm subscription - DUPLICATION
     [Documentation]    Test ID: 5.3.3.3.2
    ...    Test title: Create a new alarm subscription - DUPLICATION
    ...    Test objective: The objective is to create a new subscription with the NFV allowing duplication and perform a JSON schema and content validation of the returned fault management alarms subscription data structure..
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 8.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability: the NFVO allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: none
    Depends On Test    Create a new subscription
    Pass Execution If    ${NFVO_DUPLICATION} == 0    NVFO is not permitting duplication. Skipping the test
    POST Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is  FmSubscription

Create a new alarm subscription - NO DUPLICATION
    [Documentation]    Test ID: 5.3.3.3.3
    ...    Test title: Create a new alarm subscription - NO DUPLICATION
    ...    Test objective: The objective is to create a new subscription with the NFV not allowing duplication and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 8.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability: the NFVO decides to not create a duplicate subscription resource 
    ...    Post-Conditions: none
    Depends On Test    Create a new subscription
    Pass Execution If    ${NFVO_DUPLICATION} == 1    NFVO permits duplication. Skipping the test
    POST Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is  FmSubscription

Retrieve a list of alarm subscriptions
    [Documentation]    Test ID: 5.3.3.3.4
    ...    Test title: Retrieve a list of alarm subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: none
    ...    Reference: section 8.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscriptions
    
Retrieve a list of alarm subscriptions - Filter
    [Documentation]    Test ID: 5.3.3.3.5
    ...    Test title: Retrieve a list of alarm subscriptions - Filter
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: none
    ...    Reference: section 8.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscriptions
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.3.3.3.6
    ...    Test title: GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    ...    Test objective:The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters and perform a JSON schema and content validation of the returned problem details data structure.
    ...    Pre-conditions:  none
    ...    Reference: section 8.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:   none
    ...    Post-Conditions: none     
    GET Subscriptions with Invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.3.3.7
    ...    Test title:PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to for Fault management subscriptions on NFV 
    ...    Pre-conditions:  none
    ...    Reference: section 8.4.4.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:   none
    Put Subscriptions
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.3.3.8
    ...    Test title:PATCH subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to for Fault management subscriptions on NFV  
    ...    Pre-conditions:  none
    ...    Reference: section 8.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:   none
    PATCH Subscriptions
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]   Test ID: 5.3.3.3.9
    ...    Test title:DELETE subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to for Fault management subscriptions on NFV 
    ...    Pre-conditions:  none
    ...    Reference: section 8.4.4.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    DELETE Subscriptions
    Check HTTP Response Status Code Is    405