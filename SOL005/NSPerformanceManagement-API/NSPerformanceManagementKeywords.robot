*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process

*** Keywords ***
Get all NSD Performance Subscriptions
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NSD Performance Subscriptions with attribute-based filters
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NSD Performance Subscriptions with invalid attribute-based filters
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NSD Performance Subscriptions with invalid resource endpoint
    [Documentation]    The client can use this method to query the list of active subscriptions to Performance management notifications
    ...    subscribed by the client.
    ...    This method shall follow the provisions specified in the Tables 7.4.7.3.2-1 and 7.4.7.3.2-2 for URI query parameters,
    ...    request and response data structures, and response codes.
    Set headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Send Post Request for NSD Performance Subscription
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


Send Post Request for Duplicated NSD Performance Subscription
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



Send Put Request for NSD Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the NFVO shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send Patch Request for NSD Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the NFVO shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send Delete Request for NSD Performance Subscriptions
    [Documentation]    This method is not supported. When this method is requested on this resource, the NFVO shall return a "405 Method
    ...    Not Allowed" response as defined in clause 4.3.5.4.
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
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
    Log    Check Response includes VNF Package Management according to filter
    #TODO


Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}


Check Postcondition NSD Performance Subscription Is Set
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    
    
Check Postcondition Subscription Resource URI Returned in Location Header Is Valid
    Log    Going to check postcondition
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${response.headers['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    PmSubscriptions.schema.json    ${result}
    Log    Validated PmSubscriptions schema
        
    

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
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
