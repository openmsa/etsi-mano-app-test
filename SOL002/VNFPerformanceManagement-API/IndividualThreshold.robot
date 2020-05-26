*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library           OperatingSystem
Resource          environment/individualThresholds.txt

*** Test Cases ***
GET Individual Threshold
    [Documentation]    Test ID: 6.3.3.5.1
    ...    Test title: GET Individual Threshold
    ...    Test objective: The objective is to test the retrieval of an individual VNF performance threshold and perform a JSON schema and content validation of the collected threshold data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: clause 6.4.6.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual VNF Performance Threshold
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Threshold
    Check HTTP Response Body Threshold Identifier matches the requested Threshold

GET Individual Threshold with invalid resource identifier
    [Documentation]    Test ID: 6.3.3.5.2
    ...    Test title: GET Individual Threshold with invalid resource identifier
    ...    Test objective: The objective is to test that the retrieval of an individual VNF performance threshold fails when using an invalid resource identifier
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance jobs are set in the VNFM.
    ...    Reference: clause 6.4.6.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    GET individual VNF Performance Threshold with invalid resource identifier
    Check HTTP Response Status Code Is    404

DELETE Individual Threshold
    [Documentation]    Test ID: 6.3.3.5.3
    ...    Test title: DELETE Individual Threshold
    ...    Test objective: The objective is to test the deletion of an individual VNF performance threshold
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: clause 6.4.6.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Threshold is not available anymore in the VNFM    
    Send Delete request for individual VNF Performance Threshold
    Check HTTP Response Status Code Is    204
    Check Postcondition VNF Performance Threshold is Deleted

DELETE Individual Threshold with invalid resource identifier
    [Documentation]    Test ID: 6.3.3.5.4
    ...    Test title: DELETE Individual Threshold with invalid resource identifier
    ...    Test objective: The objective is to test the deletion of an individual VNF performance threshold
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: clause 6.4.6.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Send Delete request for individual VNF Performance Threshold with invalid resource identifier
    Check HTTP Response Status Code Is    404

POST Individual Threshold - Method not implemented
    [Documentation]    Test ID: 6.3.3.5.5
    ...    Test title: POST Individual Threshold - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF Performance Threshold
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference: clause 6.4.6.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Threshold is not created on the VNFM
    Send Post request for individual VNF Performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Threshold is not Created

PUT Individual Threshold - Method not implemented
    [Documentation]    Test ID: 6.3.3.5.6
    ...    Test title: PUT Individual Threshold - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing VNF Performance threshold
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: clause 6.4.6.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Threshold is not modified by the operation
    Send Put request for individual VNF Performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Threshold is Unmodified (Implicit)

PATCH Individual Threshold - Method not implemented
    [Documentation]    Test ID: 6.3.3.5.7
    ...    Test title: PATCH Individual Threshold - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing VNF Performance threshold
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance thresholds are set in the VNFM.
    ...    Reference: clause 6.4.6.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF Performance Threshold is not modified by the operation
    Send Patch request for individual VNF Performance Threshold
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Threshold is Unmodified (Implicit)

*** Keywords ***
GET Individual VNF Performance Threshold
    Log    Trying to get a Threhsold present in the VNFM
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

GET individual VNF Performance Threshold with invalid resource identifier
    Log    Trying to get a Threhsold with invalid resource endpoint
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Delete request for individual VNF Performance Threshold
    Log    Trying to delete a Threhsold in the VNFM
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Delete request for individual VNF Performance Threshold with invalid resource identifier
    Log    Trying to delete a Threhsold in the VNFM with invalid id
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Post request for individual VNF Performance Threshold
    Log    Trying to create new threshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${newThresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Put request for individual VNF Performance Threshold
    Log    Trying to PUT threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Patch request for individual VNF Performance Threshold
    Log    Trying to PUT threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Check Postcondition VNF Performance Threshold is Unmodified (Implicit)
    Log    Check postconidtion threshold not modified
    GET individual VNF Performance Threshold
    Log    Check Response matches original VNF Threshold
    ${threshold}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origresponse['body']['id']}    ${threshold.id}
    Should Be Equal    ${origresponse['body']['criteria']}    ${threshold.criteria}
    
Check Postcondition VNF Performance Threshold is not Created
    Log    Trying to get a new Threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${newThresholdId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    Check HTTP Response Status Code Is    404

Check Postcondition VNF Performance Threshold is Deleted
    Log    Check Postcondition Threshold is deleted
    GET individual VNF Performance Threshold
    Check HTTP Response Status Code Is    404
    
Check HTTP Response Body Threshold Identifier matches the requested Threshold
    Log    Trying to check response ID
    Should Be Equal    ${response['body']['id']}    ${thresholdId} 
    Log    Pm Job identifier as expected
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response['status']}    ${status} 
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK


