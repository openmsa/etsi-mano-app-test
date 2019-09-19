*** Settings ***
Documentation     This resource represents an individual threshold.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          NSPerformanceManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           OperatingSystem
Resource          environment/individualThresholds.txt

*** Test Cases ***
GET Individual Threshold
    [Documentation]    Test ID: 5.3.4.5.1
    ...    Test title: GET Individual Threshold
    ...    Test objective: The objective is to test the retrieval of an individual NS performance threshold and perform a JSON schema and content validation of the collected threshold data structure
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: section 7.4.6.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual NS performance Threshold
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Threshold
    Check HTTP Response Body Threshold Identifier matches the requested Threshold

GET Individual Threshold with invalid resource identifier
    [Documentation]    Test ID: 5.3.4.5.2
    ...    Test title: GET Individual Threshold with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual NS performance threshold fails when using an invalid resource identifier
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance jobs are set in the NFVO.
    ...    Reference: section 7.4.6.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual NS performance Threshold with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual Threshold with invalid resource identifier
    [Documentation]    Test ID: 5.3.4.5.3
    ...    Test title: DELETE Individual Threshold with invalid resource identifier
    ...    Test objective: The objective is to test the deletion of an individual NS performance threshold
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: section 7.4.6.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete request for individual NS performance Threshold with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual Threshold - Method not implemented
    [Documentation]    Test ID: 5.3.4.5.4
    ...    Test title: POST Individual Threshold - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NS performance Threshold
    ...    Pre-conditions: A NS instance is instantiated
    ...    Reference: section 7.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance Threshold is not created on the NFVO
    Send Post request for individual NS performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition NS performance Threshold is not Created

PUT Individual Threshold - Method not implemented
    [Documentation]    Test ID: 5.3.4.5.5
    ...    Test title: PUT Individual Threshold - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing NS performance threshold
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: section 7.4.6.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance Threshold is not modified by the operation
    Send Put request for individual NS performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition NS performance Threshold is Unmodified (Implicit)

PATCH Individual Threshold - Method not implemented
    [Documentation]    Test ID: 5.3.4.5.6
    ...    Test title: PATCH Individual Threshold - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing NS performance threshold
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: section 7.4.6.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance Threshold is not modified by the operation
    Send Patch request for individual NS performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition NS performance Threshold is Unmodified (Implicit)

DELETE Individual Threshold
    [Documentation]    Test ID: 5.3.4.5.7
    ...    Test title: DELETE Individual Threshold
    ...    Test objective: The objective is to test the deletion of an individual NS performance threshold
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: section 7.4.6.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance Threshold is not available anymore in the NFVO    
    Send Delete request for individual NS performance Threshold
    Check HTTP Response Status Code Is    204
    Check Postcondition NS performance Threshold is Deleted

