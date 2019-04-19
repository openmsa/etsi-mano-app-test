*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process    

*** Keywords ***
Get All VNF Indicators Subscriptions
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # Log    Received a 200 OK as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscriptions.schema.json    ${result}
    # Log    Validated VnfIndicatorSubscription schema


Get VNF Indicators Subscriptions with filter
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Received a 200 OK as expected
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscriptions.schema.json    ${result}
    # Log    Validated VnfIndicatorSubscriptions schema


Get VNF Indicators Subscriptions with invalid filter
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    400
    # Log    Received a 400 Bad Request as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK
    
    
Get VNF Indicators Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    404
    # Log    Received 404 Not Found as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK


Get VNF Indicators Subscriptions with invalid authentication token
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as VNFM is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    401
    # Log    Received 401 Unauthorized as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK    
    

Send Post Request for VNF Indicator Subscription
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${VNFM_CHECKS_NOTIF_ENDPOINT} == 1
    ...       Check Notification Endpoint
    # Integer    response status    201
    # Log    Received 201 Created as expected
    # ${headers}=    Output    response headers
    # Should Contain    ${headers}    Location
    # Log    Response has header Location
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscription.schema.json    ${result}
    # Log    Validation of VnfIndicatorSubscription OK



Send Post Request for Duplicated VNF indicator Subscription
    Log    Trying to create a subscription with an already created content
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    201
    # Log    Received 201 Created as expected
    # ${headers}=    Output    response headers
    # Should Contain    ${headers}    Location
    # Log    Response has header Location
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscription.schema.json    ${result}
    # Log    Validation of VnfIndicatorSubscription OK
    
    
Send Put Request for VNF Indicator Subscriptions
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Send Patch Request for VNF Indicator Subscriptions
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Send Delete Request for VNF Indicator Subscriptions
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

    
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response['status']}    ${expected_status}
    Log    Status code validated 
    
    
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK  


Check HTTP Response Body Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  


Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes VNF Performance Management according to filter
    #TODO


Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}



Check Postcondition VNF Indicator Subscription Is Set
    [Arguments]    ${location}=""
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Run Keyword If    Should Not Be Equal As Strings    ${location}    Location   GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    Run Keyword If    Should Be Equal As Strings    ${location}    Location   GET    ${response['headers']['Location']}  
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
    Log    Header is present


Create Sessions
    Pass Execution If    ${VNFM_CHECKS_NOTIF_ENDPOINT} == 0   MockServer not necessary to run    
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
    
Check Notification Endpoint
    &{notification_request}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${notification_request}
    Clear Requests  ${callback_endpoint}
