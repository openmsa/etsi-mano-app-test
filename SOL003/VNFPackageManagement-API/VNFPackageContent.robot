*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfPackageContent.txt
Resource          VNFPackageManagementKeywords.robot  
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false

*** Test Cases ***
GET Individual VNF Package Content
    [Documentation]    Test ID: 7.3.3.3.1
    ...    Test title: GET Individual VNF Package Content
    ...    Test objective: The objective is to test the retrieval of an individual VNF package content and perform a validation that returned content is in zip format
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual VNF Package Content
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip

GET Individual VNF Package Content with Range Request and NFVO supporting Range Requests
    [Documentation]    Test ID: 7.3.3.3.2
    ...    Test title: GET Individual VNF Package Content with Range Request and NFVO supporting Range Requests
    ...    Test objective: The objective is to test the retrieval of an individual VNF package content when using a range request to return single range of bytes from the file, with the NFVO supporting it. The test also perform a validation that returned content matches the issued range
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports range requests to return single range of bytes from the VNF package file
    ...    Post-Conditions: none
    GET Individual VNF Package Content with Range Request
    Check HTTP Response Status Code Is    206
    Check HTTP Response Header Content-Type Is    application/zip
    Check HTTP Response Header Content-Range Is Present and Matches the requested range
    Check HTTP Response Header Content-Length Is Present and Matches the requested range length

GET Individual VNF Package Content with Range Request and NFVO not supporting Range Requests
    [Documentation]    Test ID: 7.3.3.3.3
    ...    Test title: GET Individual VNF Package Content with Range Request and NFVO not supporting Range Requests
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package content, when using a range request to return single range of bytes from the file and the NFVO not supporting it, returns the full VNF Package file.
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO does not support range requests to return single range of bytes from the VNF package file
    ...    Post-Conditions: none    
    GET Individual VNF Package Content with Range Request
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip    

GET Individual VNF Package Content with invalid Range Request
    [Documentation]    Test ID: 7.3.3.3.4
    ...    Test title: GET Individual VNF Package Content with invalid Range Request
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package content fails when using a range request that does not match any available byte range in the file.
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports range requests to return single range of bytes from the VNF package file
    ...    Post-Conditions: none      
    GET Individual VNF Package Content with invalid Range Request
    Check HTTP Response Status Code Is    416
    
GET Individual VNF Package Content with invalid resource identifier
    [Documentation]    Test ID: 7.3.3.3.5
    ...    Test title: GET Individual VNF Package Content with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package content fails when using an invalid resource identifier
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET Individual VNF Package Content with invalid resource identifier
    Check HTTP Response Status Code Is    404

GET Individual VNF Package Content with conflict due to onboarding state
    [Documentation]    Test ID: 7.3.3.3.6
    ...    Test title: GET Individual VNF Package Content with conflict due to onboarding state
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package content fails due to a conflict when the VNF Package is not in onboarding state ONBOARDED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the VNF package for which the content is requested is different from ONBOARDED.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET Content for VNF Package in onboarding state different from ONBOARDED
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Individual VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.7
    ...    Test title: POST Individual VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF Package content
    ...    Pre-conditions: none
    ...    Reference: clause 10.4.3.5.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for individual VNF Package
    Check HTTP Response Status Code Is    405

PUT Individual VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.8
    ...    Test title: PUT Individual VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a VNF Package content
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.3.5.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for individual VNF Package
    Check HTTP Response Status Code Is    405

PATCH Individual VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.9
    ...    Test title: PATCH Individual VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that PATCH  method is not allowed to update a VNF Package content
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.3.5.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for individual VNF Package
    Check HTTP Response Status Code Is    405

DELETE Individual VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.10
    ...    Test title: DELETE Individual VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that DELETE  method is not allowed to delete a VNF Package content
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.3.5.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package content is not deleted by the failed operation
    Send DELETE Request for individual VNF Package
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Package Content Exist
    
GET Individual OnBoarded VNF Package Content
    [Documentation]    Test ID: 7.3.3.3.11
    ...    Test title: GET Individual OnBoarded VNF Package Content
    ...    Test objective: The objective is to test the retrieval of an individual OnBoarded VNF package content and perform a validation that returned content is in zip format
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Individual OnBoarded VNF Package Content 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip

GET Individual OnBoarded VNF Package Content with Range Request and NFVO supporting Range Requests
    [Documentation]    Test ID: 7.3.3.3.12
    ...    Test title: GET Individual OnBoarded VNF Package Content with Range Request and NFVO supporting Range Requests
    ...    Test objective: The objective is to test the retrieval of an individual OnBoarded VNF package content when using a range request to return single range of bytes from the file, with the NFVO supporting it. The test also perform a validation that returned content matches the issued range
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports range requests to return single range of bytes from the VNF package file
    ...    Post-Conditions: none
    GET Individual OnBoarded VNF Package Content with Range Request
    Check HTTP Response Status Code Is    206
    Check HTTP Response Header Content-Type Is    application/zip
    Check HTTP Response Header Content-Range Is Present and Matches the requested range
    Check HTTP Response Header Content-Length Is Present and Matches the requested range length

GET Individual OnBoarded VNF Package Content with Range Request and NFVO not supporting Range Requests
    [Documentation]    Test ID: 7.3.3.3.13
    ...    Test title: GET Individual OnBoarded VNF Package Content with Range Request and NFVO not supporting Range Requests
    ...    Test objective: The objective is to test that the retrieval of an individual OnBoarded VNF package content, when using a range request to return single range of bytes from the file and the NFVO not supporting it, returns the full VNF Package file.
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO does not support range requests to return single range of bytes from the VNF package file
    ...    Post-Conditions: none    
     GET Individual OnBoarded VNF Package Content with Range Request
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip    

GET Individual OnBoarded VNF Package Content with invalid Range Request
    [Documentation]    Test ID: 7.3.3.3.14
    ...    Test title: GET Individual OnBoarded VNF Package Content with invalid Range Request
    ...    Test objective: The objective is to test that the retrieval of an individual OnBoarded VNF package content fails when using a range request that does not match any available byte range in the file.
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports range requests to return single range of bytes from the VNF package file
    ...    Post-Conditions: none      
    GET Individual OnBoarded VNF Package Content with invalid Range Request
    Check HTTP Response Status Code Is    416
    
GET Individual OnBoarded VNF Package Content with invalid resource identifier
    [Documentation]    Test ID: 7.3.3.3.15
    ...    Test title: GET Individual OnBoarded VNF Package Content with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual OnBoarded VNF package content fails when using an invalid resource identifier
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    GET Individual OnBoarded VNF Package Content with invalid resource identifier
    Check HTTP Response Status Code Is    404

GET Individual OnBoarded VNF Package Content with conflict due to onboarding state
    [Documentation]    Test ID: 7.3.3.3.16
    ...    Test title: GET Individual OnBoarded VNF Package Content with conflict due to onboarding state
    ...    Test objective: The objective is to test that the retrieval of an individual VNF package content fails due to a conflict when the VNF Package is not in onboarding state ONBOARDED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the VNF package for which the content is requested is different from ONBOARDED.
    ...    Reference: clause 10.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET Content for OnBoarded VNF Package in onboarding state different from ONBOARDED
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Individual OnBoarded VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.17
    ...    Test title: POST Individual OnBoarded VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF Package content
    ...    Pre-conditions: none
    ...    Reference: clause 10.4.3.5.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for individual OnBoarded VNF Package
    Check HTTP Response Status Code Is    405

PUT Individual OnBoarded VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.18
    ...    Test title: PUT Individual OnBoarded VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a VNF Package content
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.3.5.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for individual OnBoarded VNF Package
    Check HTTP Response Status Code Is    405

PATCH Individual OnBoarded VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.9
    ...    Test title: PATCH Individual OnBoarded VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that PATCH  method is not allowed to update a VNF Package content
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.3.5.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for individual OnBoarded VNF Package
    Check HTTP Response Status Code Is    405

DELETE Individual OnBoarded VNF Package Content - Method not implemented
    [Documentation]    Test ID: 7.3.3.3.10
    ...    Test title: DELETE Individual OnBoarded VNF Package Content - Method not implemented
    ...    Test objective: The objective is to test that DELETE  method is not allowed to delete a VNF Package content
    ...    Pre-conditions: One or more VNF packages are onboarded in the NFVO.
    ...    Reference: clause 10.4.3.5.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The VNF Package content is not deleted by the failed operation
    Send DELETE Request for individual OnBoarded VNF Package
    Check HTTP Response Status Code Is    405
    GET Individual OnBoarded VNF Package Content