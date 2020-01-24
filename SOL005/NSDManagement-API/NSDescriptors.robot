*** Settings ***
Documentation     This clause defines all the resources and methods provided by the NS descriptors interface.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Resource          NSDManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           OperatingSystem

*** Test Cases ***
GET all Network Service Descriptors Information
    [Documentation]    Test ID: 5.3.1.1.1
    ...    Test title: GET all Network Service Descriptors Information
    ...    Test objective: The objective is to test the retrieval of all the Network Service Descriptors information and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Network Service Descriptors Information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfos

GET Network Service Descriptors Information with attribute-based filter
    [Documentation]    Test ID: 5.3.1.1.2
    ...    Test title: GET Network Service Descriptors Information with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of Network Service Descriptors information using attribute-based filter, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Network Service Descriptors Information with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfos
    Check HTTP Response Body NsdInfos Matches the requested attribute-based filter

GET Network Service Descriptors Information with invalid attribute-based filter
        [Documentation]    Test ID: 5.3.1.1.3
    ...    Test title: GET Network Service Descriptors Information with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of Network Service Descriptors information fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Network Service Descriptors Information with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get all Network Service Descriptors Information with malformed authorization token
    [Documentation]    Test ID: 5.3.1.1.4
    ...    Test title: Get all Network Service Descriptors Information with malformed authorization token
    ...    Test objective: The objective is to test that the retrieval of Network Service Descriptors Information fails when using malformed authorization token
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.5.3.3, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all Network Service Descriptors Information with malformed authorization token
    Check HTTP Response Status Code Is    400

Get all Network Service Descriptors Information without authorization token
    [Documentation]    Test ID: 5.3.1.1.5
    ...    Test title: Get all Network Service Descriptors Information without authorization token
    ...    Test objective: The objective is to test that the retrieval of Network Service Descriptors Information fails when omitting the authorization token
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.5.3.3, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all Network Service Descriptors Information without authorization token
    Check HTTP Response Status Code Is    401

GET all Network Service Descriptors Information with expired or revoked authorization token
    [Documentation]    Test ID: 5.3.1.1.6
    ...    Test title: GET all Network Service Descriptors Information with expired or revoked authorization token
    ...    Test objective: The objective is to test that the retrieval of Network Service Descriptors Information fails when using expired or revoked authorization token
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.5.3.3, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO requires the usage of access tokens for authorizing the API requests.
    ...    Post-Conditions: none
    Get all Network Service Descriptors Information with expired or revoked authorization token
    Check HTTP Response Status Code Is    401

GET all Network Service Descriptors Information with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.1.1.7
    ...    Test title: GET all Network Service Descriptors Information with "all_fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all Network Service Descriptors Information with "all_fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "all_fileds" selector
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Network Service Descriptors Information with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfos
    Check HTTP Response Body NsdInfos Matches the requested all_fields selector

GET all Network Service Descriptors Information with "exclude_default" attribute selector
    [Documentation]    Test ID: 5.3.1.1.8
    ...    Test title: GET all Network Service Descriptors Information with "exclude_default" attribute selector
    ...    Test objective: The objective is to test the retrieval of all Network Service Descriptors Information with "exclude_default" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "exclude_default" selector
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Network Service Descriptors Information with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfos
    Check HTTP Response Body NsdInfos Matches the requested exclude_default selector

GET all Network Service Descriptors Information with "fields" attribute selector
    [Documentation]    Test ID: 5.3.1.1.9
    ...    Test title: GET all Network Service Descriptors Information with "fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all Network Service Descriptors Information with "fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "fields" selector
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the use of "fields" attribute selector
    ...    Post-Conditions: none
    GET all Network Service Descriptors Information with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfos
    Check HTTP Response Body NsdInfos Matches the requested fields selector

GET all Network Service Descriptors Information with "exclude_fields" attribute selector
    [Documentation]    Test ID: 5.3.1.1.10
    ...    Test title: GET all Network Service Descriptors Information with "exclude_fields" attribute selector
    ...    Test objective: The objective is to test the retrieval of all Network Service Descriptors Information with "exclude_fields" attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued "exclude_fields" selector
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 4.3.3.2.1, 5.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the use of "exclude_fields" attribute selector
    ...    Post-Conditions: none
    GET all Network Service Descriptors Information with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfos
    Check HTTP Response Body NsdInfos Matches the requested exclude_fields selector  

Create new Network Service Descriptor Resource
    [Documentation]    Test ID: 5.3.1.1.11
    ...    Test title:  Create new Network Service Descriptor Resource
    ...    Test objective: The objective is to test the creation of a new Create new Network Service Descriptor resource and perform the JSON schema validation of the returned structure
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.2.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Network Service Descriptor resource is successfully created on the NFVO
    Send Post Request to create new Network Service Descriptor Resource
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   NsdInfo
    Check HTTP Response Header Contains    Location
    Check Postcondition NsdInfo Exists

PUT all Network Service Descriptors - Method not implemented
    [Documentation]    Test ID: 5.3.1.1.12
    ...    Test title: PUT all Network Service Descriptors Information - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify Network Service Descriptors Information
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all Network Service Descriptors
    Check HTTP Response Status Code Is    405

PATCH all Network Service Descriptors - Method not implemented
    [Documentation]    Test ID: 5.3.1.1.13
    ...    Test title: PATCH all Network Service Descriptors Information - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update Network Service Descriptors Information
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.2.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all Network Service Descriptors
    Check HTTP Response Status Code Is    405

DELETE all Network Service Descriptors - Method not implemented
    [Documentation]    Test ID: 5.3.1.1.14
    ...    Test title: DELETE all Network Service Descriptors Information - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete Network Service Descriptors Information
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.2.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Network Service Descriptors are not deleted by the failed operation
    Send DELETE Request for all Network Service Descriptors
    Check HTTP Response Status Code Is    405
    Check Postcondition Network Service Descriptors Exist
