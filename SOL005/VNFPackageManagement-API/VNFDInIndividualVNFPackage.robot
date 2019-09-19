*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfdInIndividualVnfPackage.txt
Resource          VNFPackageManagementKeywords.robot    
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
Get single file VNFD in Individual VNF Package in Plain Format
    [Documentation]    Test ID: 5.3.5.3.1
    ...    Test title: Get single file VNFD in Individual VNF Package in Plain Format
    ...    Test objective: The objective is to test the retrieval of the VNFD in plain format for an individual VNF package and perform a validation that returned content is in plain format
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFD is implemented as a single file
    ...    Post-Conditions: none
    Get single file VNFD in Individual VNF Package in Plain Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    text/plain

Get VNFD in Individual VNF Package in Zip Format
    [Documentation]    Test ID: 5.3.5.3.2
    ...    Test title: Get VNFD in Individual VNF Package in Zip Format
    ...    Test objective: The objective is to test the retrieval of the VNFD in zip format for an individual VNF package and perform a validation that returned content is in zip format
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNFD in Individual VNF Package in Zip Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip

Get single file VNFD in Individual VNF Package in Plain or Zip Format
    [Documentation]    Test ID: 5.3.5.3.3
    ...    Test title: Get single file VNFD in Individual VNF Package in Plain or Zip Format
    ...    Test objective: The objective is to test the retrieval of the single file VNFD for an individual VNF package when requesting Plain or Zip format to NFVO by including both formats in the request, and perform a validation that returned content is in Plain or Zip format
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFD is implemented as a single file
    ...    Post-Conditions: none
    Get single file VNFD in Individual VNF Package in Plain or Zip Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is Any of   text/plain    application/zip
    
Get multi file VNFD in Individual VNF Package in Plain or Zip Format
    [Documentation]    Test ID: 5.3.5.3.4
    ...    Test title: Get multi file VNFD in Individual VNF Package in Plain or Zip Format
    ...    Test objective: The objective is to test the retrieval of the multi file VNFD for an individual VNF package when requesting Plain or Zip format to NFVO by including both formats in the request, and perform a validation that returned content is in Zip format
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFD is implemented as a multi file
    ...    Post-Conditions: none
    Get multi file VNFD in Individual VNF Package in Plain or Zip Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip

Get multi file VNFD in Individual VNF Package in Plain Format
    [Documentation]    Test ID: 5.3.5.3.5
    ...    Test title: Get multi file VNFD in Individual VNF Package in Plain Format
    ...    Test objective: The objective is to test that the retrieval of the multi file VNFD for an individual VNF package fails when requesting it in Plain format, and perform a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The VNFD is implemented as a multi file
    ...    Post-Conditions: none
    Get multi file VNFD in Individual VNF Package in Plain Format
    Check HTTP Response Status Code Is    406
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get VNFD in Individual VNF Package with invalid resource identifier
    [Documentation]    Test ID: 5.3.5.3.6
    ...    Test title: Get VNFD in Individual VNF Package with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of the VNFD for an individual VNF Package fails when using an invalid resource identifier
    ...    Pre-conditions: none
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNFD in Individual VNF Package with invalid resource identifier
    Check HTTP Response Status Code Is    404

Get VNFD in Individual VNF Package with conflict due to onboarding state
    [Documentation]    Test ID: 5.3.5.3.7
    ...    Test title: Get VNFD in Individual VNF Package with conflict due to onboarding state
    ...    Test objective: The objective is to test that the retrieval of the VNFD for an individual VNF Package fails due to a conflict when the VNF Package is not in onboarding state ONBOARDED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the VNF package for which the VNFD is requested is different from ONBOARDED.
    ...    Reference: section 9.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get VNFD in Individual VNF Package with conflict due to onboarding state
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST VNFD in Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 5.3.5.3.8
    ...    Test title: POST VNFD in Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNFD
    ...    Pre-conditions: none
    ...    Reference: section 9.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for VNFD in individual VNF Package
    Check HTTP Response Status Code Is    405

PUT VNFD in Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 5.3.5.3.9
    ...    Test title: PUT VNFD in Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a VNFD
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for VNFD in individual VNF Package
    Check HTTP Response Status Code Is    405

PATCH VNFD in Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 5.3.5.3.10
    ...    Test title: PATCH VNFD in Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update a VNFD
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for VNFD in individual VNF Package
    Check HTTP Response Status Code Is    405

DELETE VNFD in Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 5.3.5.3.11
    ...    Test title: DELETE VNFD in Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that DELETE  method is not allowed to delete a VNFD
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.4.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNFD is not deleted by the failed operation
    Send DELETE Request for VNFD in individual VNF Package
    Check HTTP Response Status Code Is    405
    Check Postcondition VNFD Exist