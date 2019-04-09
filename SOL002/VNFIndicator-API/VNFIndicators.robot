*** Settings ***
Documentation     This clause defines all the resources and methods provided by the VNF Indicator interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/vnfIndicators.txt
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}

*** Test Cases ***
Get all VNF Indicators
    [Documentation]    Test ID: 6.3.2.1.1
    ...    Test title: Get all VNF Indicators
    ...    Test objective: The objective is to test the retrieval of all the available VNF indicators and perform a JSON schema validation of the collected indicators data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all VNF indicators
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    
Get VNF Indicators with attribute-based filter
    [Documentation]    Test ID: 6.3.2.1.2
    ...    Test title: Get VNF Indicators with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF indicators using attribute-based filter, perform a JSON schema validation of the collected indicators data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get VNF indicators with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body Matches Attribute-Based Filter

Get all VNF Indicators with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.2.1.3
    ...    Test title: Get VNF Indicators with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get VNF indicators with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get all VNF Indicators with invalid authorization token
    [Documentation]    Test ID: 6.3.2.1.4
    ...    Test title: GET all VNF Indicators One or more measures of VNF performance indicators are available in the VNF.
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails using invalid authorization token, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 4.5.3.3, 8.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all VNF indicators with invalid authorization token
    Check HTTP Response Status Code Is 40x
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get all VNF Indicators without authorization token
    [Documentation]    Test ID: 6.3.2.1.5
    ...    Test title: GET all VNF Indicators without authorization bearers
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails by omitting the authorization token, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 4.5.3.3, 8.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all VNF indicators without authorization token
    Check HTTP Response Status Code Is 40x
    Check HTTP Response Body Json Schema Is   ProblemDetails

Get all VNF Indicators with invalid resource endpoint
    [Documentation]    Test ID: 6.3.2.1.6
    ...    Test title: GET all VNF Indicators with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when using invalid resource endpoint, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get all VNF indicators with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST all VNF Indicators - Method not implemented
    [Documentation]    Test ID: 6.3.2.1.7
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF
    ...    Reference: section 8.4.2.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send POST Request for all VNF indicators
    Check HTTP Response Status Code Is    405

PUT all VNF Indicators - Method not implemented
    [Documentation]    Test ID: 6.3.2.1.8
    ...    Test title: PUT all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF
    ...    Reference: section 8.4.2.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PUT Request for all VNF indicators
    Check HTTP Response Status Code Is    405

PATCH all VNF Indicators - Method not implemented
     [Documentation]    Test ID: 6.3.2.1.9
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF
    ...    Reference: section 8.4.2.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PATCH Request for all VNF indicators
    Check HTTP Response Status Code Is    405

DELETE all VNF Indicators - Method not implemented
    [Documentation]    Test ID: 6.3.2.1.10
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF indicators
    ...    Pre-conditions: A VNF instance is instantiated. One or more measures of VNF performance indicators are available in the VNF
    ...    Reference: section 8.4.2.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send DELETE Request for all VNF indicators
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicators Exist
    
*** Keywords ***
Get all VNF indicators
    Log    The GET method queries multiple VNF indicators
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    ${body}=    evaluate    json.loads('''${response.body}''')    json
    Set Suite Variable    @{vnfIndicators}    ${body}
    
Get VNF indicators with filter
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get VNF indicators with invalid filter
    Log    The GET method queries multiple VNF indicators using invalid Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all VNF indicators with invalid authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all VNF indicators without authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get all VNF indicators with invalid resource endpoint
    Log    The GET method queries multiple VNF indicators omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for all VNF indicators
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PUT Request for all VNF indicators
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for all VNF indicators
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all VNF indicators
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response['status']}    ${status} 
    Log    Status code validated
    
Check HTTP Response Status Code Is 40x  
    Should Contain Any    ${response['status']}    401    403
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${schema}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Check Postcondition VNF Indicators Exist
    Log    Check  Postcondition indicators exist
    Get all VNF indicators
    Check HTTP Response Status Code Is    200
    
Check HTTP Response Body Matches Attribute-Based Filter
    Log    Check Response includes VNF Indicators according to filter
    #todo