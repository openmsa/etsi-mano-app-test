*** Settings ***
Resource    environment/variables.txt
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem


*** Keywords ***
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
    [Arguments]    ${schema}
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK
    
Check HTTP Response Header ContentType is 
    [Arguments]    ${expected_contentType}
    Log    Validate content type
    Should Be Equal    ${response[0]['headers']['Content-Type']}    ${expected_contentType}
    Log    Content Type validated 
    
Do POST Alarms
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Do PATCH Alarms
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse} =    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Do PUT Alarms
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}

    
Do DELETE Alarms
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do GET Alarms
    Log    Query NFVO The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do GET Alarms With Filters
	Log    Query NFVO The GET method queries information about multiple alarms with filters.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${nsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET Alarms With Invalid Filters
	Log    Query NFVO The GET method queries information about multiple alarms with filters.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${nsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do POST Individual Alarm
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
Do DELETE Individual Alarm
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do PUT Individual Alarm
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

Do GET Individual Alarm
    Log    Query NFVO The GET method queries information about an alarm.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do GET Invalid Individual Alarm
    Log    Query NFVO The GET method queries information about an invalid alarm. Should return does not exist
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${invalidAlarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
   
Do PATCH Individual Alarm
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
   
   
Do PATCH Individual Alarm Conflict
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Set Headers    {"If-Match": "${Etag}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do POST Subscription
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

Do GET Subscriptions
    Log    Get the list of active subscriptions
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
        
Do GET Subscriptions with filter
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
    
Do GET Subscriptions with Invalid filter   
    Log    Get the list of active subscriptions using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do PUT Subscriptions
    log    Trying to perform a PUT Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do PATCH Subscriptions
    log    Trying to perform a PATCH Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do DELETE Subscriptions
    log    Trying to perform a DELETE Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do POST Individual Subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
    
Do GET Individual Subscription
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
    
Do PUT Individual Subscription
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
Do PATCH Individual Subscription
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

Do DELETE Individual Subscription
    log    Trying to perform a DELETE.
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
