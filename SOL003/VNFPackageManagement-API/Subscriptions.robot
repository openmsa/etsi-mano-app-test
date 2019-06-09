*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          VNFPackageManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Get All VNF Package Subscriptions
    [Documentation]    Test ID: 7.3.3.6.1
    ...    Test title: GET all VNF Package Subscriptions
    ...    Test objective: The objective is to test the retrieval of all VNF package subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get all VNF Package Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PkgmSubscriptions


Get VNF Package Subscriptions with attribute-based filter
    [Documentation]    Test ID: 7.3.3.6.2
    ...    Test title: Get VNF Package Subscriptions with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF package subscriptions using attribute-based filter, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Package Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PkgmSubscription
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter


Get VNF Package Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 7.3.3.6.3
    ...    Test title: Get VNF Package Subscriptions with attribute-based filters
    ...    Test objective: The objective is to test that the retrieval of VNF package subscriptions fails when using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Package Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails    
    
GET VNF Package Subscription with invalid resource endpoint
    [Documentation]    Test ID: 7.3.3.6.4
    ...    Test title: GET VNF Package Subscription with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all VNF package subscriptions fails when using invalid resource endpoint.
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get VNF Package Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404

Create new VNF Package subscription
    [Documentation]    Test ID 7.3.3.6.5
    ...    Test title: Create new VNF Package subscription
    ...    Test objective: The objective is to test the creation of a new VNF package subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: none
    ...    Reference:  section 10.4.7.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF package subscription is successfully set and it matches the issued subscription    
    Send Post Request for VNF Package Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PkgmSubscription
    Check HTTP Response Body PkgmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition VNF Package Subscription Is Set 


Create duplicated VNF Package subscription with NFVO not creating duplicated subscriptions
    [Tags]    no-duplicated-subs
    [Documentation]    Test ID 7.3.3.6.6
    ...    Test title: Create duplicated VNF Package subscription with NFVO not creating duplicated subscriptions
    ...    Test objective: The objective is to test the attempt of a creation of a duplicated VNF package subscription and check that no new subscription is created by the NFVO and a link to the original subscription is returned
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO does not support the creation of duplicated subscriptions
    ...    Post-Conditions: The existing VNF package subscription returned is available in the NFVO
    Send Post Request for Duplicated VNF Package Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource Returned in Location Header Is Available

Create duplicated VNF Package subscription with NFVO creating duplicated subscriptions
    [Tags]    duplicated-subs
    [Documentation]    Test ID 7.3.3.6.7
    ...    Test title: Create duplicated VNF Package subscription with NFVO creating duplicated subscriptions
    ...    Test objective: The objective is to test the creation of a duplicated VNF package subscription and perform a JSON schema and content validation of the returned duplicated subscription data structure
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the creation of duplicated subscriptions
    ...    Post-Conditions: The duplicated VNF package subscription is successfully set and it matches the issued subscription
    Send Post Request for Duplicated VNF Package Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PkgmSubscription
    Check HTTP Response Body PkgmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition VNF Package Subscription Is Set 

PUT VNF Package Subscriptions - Method not implemented
    [Documentation]    Test ID 7.3.3.6.8
    ...    Test title: PUT VNF Package Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF package subscriptions
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put Request for VNF Package Subscriptions
    Check HTTP Response Status Code Is    405
    
PATCH VNF Package Subscriptions - Method not implemented
    [Documentation]    Test ID 7.3.3.6.9
    ...    Test title: PATCH VNF Package Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF package subscriptions
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch Request for VNF Package Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE VNF Package Subscriptions - Method not implemented
    [Documentation]    Test ID 7.3.3.6.10
    ...    Test title: DELETE VNF Package Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF package subscriptions
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.7.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF package subscriptions are not deleted by the failed operation 
    Send Delete Request for VNF Package Subscriptions
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Subscriptions Exists
