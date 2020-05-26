*** Settings ***
Documentation     This Clause defines all the resources and methods provided by the PNF descriptors interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/pnfDescriptors.txt    # Specific nsDescriptors Parameters
Resource          NSDManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           OperatingSystem

*** Test Cases ***
GET all PNF Descriptors Information
    [Documentation]    Test ID: 5.3.1.4.1
    ...    Test title: GET all PNF Descriptors Information
    ...    Test objective: The objective is to test the retrieval of all the PNF Descriptors information and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all PNF Descriptors Information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfos

GET PNF Descriptors Information with attribute-based filter
    [Documentation]    Test ID: 5.3.1.4.2
    ...    Test title: GET PNF Descriptors Information with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of PNF Descriptors information using attribute-based filter, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET PNF Descriptors Information with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfos
    Check HTTP Response Body PnfdInfos Matches the requested attribute-based filter

GET PNF Descriptors Information with invalid attribute-based filter
        [Documentation]    Test ID: 5.3.1.4.3
    ...    Test title: GET PNF Descriptors Information with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of PNF Descriptors information fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET PNF Descriptors Information with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET all PNF Descriptors Information with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.1.4.4
    ...    Test title: GET all PNF Descriptors Information with "all_fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all PNF Descriptors Information with "all_fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "all_fileds" selector
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all PNF Descriptors Information with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfos
    Check HTTP Response Body PnfdInfos Matches the requested all_fields selector

GET all PNF Descriptors Information with "exclude_default" attribute selector
    [Documentation]    Test ID: 5.3.1.4.5
    ...    Test title: GET all PNF Descriptors Information with "exclude_default" attribute selector
    ...    Test objective: The objective is to test the retrieval of all PNF Descriptors Information with "exclude_default" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "exclude_default" selector
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all PNF Descriptors Information with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfos
    Check HTTP Response Body PnfdInfos Matches the requested exclude_default selector

GET all PNF Descriptors Information with "fields" attribute selector
    [Documentation]    Test ID: 5.3.1.4.6
    ...    Test title: GET all PNF Descriptors Information with "fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all PNF Descriptors Information with "fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "fields" selector
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the use of "fields" attribute selector
    ...    Post-Conditions: none
    GET all PNF Descriptors Information with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfos
    Check HTTP Response Body PnfdInfos Matches the requested fields selector

GET all PNF Descriptors Information with "exclude_fields" attribute selector
    [Documentation]    Test ID: 5.3.1.4.7
    ...    Test title: GET all PNF Descriptors Information with "exclude_fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all PNF Descriptors Information with "exclude_fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "exclude_fields" selector
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the use of "exclude_fields" attribute selector
    ...    Post-Conditions: none
    GET all PNF Descriptors Information with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfos
    Check HTTP Response Body PnfdInfos Matches the requested exclude_fields selector  

Create new PNF Descriptor Resource
    [Documentation]    Test ID: 5.3.1.4.8
    ...    Test title:  Create new PNF Descriptor Resource
    ...    Test objective: The objective is to test the creation of a new Create new PNF Descriptor resource and perform the JSON schema validation of the returned structure
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.5.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The PNF Descriptor resource is successfully created on the NFVO
    Send Post Request to create new PNF Descriptor Resource
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   PnfdInfo
    Check HTTP Response Header Contains    Location
    Check Postcondition PnfdInfo Exists

PUT all PNF Descriptors - Method not implemented
    [Documentation]    Test ID: 5.3.1.4.9
    ...    Test title: PUT all PNF Descriptors Information - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify PNF Descriptors Information
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all PNF Descriptors
    Check HTTP Response Status Code Is    405

PATCH all PNF Descriptors - Method not implemented
    [Documentation]    Test ID: 5.3.1.4.10
    ...    Test title: PATCH all PNF Descriptors Information - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update NF Descriptors Information
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all PNF Descriptors
    Check HTTP Response Status Code Is    405

DELETE all PNF Descriptors - Method not implemented
    [Documentation]    Test ID: 5.3.1.4.11
    ...    Test title: DELETE all PNF Descriptors Information - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete PNF Descriptors Information
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The PNF Descriptors are not deleted by the failed operation
    Send DELETE Request for all PNF Descriptors
    Check HTTP Response Status Code Is    405
    Check Postcondition PNF Descriptors Exist
    
GET all PNF Descriptors Information as Paged Response
    [Documentation]    Test ID: 5.3.1.4.12
    ...    Test title: GET all PNF Descriptors Information as Paged Response
    ...    Test objective: The objective is to test the retrieval of all the PNF Descriptors information as a Paged Response.
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all PNF Descriptors Information
    Check HTTP Response Status Code Is    200
    Check LINK in Heade
    
GET PNF Descriptors Information - Bad Request Response too Big
        [Documentation]    Test ID: 5.3.1.4.13
    ...    Test title: GET PNF Descriptors Information - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of PNF Descriptors information fails because response is too big, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: Clause 5.4.5.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all PNF Descriptors Information
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails