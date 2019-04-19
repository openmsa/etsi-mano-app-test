*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    PerformanceManagementNotification.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/

*** Keywords ***
Get VNF Performance Management Subscriptions
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


 Get VNF Performance Management Subscriptions with filters
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
    


Get VNF Performance Management Subscriptions with invalid filters
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
    
    
Get VNF Performance Management Subscriptions with invalid resource endpoint
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



Send Post Request for VNF Performance Management Subscription
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


Send Post Request for Duplicated VNF Performance Management Subscription
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
    


Send Put Request for VNF Performance Management Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Send Patch Request for VNF Performance Management Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Send Delete Request for VNF Performance Management Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the VNFM shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected



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


Check HTTP Response Body Json Schema Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  


Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes VNF Performance Management according to filter
    Should Be Equal As Strings    ${response['body']['callbackUri']}    ${callbackUri}


Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}



Check Postcondition VNF Performance Management Subscription Is Set
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
    Log    Header is present
