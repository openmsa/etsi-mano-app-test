*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          NSDManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           Process
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Get All NSD Management Subscriptions
    [Documentation]    Test ID: 5.3.1.7.1
    ...    Test title: Get All NSD Management Subscriptions
    ...    Test objective: The objective is to test the retrieval of all NSD Management subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get all NSD Management Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdmSubscriptions
    

Get NSD Management Subscriptions with attribute-based filter
    [Documentation]    Test ID: 5.3.1.7.2
    ...    Test title: Get NSD Management Subscriptions with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of NSD Management subscriptions using attribute-based filter, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get NSD Management Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdmSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    

Get NSD Management Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 5.3.1.7.3
    ...    Test title: Get NSD Management Subscriptions with attribute-based filters
    ...    Test objective: The objective is to test that the retrieval of NSD Management subscriptions fails when using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get NSD Management Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 

GET NSD Management Subscription with invalid resource endpoint
    [Documentation]    Test ID: 5.3.1.7.4
    ...    Test title: GET NSD Management Subscription with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all NSD Management subscriptions fails when using invalid resource endpoint.
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get NSD Management Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    
Create new NSD Management subscription
    [Documentation]    Test ID: 5.3.1.7.5
    ...    Test title: Create new NSD Management subscription
    ...    Test objective: The objective is to test the creation of a new NSD Management subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.8.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD Management subscription is successfully set and it matches the issued subscription
    Send Post Request for NSD Management Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    NsdmSubscription
    Check HTTP Response Body NsdmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition NSD Management Subscription Is Set 
    

Create duplicated NSD Management subscription with NFVO not creating duplicated subscriptions
    [Tags]    no-duplicated-subs
    [Documentation]    Test ID: 5.3.1.7.6
    ...    Test title: Create duplicated NSD Management subscription with NFVO not creating duplicated subscriptions
    ...    Test objective: The objective is to test the attempt of a creation of a duplicated NSD Management subscription and check that no new subscription is created by the NFVO and a link to the original subscription is returned
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO does not support the creation of duplicated subscriptions
    ...    Post-Conditions: The existing NSD Management subscription returned is available in the NFVO
    Send Post Request for Duplicated NSD Management Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource Returned in Location Header Is Available


Create duplicated NSD Management subscription with NFVO creating duplicated subscriptions
    [Tags]    duplicated-subs
    [Documentation]    Test ID: 5.3.1.7.7
    ...    Test title: Create duplicated NSD Management subscription with NFVO creating duplicated subscriptions
    ...    Test objective: The objective is to test the creation of a duplicated NSD Management subscription and perform a JSON schema and content validation of the returned duplicated subscription data structure
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the creation of duplicated subscriptions
    ...    Post-Conditions: The duplicated NSD Management subscription is successfully set and it matches the issued subscription    
    Send Post Request for Duplicated NSD Management Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    NsdmSubscription
    Check HTTP Response Body NsdmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition NSD Management Subscription Is Set 


PUT NSD Management Subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.1.7.8
    ...    Test title: PUT NSD Management Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify NSD Management subscriptions
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put Request for NSD Management Subscriptions
    Check HTTP Response Status Code Is    405
    
    
PATCH NSD Management Subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.1.7.9
    ...    Test title: PATCH NSD Management Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update NSD Management subscriptions
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch Request for NSD Management Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE NSD Management Subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.1.7.10
    ...    Test title: DELETE NSD Management Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete NSD Management subscriptions
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference: clause 5.4.8.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD Management subscriptions are not deleted by the failed operation 
    Send Delete Request for NSD Management Subscriptions
    Check HTTP Response Status Code Is    405
    Check Postcondition NSD Management Subscriptions Exists
    
