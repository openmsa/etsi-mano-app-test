*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualVnfIndicator.txt
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}    ssl_verify=false

*** Test Cases ***
Get Individual Indicator for VNF Instance
    [Documentation]    Test ID: 6.3.2.3.1
    ...    Test title: Get individual performance indicator for a VNF instance
    ...    Test objective: The objective is to test the retrieval of a performance indicator for a given VNF instance and perform a JSON schema validation of the returned indicator data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of performance indicator is available for the given VNF instance.
    ...    Reference: Clause 8.4.4.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get Individual Indicator for a VNF instance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicator
    Check HTTP Response Body Includes Requested VNF Instance ID
    Check HTTP Response Body Includes Requested Indicator ID

Get Individual Indicator for VNF Instance with invalid indicator identifier
    [Documentation]    Test ID: 6.3.2.3.2
    ...    Test title: Get individual performance indicator for a VNF instance with invalid indicator identifier
    ...    Test objective: The objective is to test that the retrieval of a performance indicator for a given VNF instance fails when using an invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of performance indicator is available for the given VNF instance.
    ...    Reference: Clause 8.4.4.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get Individual Indicator for a VNF instance with invalid indicator identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Individual VNF Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.3
    ...    Test title: POST individual performance indicator for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new performance indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: Clause 8.4.4.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send POST Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405

PUT Individual VNF Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.4
    ...    Test title: PUT individual performance indicator for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an existing performance indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of performance indicator is available for the given VNF instance.
    ...    Reference: Clause 8.4.4.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PUT Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405

PATCH Individual VNF Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.5
    ...    Test title: PATCH individual performance indicator for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update an existing performance indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of performance indicator is available for the given VNF instance.
    ...    Reference: Clause 8.4.4.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PATCH Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405

DELETE Individual VNF Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.6
    ...    Test title: DELETE individual performance indicator indicators for VNF instance - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete an existing performance indicator for a VNF instance
    ...    Pre-conditions: A VNF instance is instantiated. At least one measure of performance indicator is available for the given VNF instance.
    ...    Reference: Clause 8.4.3.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The individual performance indicator for the VNF instance is not deleted by the unsuccessful operation
    Send DELETE Request for individual indicator in VNF instance
    Check HTTP Response Status Code Is    405
    Check Postcondition Indicator for VNF instance Exist
    
Get Individual Performance Indicator
    [Documentation]    Test ID: 6.3.2.3.7
    ...    Test title: Get Individual Performance Indicator 
    ...    Test objective: The objective is to test the retrieval of a performance indicator and perform a JSON schema validation of the returned indicator data structure
    ...    Pre-conditions: At least one measure of performance indicator is available..
    ...    Reference: Clause 8.4.4.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get Individual Indicator
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfIndicator
    Check HTTP Response Body Includes Requested Indicator ID

Get Individual Performance Indicator with invalid indicator identifier
    [Documentation]    Test ID: 6.3.2.3.8
    ...    Test title: Get Individual Performance Indicator with invalid indicator identifier
    ...    Test objective: The objective is to test that the retrieval of a performance indicator fails when using an invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: At least one measure of performance indicator is available.
    ...    Reference: Clause 8.4.4.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get Individual Indicator with invalid indicator identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Individual Performance Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.9
    ...    Test title: POST Individual Performance Indicator - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new performance indicator.
    ...    Pre-conditions: 
    ...    Reference: Clause 8.4.4.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send POST Request for individual indicator
    Check HTTP Response Status Code Is    405

PUT Individual Performance Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.10
    ...    Test title: PUT Individual Performance Indicator - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an existing performance indicator.
    ...    Pre-conditions: At least one measure of performance indicator is available.
    ...    Reference: Clause 8.4.4.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PUT Request for individual indicator
    Check HTTP Response Status Code Is    405

PATCH Individual Performance Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.11
    ...    Test title: PATCH Individual Performance Indicator - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update an existing performance indicator.
    ...    Pre-conditions: At least one measure of performance indicator is available.
    ...    Reference: Clause 8.4.4.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send PATCH Request for individual indicator
    Check HTTP Response Status Code Is    405

DELETE Individual Performance Indicator - Method not implemented
    [Documentation]    Test ID: 6.3.2.3.12
    ...    Test title: DELETE Individual Performance Indicator - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete an existing performance indicator.
    ...    Pre-conditions: At least one measure of performance indicator is available.
    ...    Reference: Clause 8.4.3.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: 
    Send DELETE Request for individual indicator
    Check HTTP Response Status Code Is    405
    Check PostCondition Individual Indicator exist
    
*** Keywords ***
Get Individual Indicator for a VNF instance
    Log    This resource represents a VNF indicator related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get Individual Indicator for a VNF instance with invalid indicator identifier
    Log    Trying to perform a negative get, using wrong identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${erroneousIndicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for individual indicator in VNF instance
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${notAllowedIndicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual indicator in VNF instance
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for individual indicator in VNF instance
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     
Send DELETE Request for individual indicator in VNF instance
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
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

Check HTTP Response Body Includes Requested Indicator ID
    Log    Check Response includes propoer VNF instance and Indicator identifiers
    Should Be Equal As Strings   ${response['body']['id']}    ${indicatorId}

Check HTTP Response Body Includes Requested VNF Instance ID
    Log    Check Response includes propoer VNF instance and Indicator identifiers
    Should Be Equal As Strings   ${response['body']['vnfInstanceId']}    ${vnfInstanceId}

Check Postcondition Indicator for VNF instance Exist
    Log    Check Response includes VNF Indicator
    Get Individual Indicator for a VNF instance
    Should Be Equal As Strings   ${response['body']['vnfInstanceId']}    ${vnfInstanceId}
    Should Be Equal As Strings   ${response['body']['id']}    ${indicatorId}

Get Individual Indicator
    Log    This resource represents a VNF indicator related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get Individual Indicator with invalid indicator identifier
    Log    Trying to perform a negative get, using wrong identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${erroneousIndicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send POST Request for individual indicator
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${notAllowedIndicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PUT Request for individual indicator
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for individual indicator
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for individual indicator
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Check PostCondition Individual Indicator exist
    Log    This resource represents a VNF indicator related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    Integer    response status    200	