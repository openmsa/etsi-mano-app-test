*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           Process
Library           MockServerLibrary


*** Keywords ***
Get all VNF Package Subscriptions
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # Log    Received a 200 OK as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    # ${result}=    Output    response body
    # Validate Json    PkgmSubscriptions.schema.json    ${result}
    # Log    Validated PkgmSubscription schema

Get VNF Package Subscriptions with attribute-based filters
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    # Integer    response status    200
    # Log    Received a 200 OK as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    # ${result}=    Output    response body
    # Validate Json    PkgmSubscriptions.schema.json    ${result}
    # Log    Validated PkgmSubscription schema
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get VNF Package Subscriptions with invalid attribute-based filters
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    400
    # Log    Received a 400 Bad Request as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK


Get VNF Package Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    404
    # Log    Received 404 Not Found as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    ${CONTENT_TYPE_JSON}
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK

Send Post Request for VNF Package Subscription
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...       Check Notification Endpoint


Send Post Request for Duplicated VNF Package Subscription
    Log    Trying to create a subscription with an already created content
    Send Post Request for VNF Package Subscription


Send Put Request for VNF Package Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Send Patch Request for VNF Package Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected

Send Delete Request for VNF Package Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    # Integer    response status    405
    # Log    Received 405 Method not implemented as expected


Create Sessions
    Pass Execution If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 0    MockServer not started as NFVO is not checking the notification endpoint
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
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
    
    
Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes VNF Package Management according to filter
    #TODO


Check Notification Endpoint
    &{notification_request}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${notification_request}
    Clear Requests  ${callback_endpoint}


Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal As Strings    ${response['body']['callbackUri']}    ${subscription['callbackUri']}
    
    
Check Postcondition VNF Package Subscription Is Set
    [Arguments]    ${location}=""
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Run Keyword If    ${location} == Location
    ...    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    Run Keyword If    ${location} == Location
    ...    GET    ${response['headers']['Location']}  
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    
    
Check HTTP Response Body Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  
    
    
Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present