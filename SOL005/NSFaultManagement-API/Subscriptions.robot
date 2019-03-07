*** Settings ***
Resource    environment/variables.txt
Resource   NSFMOperationKeywords.robot  
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library     OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new subscription
    [Documentation]    Test ID: 8.4.4.1
    ...    Test title: Create a new alarm subscription
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:  
    ...    Applicability: 
    ...    Post-Conditions: 
    Do POST Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is  FmSubscription.schema.json
  

Create a new Subscription - DUPLICATION
     [Documentation]    Test ID: 8.4.4.1-2
    ...    Test title: Create a new alarm subscription - DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:  
    ...    Applicability: the NFVO allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: 
    Depends On Test    Create a new subscription
    Pass Execution If    ${NFVO_DUPLICATION} == 0    NVFO is not permitting duplication. Skipping the test
    Do POST Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is  FmSubscription.schema.json

Create a new Subscription - NO-DUPLICATION
    [Documentation]    Test ID: 8.4.4.1-3
    ...    Test title: Create a new alarm subscription - NO DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:  
    ...    Applicability: the NFVO decides to not create a duplicate subscription resource 
    ...    Post-Conditions:
    Depends On Test    Create a new subscription
    Pass Execution If    ${NFVO_DUPLICATION} == 1    NFVO permits duplication. Skipping the test
    Do POST Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is  FmSubscription.schema.json

GET Subscriptions
    [Documentation]    Test ID: 8.4.4.2
    ...    Test title: Retrieve a list of alarm subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions
    ...    Pre-conditions: 
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:  
    ...    Applicability:  
    ...    Post-Conditions: 
    Do GET Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscriptions.schema.json
    
GET Subscription - Filter
    [Documentation]    Test ID: 8.4.4.2-1
    ...    Test title: Retrieve a list of alarm subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter
    ...    Pre-conditions: 
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:  
    ...    Applicability:  
    ...    Post-Conditions: 
    Do GET Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscriptions.schema.json
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 8.4.4.2-2
    ...    Test title: Retrieve a list of alarm subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:  
    ...    Applicability:  
    ...    Post-Conditions:     
    Do GET Subscriptions with Invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
PUT subscriptions - Method not implemented
    [Documentation]    Test ID: 8.4.4.3
    ...    Test title:PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to PUT subscriptions 
    ...    Pre-conditions: 
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do Put Subscriptions
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 8.4.4.4
    ...    Test title:PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to PATCH subscriptions 
    ...    Pre-conditions: 
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do PATCH Subscriptions
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 8.4.4.5
    ...    Test title:DELETE subscriptions - Method not implemented
    ...    Test objective: The objective is to DELETE subscriptions 
    ...    Pre-conditions: 
    ...    Reference: section 8.4.4 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:
    Do DELETE Subscriptions
    Check HTTP Response Status Code Is    405