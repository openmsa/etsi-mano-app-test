*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Resource          VNFPackageManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Individual VNF Package Subscription
    [Documentation]    Test ID: 7.3.3.7.1
    ...    Test title: GET Individual VNF Package Subscription
    ...    Test objective: The objective is to test the retrieval of individual VNF package subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.8.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual VNF Package Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PkgmSubscription
    Check HTTP Response Body Subscription Identifier matches the requested Subscription

GET Individual VNF Package Subscription with invalid resource identifier
    [Documentation]    Test ID: 7.3.3.7.2
    ...    Test title: GET Individual VNF Package Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package subscription fails when using an invalid resource identifier
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.8.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual VNF Package Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual VNF Package Subscription with invalid resource identifier
    [Documentation]    Test ID: 7.3.3.7.3
    ...    Test title: DELETE Individual VNF Package Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual VNF package subscription fails when using an invalid resource identifier
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.8.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete request for individual VNF Package Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual VNF Package Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.3.7.4
    ...    Test title: POST Individual VNF Package Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF Package Subscription
    ...    Pre-conditions: none
    ...    Reference:  section 10.4.8.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package Subscription is not created on the NFVO
    Send Post request for individual VNF Package Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Subscription is not Created

PUT Individual VNF Package Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.3.7.5
    ...    Test title: PUT Individual VNF Package Subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing VNF Package subscription
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.8.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package subscription is not modified by the operation
    Send Put request for individual VNF Package Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Subscription is Unmodified (Implicit)

PATCH Individual VNF Package Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.3.7.6
    ...    Test title: PATCH Individual VNF Package Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing VNF Package subscription
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.8.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package subscription is not modified by the operation
    Send Patch request for individual VNF Package Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Subscription is Unmodified (Implicit)

DELETE Individual VNF Package Subscription
    [Documentation]    Test ID: 7.3.3.7.7
    ...    Test title: DELETE Individual VNF Package Subscription
    ...    Test objective: The objective is to test the deletion of an individual VNF package subscription
    ...    Pre-conditions: At least one VNF package subscription is available in the NFVO.
    ...    Reference:  section 10.4.8.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package Subscription is not available anymore in the NFVO    
    Send Delete request for individual VNF Package Subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition VNF Package Subscription is Deleted