*** Settings ***
Resource    environment/variables.txt 
Resource    VRQANOperationKeywords.robot 
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/



*** Test Cases ***
Create new Virtualised Resources Quota Available Notification subscription
    [Documentation]    Test ID: 7.3.7.1.1
    ...    Test title: Create new Virtualised Resources Quota Available Notification subscription
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Post request for new Virtualised Resources Quota Available Notification subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    application/json
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription
    

Create new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    [Documentation]    Test ID: 7.3.7.1.2
    ...    Test title: Create new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: none
    Send Post request for new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is    application/json
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription
    
Create new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    [Documentation]    Test ID: 7.3.7.1.3
    ...    Test title: Create new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM decides to not create a duplicate subscription resource 
    ...    Post-Conditions: none
    Send Post request for new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    Check HTTP Response Status Code Is    303
    Check HTTP Response Header Contains    Location

GET Virtualised Resources Quota Available Notification Subscriptions
    [Documentation]    Test ID: 7.3.7.1.4
    ...    Test title: GET Virtualised Resources Quota Available Notification Subscriptions 
    ...    Test objective: The objective is to retrieve the list of active subscriptions
    ...    Pre-conditions: none
    ...    Reference: section 11.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Virtualised Resources Quota Available Notification Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   subscriptions

GET Virtualised Resources Quota Available Notification Subscriptions with attribute-based Filter
    [Documentation]    Test ID: 7.3.7.1.5
    ...    Test title: GET Virtualised Resources Quota Available Notification Subscriptions with attribute-based Filter
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter
    ...    Pre-conditions: none
    ...    Reference: section 11.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Virtualised Resources Quota Available Notification Subscriptions with Filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscriptions
    
GET Virtualised Resources Quota Available Notification subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.7.1.6
    ...    Test title: GET Virtualised Resources Quota Available Notification subscriptions - Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters
    ...    Pre-conditions: none
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none 
    ...    Post-Conditions: none
    Get Virtualised Resources Quota Available Notification subscriptions with Bad Request Invalid attribute-based filtering parameters 
    Check HTTP Response Status Code Is    400
    Check HTTP Response Header ContentType is  application/json
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.7
    ...    Test title: PUT Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update  existing subscriptions instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference:  section 11.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put request for Virtualised Resources Quota Available Notification subscription   
    Check HTTP Response Status Code Is    405

PATCH Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.8
    ...    Test title: PATCH Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify subscriptions instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference:  section 11.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch request for Virtualised Resources Quota Available Notification subscription   
    Check HTTP Response Status Code Is    405

DELETE Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.9
    ...    Test title: DELETE Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to delete  subscriptions instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference:  section 11.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Delete request for Virtualised Resources Quota Available Notification subscription   
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Virtualised Resources Quota Available Notification Subscriptions Exists

    