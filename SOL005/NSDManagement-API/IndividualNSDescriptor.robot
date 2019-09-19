*** Settings ***
Documentation     This clause defines all the resources and methods provided by the Individual NS descriptor interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Resource          NSDManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
GET Individual Network Service Descriptor Information
    [Documentation]    Test ID: 5.3.1.2.1
    ...    Test title: GET Individual Network Service Descriptor Information
    ...    Test objective: The objective is to test the retrieval of an individual Network Service Descriptor information and perform a JSON schema validation of the collected data structure
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: section 5.4.3.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual Network Service Descriptor Information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfo
    Check HTTP Response Header Contains ETag
    Check HTTP Response Body NsdInfo Identifier matches the requested Network Service Descriptor Information


GET Individual Network Service Descriptor Information with invalid resource identifier
    [Documentation]    Test ID: 5.3.1.2.2
    ...    Test title: GET Individual Network Service Descriptor Information with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual Network Service Descriptor Information fails when using an invalid resource identifier
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO.
    ...    Reference: section 5.4.3.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual Network Service Descriptor Information with invalid resource identifier
    Check HTTP Response Status Code Is    404



Disable Individual Network Service Descriptor   
    [Documentation]    Test ID: 5.3.1.2.3
    ...    Test title: Disable Individual Network Service Descriptor  
    ...    Test objective: The objective is to test the disabling of an individual Network Service Descriptor and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in enabled operational state.
    ...    Reference: section 5.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Network Service Descriptor is in operational state DISABLED and usage state is not modified
    Send PATCH to disable Individual Network Service Descriptor
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfoModification
    Check Postcondition Network Service Descriptor is in operational state    DISABLED
    Check Postcondition Network Service Descriptor usage state is unmodified (Implicit)

Enable Individual Network Service Descriptor
    [Documentation]    Test ID: 5.3.1.2.4
    ...    Test title: Enable Individual Network Service Descriptor
    ...    Test objective: The objective is to test the enabling of an individual Network Service Descriptor and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in DISABLED operational state (Test ID 5.3.1.2.3).
    ...    Reference: section 5.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Network Service Descriptor is in operational state ENABLED and usage state is not modified
    Send PATCH to enable Individual Network Service Descriptor
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsdInfoModification
    Check Postcondition Network Service Descriptor is in operational state    ENABLED
    Check Postcondition Network Service Descriptor usage state is unmodified (Implicit)   

Enable Individual Network Service Descriptor with conflict due to operational state ENABLED
    [Documentation]    Test ID: 5.3.1.2.5
    ...    Test title: Enable Individual Network Service Descriptor with conflict due to operational state ENABLED
    ...    Test objective: The objective is to test that enabling an individual Network Service Descriptor that is already in ENABLED operational state failsand perform a JSON schema validation of the failder operation HTTP response
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in ENABLED operational state (Test ID 5.3.1.2.4).
    ...    Reference: section 5.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH to enable Individual Network Service Descriptor
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

Enable Individual Network Service Descriptor with conflict due to onboarding state
    [Documentation]    Test ID: 5.3.1.2.6
    ...    Test title: Enable Individual Network Service Descriptor with conflict due to onboarding state
    ...    Test objective: The objective is to test that the retrieval of an Network Service Descriptor fails due to a conflict when the Network Service Descriptor is not in onboarding state ONBOARDED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in ENABLED operational state. The onboarding state of the Network Service Descriptor for which the enabling is requested is different from ONBOARDED.
    ...    Reference: section 5.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send PATCH to enable Individual Network Service Descriptor in onboarding state different from ONBOARDED
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails
    
 Enable Individual Network Service Descriptor with HTTP Etag precondition failure
    [Documentation]    Test ID: 5.3.1.2.7
    ...    Test title:  Enable Individual Network Service Descriptor with HTTP Etag precondition failure
    ...    Test objective: The objective is to test that the retrieval of an Network Service Descriptor fails due to a precondition failure when using an uncorrect Http Etag identified.
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in ENABLED operational state (Test ID 5.3.1.2.4).
    ...    Reference: section 5.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH to enable Individual Network Service Descriptor with HTTP Etag precondition failure
    Check HTTP Response Status Code Is    412

DELETE Individual Network Service Descriptor
    [Documentation]    Test ID: 5.3.1.2.9
    ...    Test title:  DELETE Individual Network Service Descriptor
    ...    Test objective: The objective is to test the deletion of an individual Network Service Descriptor.
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in DISABLED operational state and NOT_IN_USE usage state.
    ...    Reference: section 5.4.3.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Network Service Descriptor is not available anymore in the NFVO 
    Send DELETE Request for Individual Network Service Descriptor
    Check HTTP Response Status Code Is    204
    Check Postcondition Network Service Descriptor is Deleted

DELETE Individual Network Service Descriptor in operational state ENABLED
    [Documentation]    Test ID: 5.3.1.2.10
    ...    Test title:  DELETE Individual Network Service Descriptor in operational state ENABLED
    ...    Test objective: The objective is to test that the deletion of an individual Network Service Descriptor in operational state ENABLED fails. The test also performs a JSON schema validation of the failed operation HTTP response.
    ...    Pre-conditions: One or more Network Service Descriptors are onboarded in the NFVO in ENABLED operational state (Test ID 5.3.1.2.4).
    ...    Reference: section 5.4.3.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The Network Service Descriptor is not deleted by the failed operation. 
    Send DELETE Request for Individual Network Service Descriptor in operational state ENABLED
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition Network Service Descriptor Exists

POST Individual Network Service Descriptor - Method not implemented
    [Documentation]    Test ID: 5.3.1.2.11
    ...    Test title: POST Individual Network Service Descriptor - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new Network Service Descriptor
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.3.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for Individual Network Service Descriptor
    Check HTTP Response Status Code Is    405

PUT Individual Network Service Descriptor - Method not implemented
    [Documentation]    Test ID: 5.3.1.2.12
    ...    Test title: PUT Individual Network Service Descriptor - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a new Network Service Descriptor
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.3.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for Individual Network Service Descriptor
    Check HTTP Response Status Code Is    405
