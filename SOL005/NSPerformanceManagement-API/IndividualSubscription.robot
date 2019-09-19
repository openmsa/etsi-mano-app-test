*** Settings ***
Documentation     This resource represents an individual subscription for notifications about performance management related events.
...               The client can use this resource to read and to terminate a subscription to notifications related to NS performance
...               management.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          NSPerformanceManagementKeywords.robot
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           OperatingSystem
Library           JSONLibrary
Resource          environment/individualSubscription.txt

*** Test Cases ***
GET Individual NS Performance Subscription
    [Documentation]    Test ID: 5.3.4.7.1
    ...    Test title: GET Individual NS Performance Subscription
    ...    Test objective: The objective is to test the retrieval of individual NS Performance subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference:  section 7.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual NS Performance Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PkgmSubscription
    Check HTTP Response Body Subscription Identifier matches the requested Subscription

GET Individual NS Performance Subscription with invalid resource identifier
    [Documentation]    Test ID: 5.3.4.7.2
    ...    Test title: GET Individual NS Performance Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual NS Performance subscription fails when using an invalid resource identifier
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference:  section 7.4.8.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual NS Performance Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual NS Performance Subscription with invalid resource identifier
    [Documentation]    Test ID: 5.3.4.7.3
    ...    Test title: DELETE Individual NS Performance Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual NS Performance subscription fails when using an invalid resource identifier
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference:  section 7.4.8.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete request for individual NS Performance Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual NS Performance Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.4.7.4
    ...    Test title: POST Individual NS Performance Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NS Performance Subscription
    ...    Pre-conditions: none
    ...    Reference:  section 7.4.8.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance Subscription is not created on the NFVO
    Send Post request for individual NS Performance Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Performance Subscription is not Created

PUT Individual NS Performance Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.4.7.5
    ...    Test title: PUT Individual NS Performance Subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing NS Performance subscription
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference:  section 7.4.8.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance subscription is not modified by the operation
    Send Put request for individual NS Performance Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Performance Subscription is Unmodified (Implicit)

PATCH Individual NS Performance Subscription - Method not implemented
    [Documentation]    Test ID: 5.3.4.7.6
    ...    Test title: PATCH Individual NS Performance Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing NS Performance subscription
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference:  section 7.4.8.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance subscription is not modified by the operation
    Send Patch request for individual NS Performance Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Performance Subscription is Unmodified (Implicit)

DELETE Individual NS Performance Subscription
    [Documentation]    Test ID: 5.3.4.7.7
    ...    Test title: DELETE Individual NS Performance Subscription
    ...    Test objective: The objective is to test the deletion of an individual NS Performance subscription
    ...    Pre-conditions: At least one NS Performance subscription is available in the NFVO.
    ...    Reference:  section 7.4.8.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS Performance Subscription is not available anymore in the NFVO    
    Send Delete request for individual NS Performance Subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition NS Performance Subscription is Deleted