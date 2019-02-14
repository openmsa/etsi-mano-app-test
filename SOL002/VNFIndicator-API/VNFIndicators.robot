*** Settings ***
Documentation     This clause defines all the resources and methods provided by the VNF Indicator interface. \
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Resource          environment/vnfIndicators.txt
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}

*** Test Cases ***
Get all VNF Indicators
    [Documentation]    Test ID 6.4.1
    ...    Test title: Get all VNF Indicators
    ...    Test objective: The objective is to test the retrieval of all the available VNF indicators
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Get all VNF indicators
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check Postcondition VNF Indicators Untouched (Implicit)
    
Get VNF Indicators with attribute-based filter
    [Documentation]    Test ID 6.4.2
    ...    Test title: Get VNF Indicators with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF indicators using attribute-based filter
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Get VNF indicators with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicators
    Check HTTP Response Body Matches Attribute-Based Filter
    Check Postcondition VNF Indicators Untouched (Implicit)

Get all VNF Indicators with invalid attribute-based filter
    [Documentation]    Test ID 6.4.3
    ...    Test title: Get VNF Indicators with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails using invalid attribute-based filters
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Get VNF indicators with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Indicators Untouched (Implicit)

Get all VNF Indicators with invalid authorization token
    [Documentation]    Test ID 6.4.4
    ...    Test title: GET all VNF Indicators One or more measures of VNF performance indicators are available in the VNF.
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails using invalid authorization token
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Get all VNF indicators with invalid authorization token
    Check HTTP Response Status Code Is    401
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Indicators Untouched (Implicit)

Get all VNF Indicators without authorization token
    [Documentation]    Test ID 6.4.5
    ...    Test title: GET all VNF Indicators without authorization bearers
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails by omitting the authorization token
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Get all VNF indicators without authorization token
    Check HTTP Response Status Code Is    401
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Indicators Untouched (Implicit)

Get all VNF Indicators with invalid resource endpoint
    [Documentation]    Test ID 6.4.6
    ...    Test title: GET all VNF Indicators with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF indicators fails when using invalid resource endpoint
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Get all VNF indicators with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Indicators Untouched (Implicit)

POST all VNF Indicators - Method not implemented
    [Documentation]    Test ID 6.4.7
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create new VNF indicators
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Send POST Request for all VNF indicators
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicators Untouched (Implicit) 

PUT all VNF Indicators - Method not implemented
    [Documentation]    Test ID 6.4.7
    ...    Test title: PUT all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF indicators
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Send PUT Request for all VNF indicators
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicators Untouched (Implicit) 

PATCH all VNF Indicators - Method not implemented
     [Documentation]    Test ID 6.4.8
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF indicators
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Send PATCH Request for all VNF indicators
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicators Untouched (Implicit) 

DELETE all VNF Indicators (Method not implemented)
    [Documentation]    Test ID 6.4.9
    ...    Test title: POST all VNF Indicators - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF indicators
    ...    Pre-conditions: A VNF instance is up and running. One or more measures of VNF performance indicators are available in the VNF.
    ...    Reference: section 8.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicators are not modified by the operation
    Send DELETE Request for all VNF indicators
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicators Untouched (Implicit) 
    
*** Keywords ***
Get all VNF indicators
    Log    The GET method queries multiple VNF indicators
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${vnfIndicators}=    evaluate    json.loads('''${response.body}''')    json
    
Get VNF indicators with filter
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators?${POS_FIELDS}

Get VNF indicators with invalid filter
    Log    The GET method queries multiple VNF indicators using invalid Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators?${NEG_FIELDS}

Get all VNF indicators with invalid authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators

Get all VNF indicators without authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    
Get all VNF indicators with invalid resource endpoint
    Log    The GET method queries multiple VNF indicators omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/indicator

Send POST Request for all VNF indicators
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    
Send PUT Request for all VNF indicators
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    
Send PATCH Request for all VNF indicators
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    
Send DELETE Request for all VNF indicators
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${schema}
    ${contentType}=    Get Value From Json    ${response.headers}    $..Content-Type
    Should Be Equal    ${contentType}    ${CONTENT_TYPE_JSON}
    ${json}=    evaluate    json.loads('''${response.body}''')    json
    Validate Json    ${schema}    ${json}
    Log    Json Schema Validation OK

Check Postcondition VNF Indicators Untouched (Implicit)
    Log    Check Implicit Postcondition
    ${input}=    evaluate    json.loads('''${vnfIndicators}''')    json
    Get all VNF indicators
    ${output}=    evaluate    json.loads('''${response.body}''')    json
    Should Be Equal  ${output}    ${input}

Check HTTP Response Body Matches Attribute-Based Filter
    Log    Check Response includes VNF Indicators according to filter
    #todo