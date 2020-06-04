*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    environment/individualSubscription.txt
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process    

*** Keywords ***
Get all VNF Performance Subscriptions
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "application/json"}
    Set headers    {"Content-Type": "application/json"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # Log    Received a 200 OK as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    PmSubscriptions.schema.json    ${result}
    # Log    Validated PmSubscription schema


 Get VNF Performance Subscriptions with attribute-based filters
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # Log    Received a 200 OK as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    PmSubscriptions.schema.json    ${result}
    # Log    Validated PmSubscription schema    
    


Get VNF Performance Subscriptions with invalid attribute-based filters
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    400
    # Log    Received a 400 Bad Request as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${result}
    # Log    Validated ProblemDetails schema
    
    
Get VNF Performance Subscriptions with invalid resource endpoint
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.2-1 and 6.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    404
    # Log    Received a 404 Not found as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${result}
    # Log    Validated ProblemDetails schema    



Send Post Request for VNF Performance Subscription
    [Documentation]    The POST method creates a new subscription.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.1-1 and 6.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the NFVO, and might make sense only in very rare use cases.
    ...    Consequently, the VNFM may either allow creating a subscription resource if another subscription resource with the
    ...    same filter and callbackUri already exists (in which case it shall return the "201 Created" response code), or may decide
    ...    to not create a duplicate subscription resource (in which case it shall return a "303 See Other" response code referencing
    ...    the existing subscription resource with the same filter and callbackUri).
    Set headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    ${body_request}=    Get File    jsons/subscriptions.json
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body_request}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${VNFM_CHECKS_NOTIF_ENDPOINT} == 1
    ...       Check Notification Endpoint
    # Integer    response status    201
    # Log    Received a 201 Created as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    PmSubscription.schema.json    ${result}
    # Log    Validated PmSubscription schema
    # Log    Trying to validate the Location header
    # ${headers}=    Output    response headers
    # Should Contain    ${headers}    Location


Send Post Request for Duplicated VNF Performance Subscription
    [Documentation]    The POST method creates a new subscription.
    ...    This method shall follow the provisions specified in the tables 6.4.7.3.1-1 and 6.4.7.3.1-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    ...    Creation of two subscription resources with the same callbackURI and the same filter can result in performance
    ...    degradation and will provide duplicates of notifications to the NFVO, and might make sense only in very rare use cases.
    ...    Consequently, the VNFM may either allow creating a subscription resource if another subscription resource with the
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
    # Integer    response status    303
    # Log    Received a 303 See other as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Should Be Empty    ${result}
    # Log    Body is empty
    # Log    Trying to validate the Location header
    # ${headers}=    Output    response headers
    # Should Contain    ${headers}    Location
    


Send Put Request for VNF Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in Clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Send Patch Request for VNF Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in Clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Send Delete Request for VNF Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in Clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Get Individual VNF Performance Subscription
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET individual VNF Performance Subscription with invalid resource identifier
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual VNF Performance Subscription
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual VNF Performance Subscription with invalid resource identifier
    Log    Trying to delete a subscription in the VNFM with invalid id
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual VNF Performance Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Put request for individual VNF Performance Threshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Patch request for individual VNF Performance Threshold
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Performance Subscription is Unmodified (Implicit)
    Log    Check postconidtion subscription not modified
    GET individual VNF Performance Subscription
    Log    Check Response matches original VNF Threshold
    ${subscription}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal As Strings    ${origResponse['body']['id']}    ${subscription.id}
    Should Be Equal As Strings    ${origResponse['body']['callbackUri']}    ${subscription.callbackUri}

Check Postcondition VNF Performance Subscription is not Created
    Log    Trying to get a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404 

Check Postcondition VNF Performance Subscription is Deleted
    Log    Check Postcondition Subscription is deleted
    GET individual VNF Performance Subscription
    Check HTTP Response Status Code Is    404 

Check HTTP Response Body Subscription Identifier matches the requested Subscription
    Log    Trying to check response ID
    Should Be Equal As Strings    ${response['body']['id']}    ${subscriptionId} 
    Log    Subscription identifier as expected
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings   ${response['status']}    ${expected_status}
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
    Log    Check Response includes VNF Performance Management according to filter
    Should Be Equal As Strings    ${response['body'][0]['callbackUri']}    ${callbackUri_Sub}

Check HTTP Response Body PmSubscription Attributes Values Match the Issued Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal As Strings    ${response['body']['callbackUri']}    ${subscription['callbackUri']}

Check Postcondition VNF Performance Subscription Is Set
    Log    Check Postcondition subscription exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200

Check Postcondition Subscription Resource Returned in Location Header Is Available
    Log    Going to check postcondition
    GET    ${response['headers']['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    PmSubscription.schema.json    ${result}
    Log    Validated PmSubscription schema
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${result['callbackUri']}    ${subscription['callbackUri']}
    Log    Validated Issued subscription is same as original
 
Check Postcondition VNF Performance Subscriptions Exists
    Log    Checking that subscriptions exists
    Get all VNF Performance Subscriptions         

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present

Check HTTP Response Location Header Resource URI
    Log    Going to check
    GET    ${response['headers']['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    PmSubscription.schema.json    ${result}
    Log    Validated PmSubscription schema

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
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response.headers}    $..Link
    Should Not Be Empty    ${linkURL}
