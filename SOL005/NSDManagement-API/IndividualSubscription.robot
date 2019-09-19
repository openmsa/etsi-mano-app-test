*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Resource          NSDManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
GET Individual NSD Management Subscription
    [Documentation]    Test ID: 5.3.1.8.1
    ...    Test title: GET Individual NSD Management Subscription
    ...    Test objective: The objective is to test the retrieval of individual NSD Management subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference:  section 5.4.9.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual NSD Management Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PkgmSubscription
    Check HTTP Response Body Subscription Identifier matches the requested Subscription

GET Individual NSD Management Subscription with invalid resource identifier
    [Documentation]    Test ID: 5.3.1.8.2
    ...    Test title: GET Individual NSD Management Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual NSD Management subscription fails when using an invalid resource identifier
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference:  section 5.4.9.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual NSD Management Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual NSD Management Subscription with invalid resource identifier
    [Documentation]    Test ID: 5.3.1.8.3
    ...    Test title: DELETE Individual NSD Management Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual NSD Management subscription fails when using an invalid resource identifier
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference:  section 5.4.9.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete request for individual NSD Management Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual NSD Management Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.1.8.4
    ...    Test title: POST Individual NSD Management Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NSD Management Subscription
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.9.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD Management Subscription is not created on the NFVO
    Send Post request for individual NSD Management Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition NSD Management Subscription is not Created

PUT Individual NSD Management Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.1.8.5
    ...    Test title: PUT Individual NSD Management Subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing NSD Management subscription
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference:  section 5.4.9.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD Management subscription is not modified by the operation
    Send Put request for individual NSD Management Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition NSD Management Subscription is Unmodified (Implicit)

PATCH Individual NSD Management Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.1.8.6
    ...    Test title: PATCH Individual NSD Management Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing NSD Management subscription
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference:  section 5.4.9.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD Management subscription is not modified by the operation
    Send Patch request for individual NSD Management Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition NSD Management Subscription is Unmodified (Implicit)

DELETE Individual NSD Management Subscription
    [Documentation]    Test ID: 5.3.1.8.7
    ...    Test title: DELETE Individual NSD Management Subscription
    ...    Test objective: The objective is to test the deletion of an individual NSD Management subscription
    ...    Pre-conditions: At least one NSD Management subscription is available in the NFVO.
    ...    Reference:  section 5.4.9.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD Management Subscription is not available anymore in the NFVO    
    Send Delete request for individual NSD Management Subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition NSD Management Subscription is Deleted