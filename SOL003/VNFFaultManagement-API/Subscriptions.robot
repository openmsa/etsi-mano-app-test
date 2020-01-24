*** Settings ***
Resource    environment/variables.txt 
Resource    FaultManagement-APIKeyword.robot
Library    DependencyLibrary    
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new Fault Management alarm subscription
    [Documentation]    Test ID: 7.3.5.3.1
    ...    Test title: Create a new Fault Management alarm subscription
    ...    Test objective: The objective is to create a new Fault management alarm subscriptions and perform a JSON schema and content validation of the returned fault management alarms subscription data structure
    ...    Pre-conditions: No subscription with the same filter and callbackUri exists
    ...    Reference: clause 7.4.4.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:   Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: subscription is created
    POST Subscription
    Check HTTP Response Status Code Is    201
    Check Operation Occurrence Id
    Check HTTP Response Body Json Schema Is  FmSubscription
    Check created Subscription existance 
  

Create a new alarm subscription - DUPLICATION
     [Documentation]    Test ID: 7.3.5.3.2
    ...    Test title: Create a new alarm subscription - DUPLICATION
    ...    Test objective: The objective is to create a new subscription with the VNF allowing duplication and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: clause 7.4.4.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:   Config_prod_VNFM
    ...    Applicability: the NFVO allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: duplicated subscription is created
    POST Subscription Duplication permitted
    Check HTTP Response Status Code Is    201
    Check Operation Occurrence Id
    Check HTTP Response Body Json Schema Is  FmSubscription
    Check Postcondition FaultManagement Subscription Is Set

Create a new alarm subscription - NO DUPLICATION
    [Documentation]    Test ID: 7.3.5.3.3
    ...    Test title: Create a new alarm subscription - NO DUPLICATION
    ...    Test objective: The objective is to create a new subscription with the VNF not allowing duplication and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: clause 7.4.4.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:   Config_prod_VNFM
    ...    Applicability: the NFVO decides to not create a duplicate subscription resource 
    ...    Post-Conditions: duplicated subscription is not created
    POST Subscription Duplication not permitted
    Check HTTP Response Status Code Is    303
    Check Operation Occurrence Id
    Check Postcondition Subscription Resource Returned in Location Header Is Available

Retrieve a list of alarm subscriptions
    [Documentation]    Test ID: 7.3.5.3.4
    ...    Test title: Retrieve a list of alarm subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: none
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:   Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: noe
    GET Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscriptions
    
Retrieve a list of alarm subscriptions with filter
    [Documentation]    Test ID: 7.3.5.3.5
    ...    Test title: Retrieve a list of alarm subscriptions with filter
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter and perform a JSON schema and content validation of the returned fault management alarms subscription data structure.
    ...    Pre-conditions: none 
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:   Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FmSubscriptions
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.5.3.6
    ...    Test title: GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters and perform a JSON schema and content validation of the returned problem details data structure.
    ...    Pre-conditions: none
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:   Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions:    none 
    GET Subscriptions with Invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET subscriptions with "all_fields" attribute selector
    [Documentation]    Test ID: 7.3.5.3.7
    ...    Test title: GET subscriptions with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions 

GET subscriptions with "exclude_default" attribute selector
    [Documentation]    Test ID: 7.3.5.3.8
    ...    Test title: GET subscriptions with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions

GET subscriptions with "fields" attribute selector
    [Documentation]    Test ID: 7.3.5.3.9
    ...    Test title: GET subscriptions with "fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions

GET subscriptions with "exclude_fields" attribute selector
    [Documentation]    Test ID: 7.3.5.3.10
    ...    Test title: GET subscriptions with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions  
    
PUT subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.5.3.11
    ...    Test title:PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to for Fault management subscriptions on VNF 
    ...    Pre-conditions: none
    ...    RReference: clause 7.4.4.3.3 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:  Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none
    Put Subscriptions
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.5.3.12
    ...    Test title: PATCH subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to for Fault management subscriptions on VNF  
    ...    Pre-conditions: none
    ...    Reference: clause 7.4.4.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:  Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none
    PATCH Subscriptions
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.5.3.13
    ...    Test title: DELETE subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to for Fault management subscriptions on VNF  
    ...    Pre-conditions: none 
    ...    Reference: clause 7.4.4.3.5 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID:  Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: subscription is not deleted
    DELETE Subscriptions
    Check HTTP Response Status Code Is    405
