*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/reports.txt
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Test Cases ***
Get Individual Performance Report
    [Documentation]    Test ID: 6.3.3.3.1
    ...    Test title: Get Individual Performance Report
    ...    Test objective: The objective is to test the retrieval of an individual VNF performance report associated to a monitoring job and perform a JSON schema validation of the collected report data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance reports are set for a monitoring job in the VNFM.
    ...    Reference: section 6.4.4.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual Performance Report
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PerformanceReport

Get Individual Performance Report with invalid resource endpoint
        [Documentation]    Test ID: 6.3.3.3.2
    ...    Test title: Get Individual Performance Report
    ...    Test objective: The objective is to test the retrieval of an individual VNF performance report associated to a monitoring job and perform a JSON schema validation of the collected report data structure
    ...    Pre-conditions: A VNF instance is instantiated. One or more VNF performance reports are set for a monitoring job in the VNFM.
    ...    Reference: section 6.4.4.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get Individual Performance Report with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 6.3.3.3.3
    ...    Test title: POST Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF performance report within a monitoring job
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 6.4.4.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF performance report is not created on the VNFM
    Send Post request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Individual Performance Report is not Created

PUT Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 6.3.3.3.4
    ...    Test title: PUT Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to update an existing VNF performance report within a monitoring job
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 6.4.4.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF performance report is not modified by the operation
    Send Put request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Individual Performance Report is Unmodified (Implicit)

PATCH Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 6.3.3.3.5
    ...    Test title: PATCH Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify an existing VNF performance report within a monitoring job
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 6.4.4.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF performance report is not modified by the operation
    Send Patch request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Individual Performance Report is Unmodified (Implicit)

DELETE Individual Performance Report - Method not implemented
    [Documentation]    Test ID: 6.3.3.3.6
    ...    Test title: DELETE Individual Performance Report - Method not implemented
    ...    Test objective: The objective is to test that DELET method is not allowed to delete an existing VNF performance report within a monitoring job
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 6.4.4.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF performance report is not deleted by the operation
    Send Delete request for Individual Performance Report
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Individual Performance Report Exists

*** Keywords ***
Get Individual Performance Report
    Log    Trying to get a performance report present in the VNFM
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Get Individual Performance Report with invalid resource endpoint
    Log    Trying to get a performance report with invalid resource endpoint
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${erroneousReportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Post request for Individual Performance Report
    Log    Trying to create new performance report
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${newReportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Put request for Individual Performance Report
    Log    Trying to update performance report
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${origOutput}=    Output    response
    Set Suite Variable    @{origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
Send Patch request for Individual Performance Report
    Log    Trying to update performance report
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${origOutput}=    Output    response
    Set Suite Variable    @{origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Delete request for Individual Performance Report
    Log    Trying to delete performance report   
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Check Postcondition VNF Individual Performance Report Exists
    Log    Checking that report still exists
    Get Individual Performance Report

Check Postcondition VNF Individual Performance Report is not Created
    Log    Trying to get a new report
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${newReportId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    Check HTTP Response Status Code Is    404

Check Postcondition VNF Individual Performance Report is Unmodified (Implicit)
    Log    Check Postcondition VNF PM job is not modified
    Get Individual Performance Report
    Log    Check Response matches original VNF report
    ${report}=    evaluate    json.loads('''${response[0]['body']}''')    json
    Should Be Equal    ${origResponse[0]['body']['entries'][0]['objectInstanceId']}    ${report['entries'][0]['objectInstanceId']}

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

