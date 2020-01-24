*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/reports.txt
Resource          NSPerformanceManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
Get Individual Performance Report
    [Documentation]    Test ID: 5.3.4.3.1
    ...    Test title: Get Individual Performance Report
    ...    Test objective: The objective is to test the retrieval of an individual NS performance report associated to a monitoring job and perform a JSON schema validation of the collected report data structure
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance reports are set for a monitoring job in the NFVO.
    ...    Reference: clause 7.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual Performance Report
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PerformanceReport

Get Individual Performance Report with invalid resource endpoint
    [Documentation]    Test ID: 5.3.4.3.2
    ...    Test title: Get Individual Performance Report with invalid resource endpoint
    ...    Test objective:  The objective is to test that the retrieval of an individual NS performance report associated to a monitoring job fails when using an invalid resource endpoint 
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance reports are set for a monitoring job in the NFVO.
    ...    Reference: clause 7.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual Performance Report with invalid resource endpoint
    Check HTTP Response Status Code Is    404

POST Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 5.3.4.3.3
    ...    Test title: POST Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new NS performance report within a monitoring job
    ...    Pre-conditions: A NS instance is instantiated.
    ...    Reference: clause 7.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance report is not created on the NFVO
    Send Post request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Individual Performance Report is not Created

PUT Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 5.3.4.3.4
    ...    Test title: PUT Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing NS performance report within a monitoring job
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance reports are set for a monitoring job in the NFVO.
    ...    Reference: clause 7.4.4.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance report is not modified by the operation
    Send Put request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Individual Performance Report is Unmodified (Implicit)

PATCH Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 5.3.4.3.5
    ...    Test title: PATCH Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing NS performance report within a monitoring job
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance reports are set for a monitoring job in the NFVO.
    ...    Reference: clause 7.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance report is not modified by the operation
    Send Patch request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Individual Performance Report is Unmodified (Implicit)

DELETE Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 5.3.4.3.6
    ...    Test title: DELETE Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete an existing NS performance report within a monitoring job
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance reports are set for a monitoring job in the NFVO.
    ...    Reference: clause 7.4.4.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance report is not deleted by the operation
    Send Delete request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Individual Performance Report Exists

