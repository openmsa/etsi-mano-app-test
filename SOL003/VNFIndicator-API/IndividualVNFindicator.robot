*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualVnfIndicator.txt
Resource          VNFIndicatorsKeywords.robot
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false

*** Test Cases ***
Get Individual Indicator for VNF Instance
    [Documentation]    Test ID: 7.3.6.3.1
    ...    Test title: Get Individual Indicator for VNF Instance
    ...    Test objective: The objective is to test the retrieval of an indicator for a given VNF instance and perform a JSON schema validation of the returned indicator data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of VNF indicator is available in the VNFM.
    ...    Reference: clause 8.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual Indicator for a VNF instance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicator
    Check HTTP Response Body Includes Requested VNF Instance ID
    Check HTTP Response Body Includes Requested Indicator ID

Get Individual Indicator for VNF Instance with invalid indicator identifier
    [Documentation]    Test ID: 7.3.6.3.2
    ...    Test title: Get Individual Indicator for VNF Instance with invalid indicator identifier
    ...    Test objective: The objective is to test that the retrieval of an indicator for a given VNF instance fails when using an invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of VNF indicator is available in the VNFM.
    ...    Reference: clause 8.4.4.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual Indicator for a VNF instance with invalid indicator identifier
    Check HTTP Response Status Code Is    404

POST Individual VNF Indicator for VNF Instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.3.3
    ...    Test title: POST Individual VNF Indicator for VNF Instance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF indicator in the VNFM
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: clause 8.4.4.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405

PUT Individual VNF Indicator for VNF Instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.3.4
    ...    Test title: PUT Individual VNF Indicator for VNF Instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an existing indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of VNF indicator is available in the VNFM
    ...    Reference: clause 8.4.4.3.3 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405

PATCH Individual VNF Indicator for VNF Instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.3.5
    ...    Test title: PATCH Individual VNF Indicator for VNF Instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update an existing indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of VNF indicator is available for the given VNF instance.
    ...    Reference: clause 8.4.4.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405

DELETE Individual VNF Indicator for VNF Instance - Method not implemented
    [Documentation]    Test ID: 7.3.6.3.6
    ...    Test title: DELETE Individual VNF Indicator for VNF Instance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete an existing indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of VNF indicator is available in the VNFM
    ...    Reference: clause 8.4.3.3.5 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The individual indicator for the VNF instance is not deleted by the unsuccessful operation
    Send DELETE Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405
    Check Postcondition Indicator for VNF instance Exist