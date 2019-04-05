*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Resource          environment/thresholds.txt
Library           OperatingSystem

*** Test Cases ***
GET All Performance Thresholds
    [Documentation]    Test ID: 6.3.3.4.1
    ...    Test title: GET all VNF Performance Thresholds
    ...    Test objective: The objective is to test the retrieval of all the available VNF performance thresholds and perform a JSON schema validation of the collected thresholds data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: section 6.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET all Performance Thresholds
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Thresholds

GET Performance Thresholds with attribute-based filter
    [Documentation]    Test ID: 6.3.3.4.2
    ...    Test title: GET VNF Performance Thresholds with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of all the available VNF performance thresholds when using attribute-based filters, perform a JSON schema validation of the collected thresholds data structure, and verify that the retrieved information matches the issued attribute-based filter
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: section 6.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Performance Thresholds with attribute-based filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Thresholds
    Check HTTP Response Body Matches filter

GET Performance Thresholds with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.3.4.3
    ...    Test title: GET VNF Performance Thresholds with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF performance thresholds fails when using invalid attribute-based filter, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: section 6.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET Performance Thresholds with invalid attribute-based filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET Performance Thresholds with invalid resource endpoint
    [Documentation]    Test ID: 6.3.3.4.4
    ...    Test title: GET VNF Performance Thresholds with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of VNF performance thresholds fails when using invalid resource endpoint, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: section 6.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET VNF Performance Thresholds with invalid resource endpoint
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

Create new Performance Threshold
    [Documentation]    Test ID: 6.3.3.4.5
    ...    Test title:  Create a new VNF Performance Threshold
    ...    Test objective: The objective is to test the creation of a new VNF performance threshold and perform the JSON schema validation of the returned threshold data structure
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 6.4.5.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Threshold is successfully created on the VNFM
    Send Post Request Create new Performance Threshold
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   Threshold
    Check HTTP Response Header Contains    Location
    Check Postcondition Threshold Exists

PUT Performance Thresholds - Method not implemented
    [Documentation]    Test ID: 6.3.3.4.5
    ...    Test title: PUT all VNF Performance Thresholds - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF Performance Thresholds
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNF.
    ...    Reference: section 6.4.5.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for all Performance Thresholds
    Check HTTP Response Status Code Is    405

PATCH Performance Thresholds - Method not implemented
    [Documentation]    Test ID: 6.3.3.4.6
    ...    Test title: PATCH all VNF Performance Thresholds - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify VNF Performance Thresholds
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: section 6.4.5.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PATCH Request for all Performance Thresholds
    Check HTTP Response Status Code Is    405

DELETE Performance Thresholds - Method not implemented
    [Documentation]    Test ID: 6.3.3.4.7
    ...    Test title: DELETE all VNF Performance Monitoring Thresholds - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to update VNF Performance Thresholds
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: section 6.4.5.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send DELETE Request for all Performance Thresholds
    Check HTTP Response Status Code Is    405
    Check Postcondition Thresholds Exist

*** Keywords ***
GET all Performance Thresholds
    Log    Trying to get all thresholds present in the VNFM    
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

GET Performance Thresholds with attribute-based filter
    Log    Trying to get thresholds present in the VNFM with filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_OK}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

GET Performance Thresholds with invalid attribute-based filter
    Log    Trying to get thresholds present in the VNFM with invalid filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_KO}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
GET VNF Performance Thresholds with invalid resource endpoint
    Log    Trying to get thresholds present in the VNFM with invalid resource endpoint
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/threshold
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Post Request Create new Performance Threshold
    Log    Creating a new THreshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${request}=    Get File    jsons/CreateThresholdRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds    ${request}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send PUT Request for all Performance Thresholds
    Log    PUT THresholds
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
Send PATCH Request for all Performance Thresholds
    Log    PUT THresholds
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send DELETE Request for all Performance Thresholds
    Log    DELETE THresholds
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Check Postcondition Thresholds Exist
    Log    Checking that Thresholds still exists
    GET all Performance Thresholds
    
Check Postcondition Threshold Exists
    Log    Checking that Threshold exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${response[0]['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Threshold
        
Check HTTP Response Body Matches filter
    Log    Checking that attribute-based filter is matched
    #todo
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response[0]['status']}    ${status} 
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response[0]['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response[0]['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK


