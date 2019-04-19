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
Get all VNF Package Subscriptions
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Get VNF Package Subscriptions with attribute-based filters
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    
  



Get VNF Package Subscriptions with invalid attribute-based filters
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 



Get VNF Package Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

    
    
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
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 



Send Put Request for VNF Package Subscriptions
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send Patch Request for VNF Package Subscriptions
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
    
Send Delete Request for VNF Package Subscriptions
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
    Log    Check Response includes VNF Package Management according to filter
    #TODO


Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}



Check Postcondition VNF Package Subscription Is Set
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
    Pass Execution If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 0    MockServer not started as NFVO is not checking the notification endpoint
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
    
Check Notification Endpoint
    &{notification_request}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${notification_request}
    Clear Requests  ${callback_endpoint}
