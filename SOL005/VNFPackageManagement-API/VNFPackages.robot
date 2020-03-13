*** Settings ***
Resource          environment/vnfPackages.txt    # VNF Packages specific parameters
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          VNFPackageManagementKeywords.robot    
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
GET all VNF Packages
    [Documentation]    Test ID: 5.3.5.1.1
    ...    Test title: GET all VNF Packages
    ...    Test objective: The objective is to test the retrieval of all the available VNF packages information and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Packages
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body Does Not Contain softwareImages
    Check HTTP Response Body Does Not Contain additionalArtifacts
    Check HTTP Response Body Does Not Contain userDefinedData
    Check HTTP Response Body Does Not Contain checksum

GET VNF Packages with attribute-based filter
    [Documentation]    Test ID: 5.3.5.1.2
    ...    Test title: GET VNF Packages with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF packages using attribute-based filter, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Packages with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body VnfPkgsInfo Matches the requested attribute-based filter

GET VNF Packages with invalid attribute-based filter
    [Documentation]    Test ID: 5.3.5.1.3
    ...    Test title: GET VNF Packages with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF packages fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Packages with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get all VNF Packages with malformed authorization token
    [Documentation]    Test ID: 5.3.5.1.4
    ...    Test title: Get all VNF Packages Information with malformed authorization token
    ...    Test objective: The objective is to test that the retrieval of VNF Packages fails when using malformed authorization token
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO.
    ...    Reference: clause 4.5.3.3, 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all VNF Packages with malformed authorization token
    Check HTTP Response Status Code Is    400

Get all VNF Packages without authorization token
    [Documentation]    Test ID: 5.3.1.1.5
    ...    Test title: Get all VNF Packages without authorization token
    ...    Test objective: The objective is to test that the retrieval of VNF Packages fails when omitting the authorization token
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO.
    ...    Reference: clause 4.5.3.3, 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all VNF Packages without authorization token
    Check HTTP Response Status Code Is    401

GET VNF Packages with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.5.1.6
    ...    Test title: GET VNF Packages with "all_fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with "all_fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "all_fileds" selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET VNF Packages with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested all_fields selector

GET VNF Packages with "exclude_default" attribute selector
    [Documentation]    Test ID: 5.3.5.1.7
    ...    Test title: GET VNF Packages with exclude_default attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with "exclude_default" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "exclude_default" selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none        
    GET VNF Packages with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested exclude_default selector

GET VNF Packages with "fields" attribute selector
    [Documentation]    Test ID: 5.3.5.1.8
    ...    Test title: GET VNF Packages with fields attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with "fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "fields" selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFM supports the use of fields attribute selector
    ...    Post-Conditions: none
    GET VNF Packages with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested fields selector

GET VNF Packages with "exclude_fields" attribute selector
    [Documentation]    Test ID: 5.3.5.1.9
    ...    Test title: GET VNF Packages with exclude_fields attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with "exclude_fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "exclude_fields" selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFM supports the use of exclude_fields attribute selector
    ...    Post-Conditions: none
    GET VNF Packages with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested exclude_fields selector   

GET all VNF Packages with invalid resource endpoint
    [Documentation]    Test ID: 5.3.5.1.10
    ...    Test title: GET VNF Packages with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF packages fails when using invalid resource endpoint
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Packages with invalid resource endpoint
    Check HTTP Response Status Code Is    404

Create new VNF Package Resource
    [Documentation]    Test ID: 5.3.5.1.11
    ...    Test title: Create new VNF Package Resource
    ...    Test objective: The objective is to test the creation of a new VNF Package Resource and perform the JSON schema validation of the returned structure
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.2.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package Resource is successfully created on the NFVO
    Send Post Request to create new VNF Package Resource
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   vnfPkgInfo
    Check HTTP Response Header Contains    Location
    Check Postcondition VNF Package Resource Exists

PUT all VNF Packages - Method not implemented
    [Documentation]    Test ID: 5.3.5.1.12
    ...    Test title: PUT all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify existing VNF Packages
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.3 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all VNF Packages
    Check HTTP Response Status Code Is    405

PATCH all VNF Packages - Method not implemented
    [Documentation]    Test ID: 5.3.5.1.13
    ...    Test title: PATCH all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update existing VNF Packages
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all VNF Packages
    Check HTTP Response Status Code Is    405

DELETE all VNF Packages - Method not implemented
    [Documentation]    Test ID: 5.3.5.1.14
    ...    Test title: DELETE all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete existing VNF Packages
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.2.3.5 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Packages are not deleted by the failed operation
    Send DELETE Request for all VNF Packages
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Packages Exist
    