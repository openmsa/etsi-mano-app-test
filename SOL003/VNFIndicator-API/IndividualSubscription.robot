*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Resource          VNFIndicatorsKeywords.robot
Library           OperatingSystem
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false

*** Test Cases ***
GET Individual VNF Indicator Subscription
    [Documentation]    Test ID: 7.3.6.5.1
    ...    Test title: GET Individual VNF Indicator Subscription
    ...    Test objective: The objective is to test the retrieval of individual VNF indicator subscription and perform a JSON schema validation of the returned subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.6.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscription

GET Individual VNF Indicator Subscription with invalid resource identifier
    [Documentation]    Test ID: 7.3.6.5.2
    ...    Test title: GET Individual VNF Indicator Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of individual VNF indicator subscription fails when using an invalid resource identifier.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.6.3.2 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual VNF Indicator Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual VNF Indicator Subscription
    [Documentation]    Test ID: 7.3.6.5.3
    ...    Test title: DELETE Individual VNF Indicator Subscription
    ...    Test objective: The objective is to test the deletion of an individual VNF indicator subscription.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.6.3.5 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The subscription to VNF indicators is deleted
    Send Delete Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition Individual VNF Indicator Subscription is Deleted

DELETE Individual VNF Indicator Subscription with invalid resource identifier
    [Documentation]    Test ID: 7.3.6.5.4
    ...    Test title: DELETE Individual VNF Indicator Subscription with invalid resource identifier
    ...    Test objective: The objective is to test that the deletion of an individual VNF indicator subscription fails when using an invalid resource identifier.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.6.3.5 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete Request for Individual VNF Indicator Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

PUT Individual VNF Indicator Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.6.5.5
    ...    Test title: PUT Individual VNF Indicator Subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an individual VNF indicator subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.6.3.3 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The individual VNF indicator subscription is not modified by the operation
    Send Put Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF indicator subscription Unmodified (Implicit)

PATCH Individual VNF Indicator Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.6.5.6
    ...    Test title: PATCH Individual VNF Indicator Subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update an individual VNF indicator subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.6.3.4 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The individual VNF indicator subscription is not modified by the operation
    Send Patch Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF indicator subscription Unmodified (Implicit) 

POST Individual VNF Indicator Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.6.5.7
    ...    Test title: POST Individual VNF Indicator Subscription - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF indicator subscription
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: clause 8.4.6.3.1 - ETSI GS NFV-SOL 003 [1] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The individual VNF indicator subscription is not created by the operation
    Send Post Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF indicator subscription is not created  