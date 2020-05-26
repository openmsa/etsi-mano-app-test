*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library           OperatingSystem
Library           JSONLibrary
Resource          environment/individualSubscription.txt
Resource          VNFPerformanceManagementKeywords.robot

*** Test Cases ***
GET Individual VNF Performance Subscription
    [Documentation]    Test ID: 7.3.4.7.1
    ...    Test title: GET Individual VNF Performance Subscription
    ...    Test objective: The objective is to test the retrieval of individual VNF performance subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.8.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual VNF Performance Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PmSubscription
    Check HTTP Response Body Subscription Identifier matches the requested Subscription

GET Individual VNF Performance Subscription with invalid resource identifier
    [Documentation]    Test ID: 7.3.4.7.2
    ...    Test title: GET Individual VNF Performance Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF performance subscription fails when using an invalid resource identifier
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.8.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual VNF Performance Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual VNF Performance Subscription
    [Documentation]    Test ID: 7.3.4.7.3
    ...    Test title: DELETE Individual VNF Performance Subscription
    ...    Test objective: The objective is to test the deletion of an individual VNF performance subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.8.3.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Subscription is not available anymore in the VNFM    
    Send Delete request for individual VNF Performance Subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition VNF Performance Subscription is Deleted

DELETE Individual VNF Performance Subscription with invalid resource identifier
    [Documentation]    Test ID: 7.3.4.7.4
    ...    Test title: DELETE Individual VNF Performance Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual VNF performance subscription fails when using an invalid resource identifier
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.8.3.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete request for individual VNF Performance Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual VNF Performance Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.4.7.5
    ...    Test title: POST Individual VNF Performance Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF Performance Subscription
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: Clause 6.4.8.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Subscription is not created on the VNFM
    Send Post request for individual VNF Performance Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Subscription is not Created

PUT Individual VNF Performance Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.4.7.6
    ...    Test title: PUT Individual VNF Performance Subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing VNF Performance subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.8.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance subscription is not modified by the operation
    Send Put request for individual VNF Performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Subscription is Unmodified (Implicit)

PATCH Individual VNF Performance Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.4.7.7
    ...    Test title: PATCH Individual VNF Performance Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing VNF Performance subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.8.3.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance subscription is not modified by the operation
    Send Patch request for individual VNF Performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Subscription is Unmodified (Implicit)

