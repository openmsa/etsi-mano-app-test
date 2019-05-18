*** Settings ***
Resource          environment/vnfPackages.txt    # VNF Packages specific parameters
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          VNFPackageManagementKeywords.robot    
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET all VNF Packages
    [Documentation]    Test ID: 7.3.3.1.1
    ...    Test title: GET all VNF Packages
    ...    Test objective: The objective is to test the retrieval of all the available VNF packages information and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Packages
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body Does Not Contain softwareImages
    Check HTTP Response Body Does Not Contain additionalArtifacts
    Check HTTP Response Body Does Not Contain userDefinedData 

GET VNF Packages with attribute-based filter
    [Documentation]    Test ID: 7.3.3.1.2
    ...    Test title: GET VNF Packages with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF packages using attribute-based filter, perform a JSON schema validation of the collected jobs data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Packages with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body VnfPkgsInfo Matches the requested attribute-based filter

GET VNF Packages with invalid attribute-based filter
    [Documentation]    Test ID: 7.3.3.1.3
    ...    Test title: GET VNF Packages with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF packages fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Packages with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET all Packages - all_fields
    [Documentation]    Test ID: 7.3.3.1.4
    ...    Test title: GET VNF Packages with all_fields attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with all_fields attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued all_fileds selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 4.3.3.2.1, 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET VNF Packages with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested all_fields selector

GET VNF Packages with exclude_default attribute selector
    [Documentation]    Test ID: 7.3.3.1.5
    ...    Test title: GET VNF Packages with exclude_default attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with exclude_default attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued exclude_default selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 4.3.3.2.1, 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none        
    GET VNF Packages with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested exclude_default selector

GET VNF Packages with fields attribute selector
    [Documentation]    Test ID: 7.3.3.1.6
    ...    Test title: GET VNF Packages with fields attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with fields attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued fields selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 4.3.3.2.1, 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFM supports the use of fields attribute selector
    ...    Post-Conditions: none
    GET VNF Packages with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested fields selector

GET VNF Packages with exclude_fields attribute selector
    [Documentation]    Test ID: 7.3.3.1.7
    ...    Test title: GET VNF Packages with exclude_fields attribute selector
    ...    Test objective: The objective is to test the retrieval of VNF packages with exclude_fields attribute selector, perform a JSON schema validation of the collected data structure, and verify that the retrieved information matches the issued exclude_fields selector
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 4.3.3.2.1, 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFM supports the use of exclude_fields attribute selector
    ...    Post-Conditions: none
    GET VNF Packages with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgsInfo
    Check HTTP Response Body vnfPkgsInfo Matches the requested exclude_fields selector   

GET all VNF Packages with invalid resource endpoint
    [Documentation]    Test ID: 7.3.3.1.8
    ...    Test title: GET VNF Packages with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF packages fails when using invalid resource endpoint
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all VNF Packages with invalid resource endpoint
    Check HTTP Response Status Code Is    404

POST all VNF Packages - Method not implemented
    [Documentation]    Test ID: 7.3.3.1.9
    ...    Test title: POST all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF Packages
    ...    Pre-conditions: none
    ...    Reference: section 10.4.2.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for all VNF Packages
    Check HTTP Response Status Code Is    405

PUT all VNF Packages - Method not implemented
    [Documentation]    Test ID: 7.3.3.1.10
    ...    Test title: PUT all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify existing VNF Packages
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all VNF Packages
    Check HTTP Response Status Code Is    405

PATCH all VNF Packages - Method not implemented
    [Documentation]    Test ID: 7.3.3.1.11
    ...    Test title: PATCH all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update existing VNF Packages
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all VNF Packages
    Check HTTP Response Status Code Is    405

DELETE all VNF Packages - Method not implemented
    [Documentation]    Test ID: 7.3.3.1.12
    ...    Test title: DELETE all VNF Packages - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete existing VNF Packages
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.2.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Packages are not deleted by the failed operation
    Send DELETE Request for all VNF Packages
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Packages Exist