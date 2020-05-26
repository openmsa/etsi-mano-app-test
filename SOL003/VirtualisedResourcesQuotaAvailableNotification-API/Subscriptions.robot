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
    ...    Test objective: The objective is to create a new Virtualised Resources Quota Available Notification subscription and perform a JSON schema and content validation of the returned subscription data structure 
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: clause 11.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Post request for new Virtualised Resources Quota Available Notification subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription
    

Create new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    [Documentation]    Test ID: 7.3.7.1.2
    ...    Test title: Create new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    ...    Test objective: The objective is to create a new Virtualised Resources Quota Available Notification subscription and perform a JSON schema and content validation of the returned duplicated subscription data structure
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: clause 11.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: none
    Send Post request for new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscription
    
Create new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    [Documentation]    Test ID: 7.3.7.1.3
    ...    Test title: Create new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    ...    Test objective: The objective is to create a nduplicated Virtualised Resources Quota Available Notification subscription and verify that the VNF does not allow duplication
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: clause 11.4.2.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM decides to not create a duplicate subscription resource 
    ...    Post-Conditions: none
    Send Post request for new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    Check HTTP Response Status Code Is    303
    Check HTTP Response Header Contains    Location

GET Virtualised Resources Quota Available Notification Subscriptions
    [Documentation]    Test ID: 7.3.7.1.4
    ...    Test title: GET Virtualised Resources Quota Available Notification Subscriptions 
    ...    Test objective: The objective is to retrieve the list of active Virtualised Resources Quota Available Notification subscriptions and perform a JSON schema and content validation of the returned  subscriptions data structure
    ...    Pre-conditions: none
    ...    Reference: clause 11.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Virtualised Resources Quota Available Notification Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   subscriptions

GET Virtualised Resources Quota Available Notification Subscriptions with attribute-based Filter
    [Documentation]    Test ID: 7.3.7.1.5
    ...    Test title: GET Virtualised Resources Quota Available Notification Subscriptions with attribute-based Filter
    ...    Test objective: The objective is to retrieve the list of active Virtualised Resources Quota Available Notification subscriptions and perform a JSON schema and content validation of the returned subscriptions data structure, and verify that the retrieved information matches the issued attribute-based filters
    ...    Pre-conditions: none
    ...    Reference: clause 11.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Virtualised Resources Quota Available Notification Subscriptions with Filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VrQuotaAvailSubscriptions
    
GET Virtualised Resources Quota Available Notification subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.7.1.6
    ...    Test title: GET Virtualised Resources Quota Available Notification subscriptions - Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve the list of active Virtualised Resources Quota Available Notification subscriptions with invalid attribute-based filtering parameters, and verify that problem details are returned 
    ...    Pre-conditions: none
    ...    Reference: clause 11.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none 
    ...    Post-Conditions: none
    Get Virtualised Resources Quota Available Notification subscriptions with Bad Request Invalid attribute-based filtering parameters 
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.7
    ...    Test title: PUT Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update existing Virtualised Resources Quota Available Notification subscriptions instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 11.4.2.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put request for Virtualised Resources Quota Available Notification subscription   
    Check HTTP Response Status Code Is    405

PATCH Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.8
    ...    Test title: PATCH Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify Virtualised Resources Quota Available Notification subscriptions instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 11.4.2.3.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch request for Virtualised Resources Quota Available Notification subscription   
    Check HTTP Response Status Code Is    405

DELETE Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.7.1.9
    ...    Test title: DELETE Virtualised Resources Quota Available Notification subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to delete Virtualised Resources Quota Available Notification subscriptions instance on VNF 
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 11.4.2.3.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Delete request for Virtualised Resources Quota Available Notification subscription   
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Virtualised Resources Quota Available Notification Subscriptions Exists
    
GET Virtualised Resources Quota Available Notification Subscriptions as Paged Response
    [Documentation]    Test ID: 7.3.7.1.10
    ...    Test title: GET Virtualised Resources Quota Available Notification Subscriptions as Paged Response 
    ...    Test objective: The objective is to retrieve the list of active Virtualised Resources Quota Available Notification subscriptions as a Paged Response.
    ...    Pre-conditions: none
    ...    Reference: clause 11.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Virtualised Resources Quota Available Notification Subscriptions
    Check HTTP Response Status Code Is    200
    Check LINK in Header

GET Virtualised Resources Quota Available Notification subscriptions - Bad Request Response too Big
    [Documentation]    Test ID: 7.3.7.1.11
    ...    Test title: GET Virtualised Resources Quota Available Notification subscriptions - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of active Virtualised Resources Quota Available Notification subscriptions list fails because response is too big, and verify that problem details are returned 
    ...    Pre-conditions: none
    ...    Reference: clause 11.4.2.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none 
    ...    Post-Conditions: none
     GET Virtualised Resources Quota Available Notification Subscriptions
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails