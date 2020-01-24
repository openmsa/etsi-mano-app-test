*** Settings ***
Documentation     This clause defines all the resources and methods provided by the Iindividual PNF descriptor interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/pnfDescriptors.txt    # Specific nsDescriptors Parameters
Resource          NSDManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           OperatingSystem

*** Test Cases ***
GET Individual PNF Descriptor Information
    [Documentation]    Test ID: 5.3.1.5.1
    ...    Test title: GET Individual PNF Descriptor Information
    ...    Test objective: The objective is to test the retrieval of an individual PNF Descriptor information and perform a JSON schema validation of the collected data structure
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.6.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual PNF Descriptor Information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfo
    Check HTTP Response Header Contains ETag
    Check HTTP Response Body PnfdInfo Identifier matches the requested PNF Descriptor Information

GET Individual PNF Descriptor Information with invalid resource identifier
    [Documentation]    Test ID: 5.3.1.5.2
    ...    Test title: GET Individual PNF Descriptor Information with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual PNF Descriptor Information fails when using an invalid resource identifier
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.6.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual PNF Descriptor Information with invalid resource identifier
    Check HTTP Response Status Code Is    404

Update Individual PNF Descriptor
    [Documentation]    Test ID: 5.3.1.5.3
    ...    Test title: Update Individual PNF Descriptor
    ...    Test objective: The objective is to test the update of an individual PNF Descriptor and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.6.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The PNF Descriptor is modified according to the update request
    Send PATCH to update Individual PNF Descriptor
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PnfdInfoModification
    Check Postcondition PNF Descriptor is modified according to the requested update  


Update Individual PNF Descriptor with HTTP Etag precondition failure
    [Documentation]    Test ID: 5.3.1.5.4
    ...    Test title:  Update Individual PNF Descriptor with HTTP Etag precondition failure
    ...    Test objective: The objective is to test that the update of a PNF Descriptor fails due to a precondition failure when using an uncorrect Http Etag identified.
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.6.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH to update Individual PNF Descriptor with HTTP Etag precondition failure
    Check HTTP Response Status Code Is    412

POST Individual PNF Descriptor - Method not implemented
    [Documentation]    Test ID: 5.3.1.5.5
    ...    Test title: POST Individual PNF Descriptor - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new PNF Descriptor
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.6.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for Individual PNF Descriptor
    Check HTTP Response Status Code Is    405

PUT Individual PNF Descriptor - Method not implemented
    [Documentation]    Test ID: 5.3.1.5.6
    ...    Test title: PUT Individual PNF Descriptor - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a new PNF Descriptor
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.6.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for Individual PNF Descriptor
    Check HTTP Response Status Code Is    405

DELETE Individual PNF Descriptor
    [Documentation]    Test ID: 5.3.1.5.7
    ...    Test title:  DELETE Individual PNF Descriptor
    ...    Test objective: The objective is to test the deletion of an individual PNF Descriptor.
    ...    Pre-conditions: One or more PNF Descriptors are onboarded in the NFVO.
    ...    Reference: clause 5.4.6.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The PNF Descriptor is not available anymore in the NFVO 
    Send DELETE Request for Individual PNF Descriptor
    Check HTTP Response Status Code Is    204
    Check Postcondition PNF Descriptor is Deleted