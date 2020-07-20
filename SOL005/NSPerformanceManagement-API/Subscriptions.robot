*** Settings ***
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          NSPerformanceManagementKeywords.robot
Library           OperatingSystem
Library           JSONSchemaLibrary    schemas/
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Get All NS Performance Subscriptions
    [Documentation]    Test ID: 5.3.4.6.1
    ...    Test title: Get All NS Performance Subscriptions
    ...    Test objective: The objective is to test the retrieval of all NS Performance subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get all NS Performance Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions


Get NS Performance Subscriptions with attribute-based filter
    [Documentation]    Test ID: 5.3.4.6.2
    ...    Test title: Get NS Performance Subscriptions with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of NS Performance subscriptions using attribute-based filter, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get NS Performance Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter


Get NS Performance Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 5.3.4.6.3
    ...    Test title: Get NS Performance Subscriptions with attribute-based filters
    ...    Test objective: The objective is to test that the retrieval of NS Performance subscriptions fails when using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get NS Performance Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 


GET NS Performance Subscription with invalid resource endpoint
    [Documentation]    Test ID: 5.3.4.6.4
    ...    Test title: GET NS Performance Subscription with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all NS Performance subscriptions fails when using invalid resource endpoint.
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get NS Performance Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    

Create new NS Performance subscription
    [Documentation]    Test ID: 5.3.4.6.5
    ...    Test title: Create new NS Performance subscription
    ...    Test objective: The objective is to test the creation of a new NS Performance subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: none
    ...    Reference: Clause 7.4.7.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance subscription is successfully set and it matches the issued subscription
    Send Post Request for NS Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body PmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition NS Performance Subscription Is Set
    

Create duplicated NS Performance subscription with NFVO not creating duplicated subscriptions
    [Tags]    no-duplicated-subs
    [Documentation]    Test ID: 5.3.4.6.6
    ...    Test title: Create duplicated NS Performance subscription with NFVO not creating duplicated subscriptions
    ...    Test objective: The objective is to test the attempt of a creation of a duplicated NS Performance subscription and check that no new subscription is created by the NFVO and a link to the original subscription is returned
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO does not support the creation of duplicated subscriptions
    ...    Post-Conditions: The existing NS Performance subscription returned is available in the NFVO
    Send Post Request for Duplicated NS Performance Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource URI Returned in Location Header Is Available

Create duplicated NS Performance subscription with NFVO creating duplicated subscriptions
    [Tags]    duplicated-subs
    [Documentation]    Test ID: 5.3.4.6.7
    ...    Test title: Create duplicated NS Performance subscription with NFVO creating duplicated subscriptions
    ...    Test objective: The objective is to test the creation of a duplicated NS Performance subscription and perform a JSON schema and content validation of the returned duplicated subscription data structure
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the creation of duplicated subscriptions
    ...    Post-Conditions: The duplicated NS Performance subscription is successfully set and it matches the issued subscription    
    Send Post Request for Duplicated NS Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body PmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition NS Performance Subscription Is Set 


PUT NSD Performance Subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.4.6.8
    ...    Test title: PUT NS Performance Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify NS Performance subscriptions
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put Request for NS Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
    
PATCH NSD Performance Subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.4.6.9
    ...    Test title: PATCH NS Performance Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update NS Performance subscriptions
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Patch Request for NS Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE NSD Performance Subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.4.6.10
    ...    Test title: DELETE NS Performance Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete NS Performance subscriptions
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance subscriptions are not deleted by the failed operation 
    Send Delete Request for NS Performance Subscriptions
    Check HTTP Response Status Code Is    405

Get All NS Performance Subscriptions as Paged Response
    [Documentation]    Test ID: 5.3.4.6.11
    ...    Test title: Get All NS Performance Subscriptions as Paged Response
    ...    Test objective: The objective is to test the retrieval of all NS Performance subscriptions as paged response.
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get all NS Performance Subscriptions
    Check HTTP Response Status Code Is    200
    Check LINK in Header

Get NS Performance Subscriptions - Bad Request Response too Big
    [Documentation]    Test ID: 5.3.4.6.12
    ...    Test title: Get NS Performance Subscriptions - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of NS Performance subscriptions fails because response is too big, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference: Clause 7.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all NS Performance Subscriptions
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails