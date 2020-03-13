*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualVnfPackage.txt
Resource          VNFPackageManagementKeywords.robot    
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
GET Individual VNF Package
    [Documentation]    Test ID: 5.3.5.2.1
    ...    Test title: GET Individual VNF Package
    ...    Test objective: The objective is to test the retrieval of an individual VNF package information perform a JSON schema validation of the collected data structure
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.3.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual VNF Package
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfPkgInfo
    Check HTTP Response Body vnfPkgInfo Identifier matches the requested VNF Package

GET Individual VNF Package with invalid resource identifier
    [Documentation]    Test ID: 5.3.5.2.2
    ...    Test title: GET Individual VNF Package with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package fails when using an invalid resource identifier
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.3.3.2 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET Individual VNF Package with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 5.3.5.2.3
    ...    Test title: POST Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF Package
    ...    Pre-conditions: none
    ...    Reference: clause 9.4.3.3.1 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for individual VNF Package
    Check HTTP Response Status Code Is    405

PUT Individual VNF Package - Method not implemented
    [Documentation]    Test ID: 5.3.5.2.4
    ...    Test title: PUT Individual VNF Package - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a VNF Package
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 9.4.3.3.3 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for individual VNF Package
    Check HTTP Response Status Code Is    405

Disable Individual VNF Package   
    [Documentation]    Test ID: 5.3.5.2.5
    ...    Test title: Disable Individual VNF Package  
    ...    Test objective: The objective is to test the disabling of an individual VNF Package  and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO in ENABLED operational state.
    ...    Reference: clause 9.4.3.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package is in operational state DISABLED
    Send PATCH to disable Individual VNF Package
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfPkgInfoModification
    Check Postcondition VNF Package is in operational state    DISABLED

Disable Individual VNF Package with conflict due to operational state DISABLED
    [Documentation]    Test ID: 5.3.5.2.6
    ...    Test title: Disable Individual VNF Package with conflict due to operational state DISABLED
    ...    Test objective: The objective is to test that disabling an individual VNF Package that is already in DISABLED operational state fails and perform a JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO in DISABLED operational state (Test ID 5.3.5.2.5).
    ...    Reference: clause 9.4.3.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH to disable Individual VNF Package
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

Enable Individual VNF Package
    [Documentation]    Test ID: 5.3.5.2.7
    ...    Test title: Enable Individual VNF Package
    ...    Test objective: The objective is to test the enabling of an individual VNF Package and perform a JSON schema and content validation of the collected data structure
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO in DISABLED operational state (Test ID 5.3.5.2.5).
    ...    Reference: clause 9.4.3.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package is in operational state ENABLED
    Send PATCH to enable Individual VNF Package
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfPkgInfoModification
    Check Postcondition VNF Package is in operational state    ENABLED 

Enable Individual VNF Package with conflict due to operational state ENABLED
    [Documentation]    Test ID: 5.3.5.2.8
    ...    Test title: Enable Individual VNF Package with conflict due to operational state ENABLED
    ...    Test objective: The objective is to test that enabling an individual VNF Package that is already in ENABLED operational state fails and perform a JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more VNF Packages are onboarded in the NFVO in ENABLED operational state (Test ID 5.3.5.2.7).
    ...    Reference: clause 9.4.3.3.4 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH to enable Individual VNF Package
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

DELETE Individual VNF Package
    [Documentation]    Test ID: 5.3.5.2.9
    ...    Test title: DELETE Individual VNF Package
    ...    Test objective: The objective is to test the deletion of an individual VNF Package
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO in DISABLED operational state
    ...    Reference: clause 9.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package is not available anymore in the NFVO 
    Send DELETE Request for individual VNF Package
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package is Deleted

DELETE Individual VNF Package in operational state ENABLED
    [Documentation]    Test ID: 5.3.5.2.10
    ...    Test title:  DELETE Individual VNF Package in operational state ENABLED
    ...    Test objective: The objective is to test that the deletion of an individual VNF Package in operational state ENABLED fails. The test also performs a JSON schema validation of the failed operation HTTP response.
    ...    Pre-conditions: One or more VNF Package are onboarded in the NFVO in ENABLED operational state (Test ID 5.3.1.2.7).
    ...    Reference: clause 9.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package is not deleted by the failed operation. 
    Send DELETE Request for Individual VNF Package in operational state ENABLED
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Package Exists
    
DELETE Individual VNF Package used for instantiated VNF instances
    [Documentation]    Test ID: 5.3.5.2.11
    ...    Test title:  DELETE Individual VNF Package used for instantiated VNF instances
    ...    Test objective: The objective is to test that the deletion of an individual VNF Package that is used in instantiated VNF instances fails. The test also performs a JSON schema validation of the failed operation HTTP response.
    ...    Pre-conditions: One or more VNF instances are instantiated based on the concerned VNF package.
    ...    Reference: clause 9.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package is not deleted by the failed operation. 
    Send DELETE Request for Individual VNF Package used for instantiated VNF instances
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Package Exists
    

