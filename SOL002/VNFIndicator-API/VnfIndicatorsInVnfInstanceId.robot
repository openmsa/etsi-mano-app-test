*** Settings ***
Documentation     This resource represents VNF indicators related to a VNF instance. The client can use this resource to query multiple VNF indicators that are related to a particular VNF instance.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/vnfIndicatorinVnfInstance.txt
Library           JSONLibrary
Library           String 
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}    ssl_verify=false

*** Test Cases ***
Get Indicators for VNF Instance
    [Documentation]    Test ID: 6.3.2.2.1
    ...    Test title: Get all performance indicators for a VNF instance
    ...    Test objective: The objective is to test the retrieval of all performance indicators for a given VNF instance and perform a JSON schema validation of the returned indicators data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get all indicators for a VNF instance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body Includes Requested VNF Instance ID

GET Indicators for VNF Instance with attribute-based filter
    [Documentation]    Test ID: 6.3.2.2.2
    ...    Test title: Get all performance indicators for a VNF instance with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of all performance indicators for a given VNF instance using attribute-based filter and perform a JSON schema validation of the returned indicators data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get all indicators for a VNF instance with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body Matches Attribute-Based Filter

Get Indicators for VNF Instance with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.2.2.3
    ...    Test title: Get all performance indicators for a VNF instance with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of all performance indicators for a given VNF instance fails using invalid attribute-based filter. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all indicators for a VNF instance with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get Indicators for VNF Instance with invalid resource identifier
    [Documentation]    Test ID: 6.3.2.2.4
    ...    Test title: Get all performance indicators for a VNF instance with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of all performance indicators for a given VNF instance fails when using invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all indicators for a VNF instance with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 6.3.2.2.5
    ...    Test title: POST performance indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new performance indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: Clause 8.4.3.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send POST Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405

PUT Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 6.3.2.2.6
    ...    Test title: PUT performance indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify existing performance indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PUT Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405

PATCH Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 6.3.2.2.7
    ...    Test title: PATCH performance indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update existing performance indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PATCH Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405

DELETE Indicators for VNF instance - Method not implemented
    [Documentation]    Test ID: 6.3.2.2.8
    ...    Test title: DELETE performance indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete performance indicators for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The indicators for the VNF instance are not deleted by the unsuccessful operation
    Send DELETE Request for indicators in VNF instance
    Check HTTP Response Status Code Is    405
    Check Postcondition Indicators for VNF instance Exist
    
Get Indicators for VNF Instance to get Paged Response
    [Documentation]    Test ID: 6.3.2.2.9
    ...    Test title: Get Indicators for VNF Instance to get Paged Response
    ...    Test objective: The objective is to test the retrieval of all performance indicators for a given VNF instance to get paged response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get all indicators for a VNF instance
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
Get Indicators for VNF Instance - Bad Request Response too Big
    [Documentation]    Test ID: 6.3.2.2.10
    ...    Test title: Get Indicators for VNF Instance - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of all performance indicators for a given VNF instance fails when response is too big. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of performance indicators are available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all indicators for a VNF instance
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

*** Keywords ***
Get all indicators for a VNF instance
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get all indicators for a VNF instance with filter  
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
       
Get all indicators for a VNF instance with invalid filter
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all indicators for a VNF instance with invalid resource identifier
    Log    Trying to perform a negative get, using wrong identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${erroneousVnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for indicators in VNF instance
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for indicators in VNF instance
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for indicators in VNF instance
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     
Send DELETE Request for indicators in VNF instance
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response['status']}    ${status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Log    ${response['headers']}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Check HTTP Response Body Includes Requested VNF Instance ID
    Log    Check Response includes Indicators according to resource identifier
    Should Be Equal As Strings   ${response['body']['vnfInstanceId']}    ${vnfInstanceId}
    
Check HTTP Response Body Matches Attribute-Based Filter
    Log    Check Response includes VNF Indicators according to filter
    @{words} =  Split String    ${POS_FIELDS}       ,${SEPERATOR} 
    Should Be Equal As Strings    ${response['body'][0]['name']}    @{words}[1]

Check Postcondition Indicators for VNF instance Exist
    Log    Check Postcondition Indicators for VNF instance Exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Should Be Equal    ${response['status']}    200
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}