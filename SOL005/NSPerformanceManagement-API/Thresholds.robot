*** Settings ***
Documentation     This resource represents thresholds. The client can use this resource to create and query thresholds.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          NSPerformanceManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Resource          environment/thresholds.txt
Library           OperatingSystem

*** Test Cases ***
GET All Performance Thresholds
    [Documentation]    Test ID: 5.3.4.4.1
    ...    Test title: GET All Performance Thresholds
    ...    Test objective: The objective is to test the retrieval of all the available NS performance thresholds and perform a JSON schema validation of the collected thresholds data structure
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Performance Thresholds
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Thresholds

GET Performance Thresholds with attribute-based filter
    [Documentation]    Test ID: 5.3.4.4.2
    ...    Test title: GET Performance Thresholds with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of all the available NS performance thresholds when using attribute-based filters, perform a JSON schema validation of the collected thresholds data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Performance Thresholds with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Thresholds
    Check HTTP Response Body Thresholds match the requested attribute-based filter

GET Performance Thresholds with invalid attribute-based filter
    [Documentation]    Test ID: 5.3.4.4.3
    ...    Test title: GET Performance Thresholds with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of NS performance thresholds fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Performance Thresholds with invalid attribute-based filter
    Check HTTP Response Status Code Is    404

GET Performance Thresholds with invalid resource endpoint
    [Documentation]    Test ID: 5.3.4.4.4
    ...    Test title: GET Performance Thresholds with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of NS performance thresholds fails when using invalid resource endpoint, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET NS performance Thresholds with invalid resource endpoint
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Create new Performance Threshold
    [Documentation]    Test ID: 5.3.4.4.5
    ...    Test title:  Create new Performance Threshold
    ...    Test objective: The objective is to test the creation of a new NS performance threshold and perform the JSON schema validation of the returned threshold data structure
    ...    Pre-conditions: A NS instance is instantiated.
    ...    Reference: clause 7.4.5.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance Threshold is successfully created on the NFVO
    Send Post Request Create new Performance Threshold
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   Threshold
    Check HTTP Response Header Contains    Location
    Check Postcondition Threshold Exists

PUT Performance Thresholds - Method not implemented
    [Documentation]    Test ID: 5.3.4.4.6
    ...    Test title: PUT Performance Thresholds - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify NS performance Thresholds
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all Performance Thresholds
    Check HTTP Response Status Code Is    405

PATCH Performance Thresholds - Method not implemented
    [Documentation]    Test ID: 5.3.4.4.7
    ...    Test title: PATCH Performance Thresholds - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify NS performance Thresholds
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all Performance Thresholds
    Check HTTP Response Status Code Is    405

DELETE Performance Thresholds - Method not implemented
    [Documentation]    Test ID: 5.3.4.4.8
    ...    Test title: DELETE Performance Thresholds - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to update NS performance Thresholds
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS performance thresholds are not deleted by the failed operation
    Send DELETE Request for all Performance Thresholds
    Check HTTP Response Status Code Is    405
    Check Postcondition Thresholds Exist
    
GET All Performance Thresholds as Paged Response
    [Documentation]    Test ID: 5.3.4.4.9
    ...    Test title: GET All Performance Thresholds as Paged Response
    ...    Test objective: The objective is to test the retrieval of all the available NS performance thresholds as paged response.
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Performance Thresholds
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
GET Performance Thresholds - Bad Request Response too Big
    [Documentation]    Test ID: 5.3.4.4.10
    ...    Test title: GET Performance Thresholds - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of NS performance thresholds fails because reponse is too big, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A NS instance is instantiated. One or more NS performance thresholds are set in the NFVO.
    ...    Reference: clause 7.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Performance Thresholds
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails