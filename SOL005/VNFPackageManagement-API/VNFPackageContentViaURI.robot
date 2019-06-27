*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfPackageContentViaUri.txt
Resource          VNFPackageManagementKeywords.robot
Library           JSONLibrary
Library           OperatingSystem    
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}

*** Test Cases ***
Upload VNF Package Content from URI
    [Documentation]    Test ID: 5.3.5.5.1
    ...    Test title: Upload VNF Package Content from URI
    ...    Test objective: The objective is to test the upload of a VNF Package Content from URI.
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO.
    ...    Reference: section 9.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request to upload VNF Package Content from URI
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body is Empty

Upload VNF Package Content from URI with conflict due to onboarding state
   [Documentation]    Test ID: 5.3.5.5.2
    ...    Test title: Upload VNF Package Content from URI with conflict due to onboarding state
    ...    Test objective: The objective is to test that the upload of the VNF Package Content from URI fails due to a conflict when the VNF Package is not in onboarding state CREATED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the VNF Package for which the content is requested is different from ONBOARDED.
    ...    Reference: section 9.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Send POST Request to upload VNF Package Content from URI with conflict due to onboarding state
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails   


GET Individual VNF Package Content from URI - Method not implemented
    [Documentation]    Test ID: 5.3.5.5.3
    ...    Test title: GET Individual VNF Package Content from URI - Method not implemented
    ...    Test objective: The objective is to test that GET  method is not allowed to retrieve a VNF Package content from URI
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.6.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send GET Request for individual VNF Package Content from URI
    Check HTTP Response Status Code Is    405

PUT Individual VNF Package Content from URI - Method not implemented
    [Documentation]    Test ID: 5.3.5.5.4
    ...    Test title: PUT Individual VNF Package Content from URI - Method not implemented
    ...    Test objective: The objective is to test that PUT  method is not allowed to modify a VNF Package content from URI
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.6.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for individual VNF Package Content from URI
    Check HTTP Response Status Code Is    405

PATCH Individual VNF Package Content from URI - Method not implemented
    [Documentation]    Test ID: 5.3.5.5.5
    ...    Test title: PATCH Individual VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that PATCH  method is not allowed to update a VNF Package content from URI
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.6.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for individual VNF Package Content from URI
    Check HTTP Response Status Code Is    405

DELETE Individual VNF Package Content from URI - Method not implemented
    [Documentation]    Test ID: 5.3.5.5.6
    ...    Test title: DELETE Individual VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that DELETE  method is not allowed to delete a VNF Package content from URI
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: section 9.4.6.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package content is not deleted by the failed operation
    Send DELETE Request for individual VNF Package Content from URI
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Content from URI Exist