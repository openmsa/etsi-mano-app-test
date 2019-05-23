*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualVnfPackage.txt
Resource          VNFPackageManagementKeywords.robot  
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
GET Individual VNF Package
    [Documentation]    Test ID: 7.3.3.2.1
    ...    Test title: GET Individual VNF Package
    ...    Test objective: The objective is to test the retrieval of an individual VNF package information perform a JSON schema validation of the collected data structure
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual VNF Package
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgInfo
    Check HTTP Response Body vnfPkgInfo Identifier matches the requested VNF Package

GET Individual VNF Package with invalid resource identifier
    [Documentation]    Test ID: 7.3.3.2.2
    ...    Test title: GET Individual VNF Package with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package fails when using an invalid resource identifier
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.3.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET Individual VNF Package with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 7.3.3.2.3
    ...    Test title: POST Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF Package
    ...    Pre-conditions: none
    ...    Reference: section 10.4.3.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for individual VNF Package
    Check HTTP Response Status Code Is    405

PUT Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 7.3.3.2.4
    ...    Test title: PUT Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a VNF Package
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.3.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for individual VNF Package
    Check HTTP Response Status Code Is    405

PATCH Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 7.3.3.2.5
    ...    Test title: PATCH Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that PATCH  method is not allowed to update a VNF Package
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for individual VNF Package
    Check HTTP Response Status Code Is    405

DELETE Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 7.3.3.2.6
    ...    Test title: DELETE Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that DELETE  method is not allowed to delete a VNF Package
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 10.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package is not deleted by the failed operation
    Send DELETE Request for individual VNF Package
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Exist