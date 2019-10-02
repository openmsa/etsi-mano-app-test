*** Settings ***
Resource    environment/variables.txt
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
#Suite Teardown    Terminate All Processes    kill=true

Library    Process

*** Variables ***
${original_etag}    1234

*** Keywords ***
Check Operation Occurrence Id
    ${opOccId}=    Get Value From Json    ${response.headers}    $..Location
    Should Not Be Empty    ${opOccId}
Check Postcondition VNF fault management alarms Exists
    Log    Checking that alarms exists
    GET Fault Management Alarms
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Alarms

Check Postcondition VNF fault management individual alarm Exists
    Log    Checking that individual alarm exists
    GET Fault Management Individual Alarm
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarm  
      
Check Individual Subscription existance
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200
    
Check Individual Subscription deleted
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    404
    
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
    
Send POST request for fault management Alarms
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
PATCH Fault management Alarms
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse} =    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
PUT Fault management Alarms
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
DELETE Fault management Alarms
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
GET Fault Management Alarms
    Log    Query NFVO The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
GET Fault Management Alarms With Filters
	Log    Query NFVO The GET method queries information about multiple alarms with filters.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${nsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
GET Fault Management Alarms With Invalid Filters
	Log    Query NFVO The GET method queries information about multiple alarms with filters.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${nsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
GET Alarms Task with all_fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET Alarms Task with exclude_default attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET VNF Packages with fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
GET Alarms Task with exclude_fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 	
Send POST request for fault management Individual Alarm
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response 
    Set Global Variable    @{response}    ${outputResponse}
    
DELETE Fault Management Individual Alarm
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
PUT Fault Management Individual Alarm
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

GET Fault Management Individual Alarm
    Log    Query VNF The GET method queries information about an alarm.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${etag}    Output    response headers ETag
    Set Suite Variable    &{original_etag}    ${etag}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
GET Fault Management Individual Alarm with invalid id
    Log    Query NFVO The GET method queries information about an invalid alarm. Should return does not exist
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${invalidAlarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
   
PATCH Fault Management Individual Alarm
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
PATCH Fault Management Individual Alarm - precondition failed
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Set Headers    {"If-Match": "${original_etag[0]}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
   
PATCH Fault Management Individual Alarm Conflict
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Set Headers    {"If-Match": "${Etag}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
    
POST Subscription
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
POST Subscription Duplication permitted
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Pass Execution If    ${VNFM_DUPLICATION} == 0    NVFO is not permitting duplication. Skipping the test
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

POST Subscription Duplication not permitted
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Pass Execution If    ${VNFM_DUPLICATION} == 1    NVFO is not permitting duplication. Skipping the test
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

GET Subscriptions
    Log    Get the list of active subscriptions
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
        
GET Subscriptions with filter
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}    
    
GET Subscriptions with Invalid filter   
    Log    Get the list of active subscriptions using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
Get subscriptions with all_fields attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
Get subscriptions with exclude_default attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
Get subscriptions with fields attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
Get subscriptions with exclude_fields attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     
PUT Subscriptions
    log    Trying to perform a PUT Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
PATCH Subscriptions
    log    Trying to perform a PATCH Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
DELETE Subscriptions
    log    Trying to perform a DELETE Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
POST Individual Subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
GET Individual Subscription
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}   
    
PUT Individual Subscription
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}
    
PATCH Individual Subscription
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}

DELETE Individual Subscription
    log    Trying to perform a DELETE.
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    @{response}    ${outputResponse}