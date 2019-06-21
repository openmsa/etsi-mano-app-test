*** Settings ***
Resource    environment/variables.txt
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
#Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process

*** Keywords ***
Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port} 
    
Check Individual Subscription existance
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    Log    Validate Status code    
    Should Be Equal    ${response[0]['status']}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Header Contains
    [Arguments]    ${HEADER_TOCHECK}
    Should Contain     ${response[0]['headers']}    ${HEADER_TOCHECK}
    Log    Header is present    
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK
    
Check HTTP Response Header ContentType is 
    [Arguments]    ${expected_contentType}
    Log    Validate content type
    Should Be Equal    ${response[0]['headers']['Content-Type']}    ${expected_contentType}
    Log    Content Type validated 
    
Check Postcondition VNF Virtualised Resources Quota Available Notification Subscriptions Exists
    Log    Checking that subscriptions exists
    GET Virtualised Resources Quota Available Notification Subscriptions
      
Check Postcondition VNF Virtualised Resources Quota Available Notification individual Subscriptions is Deleted
    Log    Check Postcondition Subscription is deleted
    Get Virtualised Resources Quota Available Notification individual subscription
    Check HTTP Response Status Code Is    404 
    
Send Post request for Virtualised Resources Quota Available Notification Individual Subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Put Virtualised Resources Quota Available Notification individual Subscription
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Patch Virtualised Resources Quota Available Notification individual subscription
    log    Trying to perform a Patch. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Get Virtualised Resources Quota Available Notification individual subscription 
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
      
Delete Virtualised Resources Quota Available Notification individual subscription
    log    Try to delete an individual subscription
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}   
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Send Post request for new Virtualised Resources Quota Available Notification subscription 
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/vrQuotaAvailSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}    
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Send Post request for new Virtualised Resources Quota Available Notification subscription - DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 0    NVFO is not permitting duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/vrQuotaAvailSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Send Post request for new Virtualised Resources Quota Available Notification subscription - NO-DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 1    VNFM permits duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/vrQuotaAvailSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
GET Virtualised Resources Quota Available Notification Subscriptions
    Log    Get the list of active subscriptions
    Set Headers  {"Accept":"${ACCEPT}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
     
GET Virtualised Resources Quota Available Notification Subscriptions with Filter
    Log    Get the list of active subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Get Virtualised Resources Quota Available Notification subscriptions with Bad Request Invalid attribute-based filtering parameters    
     Log    Get the list of active subscriptions using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Send Put request for Virtualised Resources Quota Available Notification subscription 
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse} 
    
Send Patch request for Virtualised Resources Quota Available Notification subscription
    log    Trying to perform a Patch. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}  
    
Send Delete request for Virtualised Resources Quota Available Notification subscription
    log    Trying to perform a Delete. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}           