*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfIndicatorinVnfInstance.txt
Resource          VNFIndicatorsKeywords.robot
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false

*** Test Cases ***
*** Test Cases ***
Get Indicators for VNF Instance
    [Documentation]    Test ID: 7.3.6.2.1
    ...    Test title: Get Indicators for VNF Instance
    ...    Test objective: The objective is to test the retrieval of all indicators for a given VNF instance and perform a JSON schema validation of the returned indicators data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference:  section 8.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all indicators for a VNF instance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body Includes Requested VNF Instances ID

GET Indicators for VNF Instance with attribute-based filter
    [Documentation]    Test ID: 7.3.6.2.2
    ...    Test title: GET Indicators for VNF Instance with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of all indicators for a given VNF instance using attribute-based filter and perform a JSON schema validation of the returned indicators data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference: section 8.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all indicators for a VNF instance with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body vnfIndicators Matches the requested attribute-based filter

Get Indicators for VNF Instance with invalid attribute-based filter
    [Documentation]    Test ID: 7.3.6.2.3
    ...    Test title: Get Indicators for VNF Instance with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of all indicators for a given VNF instance fails using invalid attribute-based filter. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference: section 8.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all indicators for a VNF instance with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get Indicators for VNF Instance with invalid resource identifier
    [Documentation]    Test ID: 7.3.6.2.4
    ...    Test title: Get Indicators for VNF Instance with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of all indicators for a given VNF instance fails when using invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference: section 8.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get all indicators for a VNF instance with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.2.5
    ...    Test title: POST Indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 8.4.3.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405

PUT Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.2.6
    ...    Test title: PUT Indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify existing indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference: section 8.4.3.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405

PATCH Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.2.7
    ...    Test title: PATCH Indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update existing indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference: section 8.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405

DELETE Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.2.8
    ...    Test title: DELETE Indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF indicators are available in the VNFM for the given VNF instance.
    ...    Reference: section 8.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The indicators for the VNF instance are not deleted by the unsuccessful operation
    Send DELETE Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405
    Check Postcondition Indicators for VNF instance Exist
