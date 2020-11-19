*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    environment/pmJobs.txt
Resource    environment/IndividualPmJob.txt
Resource    environment/reports.txt
Resource    environment/thresholds.txt
Resource    environment/individualThresholds.txt
Resource    environment/individualSubscription.txt
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process
Library    String

*** Keywords ***
GET all NS Performance Monitoring Jobs
    Log    Trying to get all PM Jobs present in the NFVO
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with attribute-based filter
    Log    Trying to get all PM Jobs present in the NFVO, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${POS_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with all_fields attribute selector
    Log    Trying to get all PM Jobs present in the NFVO, using 'all_fields' filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with exclude_default attribute selector
    Log    Trying to get all NS Packages present in the NFVO, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with include attribute selector
    Log    Trying to get all NS Packages present in the NFVO, using filter params
    Pass Execution If    ${FIELD_USAGE} == 0    Skipping test as NFVO is not supporting 'fields'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?include=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with exclude attribute selector
    Log    Trying to get all NS Packages present in the NFVO, using filter params
    Pass Execution If    ${FIELD_USAGE} == 0    Skipping test as NFVO is not supporting 'fields'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?exclude=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with invalid attribute-based filter
    Log    Trying to get all PM Jobs present in the NFVO, using an erroneous filter param
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs?${NEG_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NS Performance Monitoring Jobs with invalid resource endpoint    
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_job    # wrong URI /pm_job instead of /pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post Request Create new NS Performance Monitoring Job
    Log    Creating a new PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/CreatePmJobRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for all NS Performance Monitoring Jobs 
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PATCH Request for all NS Performance Monitoring Jobs 
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all NS Performance Monitoring Jobs 
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NS Performance Monitoring Jobs Exist
    Log    Checking that Pm Job still exists
    GET all NS Performance Monitoring Jobs
    
Check Postcondition PmJob Exists
    Log    Checking that Pm Job exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmJob
    
Check HTTP Response Body PmJobs Matches the requested exclude selector
    Log    Checking that reports element is missing
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Should Be Empty    ${reports}
    Log    Checking that reports element is missing
    ${criteria}=    Get Value From Json    ${response['body']}    $..criteria
    Should Be Empty    ${criteria}
    Log    Reports element is empty as expected

Check HTTP Response Body PmJobs Matches the requested include selector
    Log    Trying to validate criteria schema
    ${criteria}=    Get Value From Json    ${response['body']}    $..criteria
    Validate Json    criteria.schema.json    ${criteria}
    Log    Validation for criteria schema OK
    Log    Trying to validate criteria schema
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Validate Json    reports.schema.json    ${reports}
    Log    Validation for reports schema OK
    
Check HTTP Response Body PmJobs Matches the requested exclude_default selector
    Log    Checking that reports element is missing
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Should Be Empty    ${reports}
    Log    Reports element is empty as expected

Check HTTP Response Body PmJobs Matches the requested all_fields selector
    Log    Trying to validate criteria schema
    ${criteria}=    Get Value From Json    ${response['body']}    $..criteria
    Validate Json    criteria.schema.json    ${criteria}
    Log    Validation for criteria schema OK
    Log    Trying to validate criteria schema
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Validate Json    reports.schema.json    ${reports}
    Log    Validation for reports schema OK
    Log    Validating _links schema
    ${links}=    Get Value From Json    ${response['body']}    $.._links
    Validate Json    links.schema.json    ${links}
    Log    Validation for _links schema OK
    
Check HTTP Response Body PmJobs Matches the requested Attribute-Based Filter 
    Log    Checking that attribute-based filter is matched
    ${user}=    Get Value From Json    ${response['body']}    $..userDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

Check HTTP Response Body PmJobs Do Not Contain reports
    Log    Checking that field element is missing
    ${reports}=    Get Value From Json    ${response['body']}    $..reports
    Should Be Empty    ${reports}
    Log    Reports element is empty as expected

GET individual NS Performance Job
    Log    Trying to get a Pm Job present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET individual NS Performance Job with invalid resource identifier  
    Log    Trying to perform a negative get, using erroneous PM Job identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual NS Performance Job
    Log    Trying to delete an existing PM Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Delete request for individual NS Performance Job with invalid resource identifier
    Log    Trying to perform a negative delete, using erroneous PM Job identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${erroneousPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual NS Performance Job    
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${newPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Put request for individual NS Performance Job    
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Patch request for individual NS Performance Job    
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NS Performance Job is not Created
    Log    Trying to get a new Pm Job
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${newPmJobId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Check Postcondition NS Performance Job is Unmodified (Implicit)
    Log    Check Postcondition VNF PM job is not modified
    GET individual NS Performance Job
    Log    Check Response matches original VNF Pm Job
    ${pmJob}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origresponse['body']['id']}    ${pmJob.id}
    Should Be Equal    ${origresponse['body']['criteria']}    ${pmJob.criteria}
    Should Be Equal    ${origresponse['body']['_links']}    ${pmJob._links}

Check Postcondition NS Pm Job is Deleted
    Log    Check Postcondition
    GET individual NS Performance Job
    Check HTTP Response Status Code Is    404

Check HTTP Response Body Pm Job Identifier matches the requested Pm Job
    Log    Going to validate Pm Job info retrieved
    Should Be Equal    ${response['body']['id']}    ${pmJobId} 
    Log    Pm Job identifier as expected

Get Individual Performance Report
    Log    Trying to get a performance report present in the NFVO
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get Individual Performance Report with invalid resource endpoint
    Log    Trying to get a performance report with invalid resource endpoint
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${erroneousReportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for Individual Performance Report
    Log    Trying to create new performance report
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${newReportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Put request for Individual Performance Report
    Log    Trying to update performance report
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Patch request for Individual Performance Report
    Log    Trying to update performance report
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for Individual Performance Report
    Log    Trying to delete performance report   
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${reportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NS Individual Performance Report Exists
    Log    Checking that report still exists
    Get Individual Performance Report

Check Postcondition NS Individual Performance Report is not Created
    Log    Trying to get a new report
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pm_jobs/${pmJobId}/reports/${newReportId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Check Postcondition NS Individual Performance Report is Unmodified (Implicit)
    Log    Check Postcondition VNF PM job is not modified
    Get Individual Performance Report
    Log    Check Response matches original VNF report
    ${report}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origResponse['body']['entries'][0]['objectInstanceId']}    ${report['entries'][0]['objectInstanceId']}

GET all Performance Thresholds
    Log    Trying to get all thresholds present in the NFVO    
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Performance Thresholds with attribute-based filter
    Log    Trying to get thresholds present in the NFVO with filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_OK_Threshold}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Performance Thresholds with invalid attribute-based filter
    Log    Trying to get thresholds present in the NFVO with invalid filter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds?${FILTER_KO}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET NS performance Thresholds with invalid resource endpoint
    Log    Trying to get thresholds present in the NFVO with invalid resource endpoint
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/threshold
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post Request Create new Performance Threshold
    Log    Creating a new THreshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${request}=    Get File    jsons/CreateThresholdRequest.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds    ${request}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for all Performance Thresholds
    Log    PUT THresholds
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for all Performance Thresholds
    Log    PUT THresholds
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for all Performance Thresholds
    Log    DELETE THresholds
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Thresholds Exist
    Log    Checking that Thresholds still exists
    GET all Performance Thresholds
    
Check Postcondition Threshold Exists
    Log    Checking that Threshold exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Threshold
        
Check HTTP Response Body Thresholds match the requested attribute-based filter
    Log    Checking that attribute-based filter is matched
    @{words} =    Split String    ${FILTER_OK_Threshold}       ,${SEPERATOR} 
    Should Be Equal As Strings    ${response['body'][0]['objectInstanceId']}    @{words}[1]
    

GET Individual NS performance Threshold
    Log    Trying to get a Threhsold present in the NFVO
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET individual NS performance Threshold with invalid resource identifier
    Log    Trying to get a Threhsold with invalid resource endpoint
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual NS performance Threshold
    Log    Trying to delete a Threhsold in the NFVO
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual NS performance Threshold with invalid resource identifier
    Log    Trying to delete a Threhsold in the NFVO with invalid id
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${erroneousThresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual NS performance Threshold
    Log    Trying to create new threshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${newThresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Put request for individual NS performance Threshold
    Log    Trying to PUT threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Patch request for individual NS performance Threshold
    Log    Trying to PUT threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${thresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NS performance Threshold is Unmodified (Implicit)
    Log    Check postconidtion threshold not modified
    GET individual NS performance Threshold
    Log    Check Response matches original VNF Threshold
    ${threshold}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origresponse['body']['id']}    ${threshold.id}
    Should Be Equal    ${origresponse['body']['criteria']}    ${threshold.criteria}
    
Check Postcondition NS performance Threshold is not Created
    Log    Trying to get a new Threshold
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/thresholds/${newThresholdId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Check Postcondition NS performance Threshold is Deleted
    Log    Check Postcondition Threshold is deleted
    GET individual NS performance Threshold
    Check HTTP Response Status Code Is    404
    
Check HTTP Response Body Threshold Identifier matches the requested Threshold
    Log    Trying to check response ID
    Should Be Equal    ${response['body']['id']}    ${thresholdId} 
    Log    Pm Job identifier as expected



Get all NS Performance Subscriptions
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NS Performance Subscriptions with attribute-based filters
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NS Performance Subscriptions with invalid attribute-based filters
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NS Performance Subscriptions with invalid resource endpoint
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Send Post Request for NS Performance Subscription
    [Documentation]    The POST method creates a new subscription
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.1-1 and 7.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the OSS, and might make sense only in very rare use cases.
    ...    Consequently, the NFVO may either allow creating a subscription resource if another subscription resource with the
    ...    same filter and callbackUri already exists (in which case it shall return the "201 Created" response code), or may decide
    ...    to not create a duplicate subscription resource (in which case it shall return a "303 See Other" response code referencing
    ...    the existing subscription resource with the same filter and callbackUri).
    Set headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body_request}=    Get File    jsons/subscriptions.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body_request}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...    Check Notification Endpoint    


Send Post Request for Duplicated NS Performance Subscription
    [Documentation]    The POST method creates a new subscription
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.1-1 and 7.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the OSS, and might make sense only in very rare use cases.
    ...    Consequently, the NFVO may either allow creating a subscription resource if another subscription resource with the
    ...    same filter and callbackUri already exists (in which case it shall return the "201 Created" response code), or may decide
    ...    to not create a duplicate subscription resource (in which case it shall return a "303 See Other" response code referencing
    ...    the existing subscription resource with the same filter and callbackUri).
    Set headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body_request}=    Get File    jsons/subscriptions.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body_request}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT}
    ...       Check Notification Endpoint



Send Put Request for NS Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the NFVO shall return a "405 Method
    ...    Not Allowed" response as defined in Clause 4.3.5.4.
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send Patch Request for NS Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the NFVO shall return a "405 Method
    ...    Not Allowed" response as defined in Clause 4.3.5.4.
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send Delete Request for NS Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the NFVO shall return a "405 Method
    ...    Not Allowed" response as defined in Clause 4.3.5.4.
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
    Log    Status code validated 
    
    
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK  


Check HTTP Response Body Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  


Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes NS Package Management according to filter
    @{words} =  Split String    ${filter_ok}       ,${SEPERATOR} 
    Should Be Equal As Strings    ${response['body'][0]['callbackUri']}    @{words}[1]

Check HTTP Response Body PmSubscription Attributes Values Match the Issued Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}


Check Postcondition NS Performance Subscription Is Set
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    
    
Check Postcondition Subscription Resource URI Returned in Location Header Is Available
    Log    Going to check postcondition
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${response['headers']['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    PmSubscriptions.schema.json    ${result}
    Log    Validated PmSubscriptions schema
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${result['callbackUri']}    ${subscription['callbackUri']}
    Log    Validated Issued subscription is same as original
        
Get Individual NS Performance Subscription
    Log    Trying to get a single subscription identified by subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET individual NS Performance Subscription with invalid resource identifier
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual NS Performance Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NS Performance Subscription is Deleted
    Log    Check Postcondition Subscription is deleted
    GET individual NS Performance Subscription
    Check HTTP Response Status Code Is    404 

Send Delete request for individual NS Performance Subscription with invalid resource identifier
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual NS Performance Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Put request for individual NS Performance Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Patch request for individual NS Performance Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Check Postcondition NS Performance Subscription is Unmodified (Implicit)
    Log    Check postconidtion subscription not modified
    GET individual NS Performance Subscription
    Log    Check Response matches original VNF Threshold
    ${subscription}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origResponse['body']['id']}    ${subscription.id}
    Should Be Equal    ${origResponse['body']['callbackUri']}    ${subscription.callbackUri}

Check Postcondition NS Performance Subscription is not Created
    Log    Trying to get a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Check HTTP Response Body Subscription Identifier matches the requested Subscription
    Log    Trying to check response ID
    Should Be Equal    ${response['body']['id']}    ${subscriptionId} 
    Log    Subscription identifier as expected    

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present


Create Sessions
    Pass Execution If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 0    MockServer not started as NFVO is not checking the notification endpoint
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}
    
    
Check Notification Endpoint
    &{notification_request}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${notification_request}
    Clear Requests  ${callback_endpoint}
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}

