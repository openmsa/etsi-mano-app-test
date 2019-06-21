*** Settings ***
Documentation     This clause defines the content of the individual NS descriptor, i.e. NSD content
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Resource          NSDManagementKeywords.robot
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library           OperatingSystem

*** Test Cases ***
Get single file NSD Content in Plain Format
    [Documentation]    Test ID: 5.3.1.3.1
    ...    Test title: Get single file NSD Content in Plain Format
    ...    Test objective: The objective is to test the retrieval of the NSD Content in plain format and perform a validation that returned content is in plain format
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NSD is implemented as a single file
    ...    Post-Conditions: none
    Get single file NSD Content in Plain Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    text/plain

Get NSD Content in Zip Format
    [Documentation]    Test ID: 5.3.1.3.2
    ...    Test title: Get NSD Content in Zip Format
    ...    Test objective: The objective is to test the retrieval of the NSD Content in zip format and perform a validation that returned content is in zip format
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get NSD Content in Zip Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip

Get single file NSD Content in Plain or Zip Format
    [Documentation]    Test ID: 5.3.1.3.3
    ...    Test title: Get single file NSD Content in Plain or Zip Format
    ...    Test objective: The objective is to test the retrieval of the single file NSD Content when requesting Plain or Zip format to NFVO by including both formats in the request, and perform a validation that returned content is in Plain or Zip format
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NSD Content is implemented as a single file
    ...    Post-Conditions: none
    Get single file NSD Content in Plain or Zip Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is Any of   text/plain    application/zip
    
Get multi file NSD Content in Plain or Zip Format
    [Documentation]    Test ID: 5.3.1.3.4
    ...    Test title: Get multi file NSD Content in Plain or Zip Format
    ...    Test objective: The objective is to test the retrieval of the multi file NSD Content when requesting Plain or Zip format to NFVO by including both formats in the request, and perform a validation that returned content is in Zip format
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NSD is implemented as a multi file
    ...    Post-Conditions: none
    Get multi file NSD Content in Plain or Zip Format
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip

Get multi file NSD Content in Plain Format
    [Documentation]    Test ID: 5.3.1.3.5
    ...    Test title: Get multi file NSD Content in Plain Format
    ...    Test objective: The objective is to test that the retrieval of the multi file NSD Content fails when requesting it in Plain format, and perform a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NSD Content is implemented as a multi file
    ...    Post-Conditions: none
    Get multi file NSD Content in Plain Format
    Check HTTP Response Status Code Is    406
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get NSD Content with invalid resource identifier
    [Documentation]    Test ID: 5.3.1.3.6
    ...    Test title: Get NSD Content with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of the NSD Content fails when using an invalid resource identifier
    ...    Pre-conditions: none
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Get NSD Content with invalid resource identifier
    Check HTTP Response Status Code Is    404

Get NSD Content with conflict due to onboarding state
    [Documentation]    Test ID: 5.3.1.3.7
    ...    Test title: Get NSD Content with conflict due to onboarding state
    ...    Test objective: The objective is to test that the retrieval of the NSD Content fails due to a conflict when the NSD is not in onboarding state ONBOARDED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the NSD for which the NSD Content is requested is different from ONBOARDED.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get NSD Content with conflict due to onboarding state
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET NSD Content with Range Request and NFVO supporting Range Requests
    [Documentation]    Test ID: 5.3.1.3.8
    ...    Test title: GET NSD Content with Range Request and NFVO supporting Range Requests
    ...    Test objective: The objective is to test the retrieval of NSD Content when using a range request to return single range of bytes from the file, with the NFVO supporting it. The test also perform a validation that returned content matches the issued range
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports range requests to return single range of bytes from the NSD file
    ...    Post-Conditions: none
    GET NSD Content with Range Request
    Check HTTP Response Status Code Is    206
    Check HTTP Response Header Content-Type Is    application/zip
    Check HTTP Response Header Content-Range Is Present and Matches the requested range
    Check HTTP Response Header Content-Length Is Present and Matches the requested range length

GET NSD Content with Range Request and NFVO not supporting Range Requests
    [Documentation]    Test ID: 5.3.1.3.9
    ...    Test title: GET NSD Content with Range Request and NFVO not supporting Range Requests
    ...    Test objective: The objective is to test that the retrieval of NSD Content, when using a range request to return single range of bytes from the file and the NFVO not supporting it, returns the full NSD file.
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO does not support range requests to return single range of bytes from the NSD file
    ...    Post-Conditions: none    
    GET NSD Content with Range Request
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Content-Type Is    application/zip    

GET NSD Content with invalid Range Request
    [Documentation]    Test ID: 5.3.1.3.10
    ...    Test title: GET NSD Content with invalid Range Request
    ...    Test objective: The objective is to test that the retrieval of NSD Content fails when using a range request that does not match any available byte range in the file.
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports range requests to return single range of bytes from the NSD file
    ...    Post-Conditions: none      
    GET NSD Content with invalid Range Request
    Check HTTP Response Status Code Is    416     
        
Upload NSD Content as Zip file in asynchronous mode
    [Documentation]    Test ID: 5.3.1.3.11
    ...    Test title: Upload NSD Content as Zip file in asynchronous mode
    ...    Test objective: The objective is to test the upload of an NSD Content in Zip format when the NFVO supports the asynchronous upload mode.
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the upload of NSD contents in asynchronous mode
    ...    Post-Conditions: none
    Send PUT Request to upload NSD Content as zip file in asynchronous mode
    Check HTTP Response Status Code Is    202
    
Upload NSD Content as plain text file in asynchronous mode
    [Documentation]    Test ID: 5.3.1.3.12
    ...    Test title: Upload NSD Content as plain text file in asynchronous mode
    ...    Test objective: The objective is to test the upload of an NSD Content in plain text format when the NFVO supports the asynchronous upload mode.
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the upload of NSD contents in asynchronous mode
    ...    Post-Conditions: none
    Send PUT Request to upload NSD Content as plain text file in asynchronous mode
    Check HTTP Response Status Code Is    202   
    
Upload NSD Content as Zip file in synchronous mode
    [Documentation]    Test ID: 5.3.1.3.13
    ...    Test title: Upload NSD Content as Zip file in synchronous mode
    ...    Test objective: The objective is to test the upload of an NSD Content in Zip format when the NFVO supports the synchronous upload mode.
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the upload of NSD contents in synchronous mode
    ...    Post-Conditions: The NSD content is successfully uploaded and available in the NFVO
    Send PUT Request to upload NSD Content as zip file in synchronous mode
    Check HTTP Response Status Code Is    204
    Check Postcondition NSD Content is uploaded and available in the NFVO
    
Upload NSD Content as plain text file in synchronous mode
    [Documentation]    Test ID: 5.3.1.3.14
    ...    Test title: Upload NSD Content as plain text file in synchronous mode
    ...    Test objective: The objective is to test the upload of an NSD Content in plain text format when the NFVO supports the synchronous upload mode.
    ...    Pre-conditions: One or more NSDs are onboarded in the NFVO.
    ...    Reference: section 5.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: The NFVO supports the upload of NSD contents in synchronous mode
    ...    Post-Conditions: The NSD content is successfully uploaded and available in the NFVO
    Send PUT Request to upload NSD Content as plain text file in synchronous mode
    Check HTTP Response Status Code Is    204 
    Check Postcondition NSD Content is uploaded and available in the NFVO
 
Upload NSD Content with conflict due to onboarding state
   [Documentation]    Test ID: 5.3.1.3.15
    ...    Test title: Upload NSD Content with conflict due to onboarding state
    ...    Test objective: The objective is to test that the upload of the NSD Content fails due to a conflict when the NSD is not in onboarding state CREATED in the NFVO. The test also performs a validation of the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: The onboarding state of the NSD for which the NSD Content is requested is different from ONBOARDED.
    ...    Reference: section 5.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    Send PUT Request to upload NSD Content with conflict due to onboarding state
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is   ProblemDetails             

POST NSD Content - Method not implemented
    [Documentation]    Test ID: 5.3.1.3.16
    ...    Test title: POST NSD Content - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new Network Service Descriptor content
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.4.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for NSD Content
    Check HTTP Response Status Code Is    405

PATCH NSD Content - Method not implemented
    [Documentation]    Test ID: 5.3.1.3.16
    ...    Test title: PATCH NSD Content - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update Network Service Descriptor content
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.4.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for NSD Content
    Check HTTP Response Status Code Is    405

DELETE NSD Content - Method not implemented
    [Documentation]    Test ID: 5.3.1.3.17
    ...    Test title: DELETE NSD Content - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete Network Service Descriptor content
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.4.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NSD content is not deleted by the failed operation
    Send DELETE Request for NSD Content
    Check HTTP Response Status Code Is    405
    Check Postcondition NSD Content Exists
