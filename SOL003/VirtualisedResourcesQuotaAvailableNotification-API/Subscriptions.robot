*** Settings ***
Resource    environment/variables.txt 
Resource    VRQANOperationKeywords.robot 
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/



*** Test Cases ***
Create a new subscription
    [Documentation]    Test ID: 7.3.7.1.1
    ...    Test title: Create a new subscription related to the availability of the virtualised resources quotas
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Post subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription.schema.json
    

Create a new Subscription - DUPLICATION
    [Documentation]    Test ID: 7.3.7.1.2
    ...    Test title: Create a new resource quota subscription - DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: none
    Do Post subscription - DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription.schema.json
    
Create a new Subscription - NO-DUPLICATION
    [Documentation]    Test ID: 7.3.7.1.3
    ...    Test title: Create a new resource quota subscription - NO DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM decides to not create a duplicate subscription resource 
    ...    Post-Conditions: none
    Do Post subscription - NO-DUPLICATION
    Check HTTP Response Status Code Is    303
    Check HTTP Response Header Contains    Location

GET Subscriptions
    [Documentation]    Test ID: 7.3.7.1.4
    ...    Test title: Retrieve a list of resource quota subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions
    ...    Pre-conditions: none
    ...    Reference: section 11.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    Do Get Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   subscriptions.schema.json

GET Subscription - Filter
    [Documentation]    Test ID: 7.3.7.1.5
    ...    Test title: Retrieve a list of resource quota subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter
    ...    Pre-conditions: none
    ...    Reference: section 11.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    Do Get Subscriptions - Filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscriptions.schema.json
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.7.1.6
    ...    Test title: Retrieve a list of resource quota subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters
    ...    Pre-conditions: none
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none 
    ...    Post-Conditions: none
    DO Get subscriptions - Bad Request Invalid attribute-based filtering parameters 
    Check HTTP Response Status Code Is    400
    Check HTTP Response Header ContentType is  ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
    
PUT subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.7
    ...    Test title: Put  Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update  existing subscriptions instance on NFV 
    ...    Pre-conditions: A NFV instance is instantiated
    ...    Reference:  section 11.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Put subscription   
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.8
    ...    Test title: Patch Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify subscriptions instance on NFV 
    ...    Pre-conditions: A NFV instance is instantiated
    ...    Reference:  section 11.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Patch subscription   
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.9
    ...    Test title: Patch Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to delete  subscriptions instance on NFV 
    ...    Pre-conditions: A NFV instance is instantiated
    ...    Reference:  section 11.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Do Delete subscription   
    Check HTTP Response Status Code Is    405

    