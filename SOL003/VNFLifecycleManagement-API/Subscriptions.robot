*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Resource    VnfLcmMntOperationKeywords.robot


*** Test Cases ***
POST Create a new subscription
    [Documentation]    Test ID: 7.3.1.17.1
    ...    Test title: POST Create a new subscription
    ...    Test objective: The POST method creates a new subscription
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: in response header Location shall not be null
    ...    POST Cancel operation task
    Post Create subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    Subscription
Create a new Subscription - DUPLICATION
    [Documentation]    Test ID: 7.3.1.17.2
    ...    Test title: POST Create a new subscription - DUPLICATION
    ...    Test objective: The POST method creates a new subscription even if an existing subscription to same content exist
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: in response header Location shall not be null
    ...    POST Cancel operation task
    Post Create subscription - DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    Subscription

Create a new Subscription - NO-DUPLICATION
    [Documentation]    Test ID: 7.3.1.17.3
    ...    Test title: POST Create a new subscription - NO-DUPLICATION
    ...    Test objective: The POST method creates a new subscription even if an existing subscription to same content exist
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: in response header Location shall not be null
    ...    POST Cancel operation task
    Post Create subscription - NO-DUPLICATION
    Check HTTP Response Status Code Is    303
    Check Operation Occurrence Id
    
GET Subscriptions
     [Documentation]    Test ID: 7.3.1.17.4
    ...    Test title: GET Subscriptions
    ...    Test objective: The objective is Get the list of active subscriptions
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Subscriptions

GET Subscription - Filter
    [Documentation]    Test ID: 7.3.1.17.5
    ...    Test title: GET Subscriptions - Filter
    ...    Test objective: The objective is Get the list of active subscriptions using a filter
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get subscriptions - filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Subscriptions
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.1.17.6
    ...    Test title: GET Subscriptions - Filter
    ...    Test objective: The objective is Get the list of active subscriptions using a filter
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get subscriptions - invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.1.17.7
    ...    Test title: PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT subscriptions
	Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.1.17.8
    ...    Test title: PATCH subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PATCH subscriptions
	Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.1.17.9
    ...    Test title: DELETE subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.18.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE subscriptions
	Check HTTP Response Status Code Is    405
    