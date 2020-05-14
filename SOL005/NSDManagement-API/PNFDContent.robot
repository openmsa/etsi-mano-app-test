*** Settings ***
Documentation     This clause defines the content of the individual NS descriptor, i.e. PNFD content
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/pnfDescriptors.txt    # Specific PNFDescriptors Parameters
Resource          NSDManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           OperatingSystem

*** Test Cases ***
Get PNFD Content
    [Documentation]    Test ID: 5.3.1.6.1
    ...    Test title: Get PNFD Content
    ...    Test objective: The objective is to test the retrieval of the PNFD Content in plain format and perform a validation that returned content is in plain format
    ...    Pre-conditions: One or more PNFDs are onboarded in the NFVO.
    ...    Reference: clause 5.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get PNFD Content 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    text/plain

Get PNFD Content with invalid resource identifier
    [Documentation]    Test ID: 5.3.1.6.2
    ...    Test title: Get PNFD Content with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of the PNFD Content fails when using an invalid resource identifier
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get PNFD Content with invalid resource identifier
    Check HTTP Response Status Code Is    404

Get PNFD Content with conflict due to onboarding state
    [Documentation]    Test ID: 5.3.1.6.3
    ...    Test title: Get PNFD Content with conflict due to onboarding state
    ...    Test objective: The objective is to test that the retrieval of the PNFD Content fails due to a conflict when the PNFD is not in onboarding state ONBOARDED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the PNFD for which the PNFD Content is requested is different from ONBOARDED.
    ...    Reference: clause 5.4.7.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get PNFD Content with conflict due to onboarding state
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails


Upload PNFD Content as plain text file
    [Documentation]    Test ID: 5.3.1.6.4
    ...    Test title: Upload PNFD Content as plain text file
    ...    Test objective: The objective is to test the upload of a PNFD Content in plain text format.
    ...    Pre-conditions: One or more PNFDs are onboarded in the NFVO.
    ...    Reference: clause 5.4.7.3.3 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The uploaded PNFD content is available in the NFVO
    Send PUT Request to upload PNFD Content as plain text file
    Check HTTP Response Status Code Is    204
    Check Postcondition PNFD Content Exists

 
Upload PNFD Content with conflict due to onboarding state
   [Documentation]    Test ID: 5.3.1.6.5
    ...    Test title: Upload PNFD Content with conflict due to onboarding state
    ...    Test objective: The objective is to test that the upload of the PNFD Content fails due to a conflict when the PNFD is not in onboarding state CREATED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the PNFD for which the PNFD Content is requested is different from CREATED.
    ...    Reference: clause 5.4.7.3.3 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Send PUT Request to upload PNFD Content with conflict due to onboarding state
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails             

POST PNFD Content - Method not implemented
    [Documentation]    Test ID: 5.3.1.6.6
    ...    Test title: POST PNFD Content - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new PNF Descriptor content
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.7.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for PNFD Content
    Check HTTP Response Status Code Is    405

PATCH PNFD Content - Method not implemented
    [Documentation]    Test ID: 5.3.1.6.7
    ...    Test title: PATCH PNFD Content - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update PNF Descriptor content
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.7.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for PNFD Content
    Check HTTP Response Status Code Is    405

DELETE PNFD Content - Method not implemented
    [Documentation]    Test ID: 5.3.1.6.8
    ...    Test title: DELETE PNFD Content - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete PNF Descriptor content
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.7.3.5 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The PNFD content is not deleted by the failed operation
    Send DELETE Request for PNFD Content
    Check HTTP Response Status Code Is    405
    Check Postcondition PNFD Content Exists
