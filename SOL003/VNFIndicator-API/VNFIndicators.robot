*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/vnfIndicators.txt
Resource          VNFIndicatorsKeywords.robot
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false

*** Test Cases ***
Get all VNF Indicators
    [Documentation]    Test ID: 7.3.6.1.1
    ...    Test title: Get all VNF Indicators
    ...    Test objective: The objective is to test the retrieval of all the available VNF indicators and perform a JSON schema validation of the collected indicators data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all VNF indicators
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    
Get VNF Indicators with attribute-based filter
    [Documentation]    Test ID: 7.3.6.1.2
    ...    Test title: Get VNF Indicators with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF indicators using attribute-based filter, perform a JSON schema validation of the collected indicators data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF indicators with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body vnfIndicators Matches the requested attribute-based filter

Get VNF Indicators with invalid attribute-based filter
    [Documentation]    Test ID: 7.3.6.1.3
    ...    Test title: Get VNF Indicators with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF indicators with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get all VNF Indicators with malformed authorization token
    [Documentation]    Test ID: 7.3.6.1.4
    ...    Test title: Get all VNF Indicators with malformed authorization token
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when using malformed authorization token
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 4.5.3.3, 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all VNF indicators with malformed authorization token
    Check HTTP Response Status Code Is    400

Get all VNF Indicators without authorization token
    [Documentation]    Test ID: 7.3.6.1.5
    ...    Test title: Get all VNF Indicators without authorization token
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when omitting the authorization token
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 4.5.3.3, 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNF requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all VNF indicators without authorization token
    Check HTTP Response Status Code Is    401

GET all VNF Indicators with expired or revoked authorization token
    [Documentation]    Test ID: 7.3.6.1.6
    ...    Test title: GET all VNF Indicators with expired or revoked authorization token
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when using expired or revoked authorization token
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 4.5.3.3, 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNF requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all VNF indicators with expired or revoked authorization token
    Check HTTP Response Status Code Is    401

Get all VNF Indicators with invalid resource endpoint
    [Documentation]    Test ID: 7.3.6.1.7
    ...    Test title: Get all VNF Indicators with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when using invalid resource endpoint
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM.
    ...    Reference: section 8.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all VNF indicators with invalid resource endpoint
    Check HTTP Response Status Code Is    404

POST all VNF Indicators - Method not implemented
    [Documentation]    Test ID: 7.3.6.1.8
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM
    ...    Reference: section 8.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for all VNF indicators
    Check HTTP Response Status Code Is    405

PUT all VNF Indicators - Method not implemented
    [Documentation]    Test ID: 7.3.6.1.9
    ...    Test title: PUT all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM
    ...    Reference: section 8.4.2.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all VNF indicators
    Check HTTP Response Status Code Is    405

PATCH all VNF Indicators - Method not implemented
     [Documentation]    Test ID: 7.3.6.1.10
    ...    Test title: PATCH all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNF
    ...    Reference: section 8.4.2.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all VNF indicators
    Check HTTP Response Status Code Is    405

DELETE all VNF Indicators - Method not implemented
    [Documentation]    Test ID: 7.3.6.1.11
    ...    Test title: DELETE all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNF
    ...    Reference: section 8.4.2.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF indicators are not deleted by the unsuccessful operation
    Send DELETE Request for all VNF indicators
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicators Exist
