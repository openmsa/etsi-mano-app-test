*** Settings ***
Resource    environment/variables.txt
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
#Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library     Collections

*** Keywords ***
Create Sessions
    Start Process  java  -jar  ../../bin/mockserver-netty-5.5.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}     #The API producer is set to NFVO according to SOL002-7.3.4
    
Check Individual Subscription existence
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    Log    Validate Status code    
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Header Contains
    [Arguments]    ${HEADER_TOCHECK}
    Should Contain     ${response['headers']}    ${HEADER_TOCHECK}
    Log    Header is present    
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK
    
Check HTTP Response Header ContentType is 
    [Arguments]    ${expected_contentType}
    Log    Validate content type
    Should Be Equal    ${response['headers']['Content-Type']}    ${expected_contentType}
    Log    Content Type validated 
    
Check Alarm notification Endpoint has been delivered
    Log  Verifying results
    Wait Until Keyword Succeeds    ${sleep_interval}    Verify Mock Expectation    ${req_mock}
        
Clean Endpoint   
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}

Check Operation Occurrence Id
    ${occId}=    Get Value From Json    ${response['headers']}    $..Location
    Should Not Be Empty    ${occId}    
    
POST Alarms
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response 
    Set Global Variable    ${response}    ${outputResponse}
    
PATCH Alarms
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse} =    Output    response 
    Set Global Variable    ${response}    ${outputResponse}
    
PUT Alarms
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response 
    Set Global Variable    ${response}    ${outputResponse}
    
DELETE Alarms
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
GET Alarms
    Log    Query NFVO The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
GET Alarms With Filters
	Log    Query NFVO The GET method queries information about multiple alarms with filters.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${nsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
GET Alarms With Invalid Filters
	Log    Query NFVO The GET method queries information about multiple alarms with filters.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${nsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
GET Alarms Task with all_fields attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET Alarms Task with exclude_default attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET Alarms Task with fields attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
GET Alarms Task with exclude_fields attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    
POST Individual Alarm
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response 
    Set Global Variable    ${response}    ${outputResponse}
    
DELETE Individual Alarm
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
PUT Individual Alarm
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}

GET Individual Alarm
    Log    Query NFVO The GET method queries information about an alarm.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
GET Invalid Individual Alarm
    Log    Query NFVO The GET method queries information about an invalid alarm. Should return does not exist
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query 
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms/${invalidAlarmId}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
   
PATCH Individual Alarm
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
   
PATCH Individual Alarm Conflict
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE_PATCH}"} 
    Set Headers    {"If-Match": "${Etag}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/alarmModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms/${alarmId}    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
POST Subscription
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}

Post Create subscription - DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 0    NVFO is not permitting duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
	
Post Create subscription - NO-DUPLICATION	
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 1    NVFO permits duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
	
GET Subscriptions
    Log    Get the list of active subscriptions
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
        
GET Subscriptions with filter
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}    
    
GET Subscriptions with Invalid filter   
    Log    Get the list of active subscriptions using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
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
    Set Global Variable    ${response}    ${outputResponse}
    
PATCH Subscriptions
    log    Trying to perform a PATCH Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
DELETE Subscriptions
    log    Trying to perform a DELETE Subscriptions. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
POST Individual Subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
GET Individual Subscription
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}   
    
PUT Individual Subscription
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    
PATCH Individual Subscription
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}

DELETE Individual Subscription
    log    Trying to perform a DELETE.
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
    Set Global Variable    ${response}    ${outputResponse}
    

Do POST Alarm Notification Endpoint    
    log    The POST method delivers a notification - Information of a NFVO alarm.
    ${json}=	Get File	schemas/alarmNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Set Global Variable    @{req_mock}    ${req}
    Set Global Variable    @{resp_mock}    ${rsp}
    
Do POST Alarm Clearance Notification Endpoint 
    log    The POST method delivers a notification - Information of a NFVO alarm.
    ${json}=	Get File	schemas/alarmClearedNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Set Global Variable    @{req_mock}    ${req}
    Set Global Variable    @{resp_mock}    ${rsp}
    
Do POST Alarm List Rebuilt Notification Endpoint 
     log    The POST method delivers a notification - Information of a NFVO alarm.
    ${json}=	Get File	schemas/alarmListRebuiltNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle alarmNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Set Global Variable    @{req_mock}    ${req}
    Set Global Variable    @{resp_mock}    ${rsp}   

Do GET Notification Endpoint
    log    The GET method allows the server to test the notification endpoint
    &{req}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}    
    Set Global Variable    @{req_mock}    ${req}
    Set Global Variable    @{resp_mock}    ${rsp}
    
Do PUT Notification     
    Log  PUT Method not implemented
    &{req}=  Create Mock Request Matcher	PUT  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    
Do PATCH Notification     
    Log  PATCH Method not implemented
    &{req}=  Create Mock Request Matcher	PATCH  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    
Do DELETE Notification     
    Log  DELETE Method not implemented
    &{req}=  Create Mock Request Matcher	DELETE  ${callback_endpoint}
    &{rsp}=  Create Mock Response  status_code=405
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}

GET Alarm With Filter "id"
	Log    Query NFVO The GET method queries information about multiple alarms with filter "id".
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?id=${alarmId}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "id"
    Should Be Equal As Strings    ${response['body']['id']}    ${alarmId}
	
GET Alarms With Filter "rootCauseFaultyComponent_faultyNestedNsInstanceId"
	Log    Query NFVO The GET method queries information about multiple alarms with filter "rootCauseFaultyComponent.faultyNestedNsInstanceId".
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?rootCauseFaultyComponent.faultyNestedNsInstanceId=${faultyNestedNsInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "rootCauseFaultyComponent_faultyNestedNsInstanceId"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['rootCauseFaultyComponent']['faultyNestedNsInstanceId']}    ${faultyNestedNsInstanceId}
    END

GET Alarms With Filter "rootCauseFaultyComponent_faultyNsVirtualLinkInstanceId"
	Log    Query NFVO The GET method queries information about multiple alarms with filter "rootCauseFaultyComponent.faultyNsVirtualLinkInstanceId".
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?rootCauseFaultyComponent.faultyNsVirtualLinkInstanceId=${faultyNsVirtualLinkInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "faultyNsVirtualLinkInstanceId"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['rootCauseFaultyComponent']['faultyNsVirtualLinkInstanceId']}    ${faultyNsVirtualLinkInstanceId}
    END
	
GET Alarms With Filter "rootCauseFaultyComponent_faultyVnfInstanceId"
	Log    Query NFVO The GET method queries information about multiple alarms with filter "rootCauseFaultyComponent.faultyVnfInstanceId".
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?rootCauseFaultyComponent.faultyVnfInstanceId=${faultyVnfInstanceId}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "faultyVnfInstanceId"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['rootCauseFaultyComponent']['faultyVnfInstanceId']}    ${faultyVnfInstanceId}
    END
	
GET Alarms With Filter "rootCauseFaultyResource_faultyResourceType"
	Log    Query NFVO The GET method queries information about multiple alarms with filter "rootCauseFaultyResource.faultyResourceType".
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query
	Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?rootCauseFaultyResource.faultyResourceType=${faultyResourceType}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "faultyResourceType"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['rootCauseFaultyResource']['faultyResourceType']}    ${faultyResourceType}
    END
	
GET Alarms with filter "eventType"
	Log    Query VNF The GET method queries information about multiple alarms with filters "eventType".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?eventType=${eventType}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "eventType"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['eventType']}    ${eventType}
    END
	
GET Alarms with filter "perceivedSeverity"
	Log    Query VNF The GET method queries information about multiple alarms with filters "perceivedSeverity".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?perceivedSeverity=${perceivedSeverity}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "perceivedSeverity"
	:FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['perceivedSeverity']}    ${perceivedSeverity}
    END
	
GET Alarms with filter "probableCause"
	Log    Query VNF The GET method queries information about multiple alarms with filters "probableCause".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?probableCause=${probableCause}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "probableCause"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings     ${item['probableCause']}    ${probableCause}
    END
    
Get subscriptions with filter "id"
    Log    Get the list of active subscriptions using a filter "id"
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?id=${subscription_id}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body Subscription Matches the requested attribute-based filter "id"
    Should Be Equal As Strings    ${response['body']['id']}    ${subscription_id}
	
Get subscriptions with filter "filter_notificationTypes"
    Log    Get the list of active subscriptions using a filter "filter.notificationTypes"
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?filter.notificationTypes=${notification_type}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_notificationTypes"
    :FOR   ${item}   IN  @{response['body']}
    Should Contain Match    ${item['filter']['notificationTypes']}   ${notification_type}    case_insensitive=True
    END
	
Get subscriptions with filter "filter_faultyResourceTypes"
    Log    Get the list of active subscriptions using a filter "filter.faultyResourceTypes"
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?filter.faultyResourceTypes=${faultyResourceType}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_faultyResourceTypes"
	:FOR   ${item}   IN  @{response['body']}
    Should Contain Match    ${item['filter']['faultyResourceTypes']}   ${faultyResourceType}    case_insensitive=True
    END
    
Get subscriptions with filter "filter_perceivedSeverities"
    Log    Get the list of active subscriptions using a filter "filter.perceivedSeverities"
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?filter.perceivedSeverities=${perceivedSeverity}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_perceivedSeverities"
    :FOR   ${item}   IN  @{response['body']}
    Should Contain Match    ${item['filter']['perceivedSeverities']}   ${perceivedSeverity}    case_insensitive=True
    END
	
Get subscriptions with filter "filter_eventTypes"
    Log    Get the list of active subscriptions using a filter "filter.eventTypes"
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?filter.eventTypes=${eventType}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_eventTypes"
	:FOR   ${item}   IN  @{response['body']}
    Should Contain Match    ${item['filter']['eventTypes']}   ${eventType}    case_insensitive=True
    END
    
Get subscriptions with filter "filter_probableCauses"
    Log    Get the list of active subscriptions using a filter "filter.probableCauses"
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?filter.probableCauses=${probableCause}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}

Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_probableCauses"
    :FOR   ${item}   IN  @{response['body']}
    Should Contain Match    ${item['filter']['probableCauses']}   ${probableCause}    case_insensitive=True
    END

Check Response for duplicated subscription
    Run Keyword If    ${NFVO_ALLOWS_DUPLICATE_SUBS} == 1    Check HTTP Response Status Code Is    201
    Run Keyword If    ${NFVO_ALLOWS_DUPLICATE_SUBS} == 1    Check HTTP Response Body Json Schema Is    FmSubscription
    Run Keyword If    ${NFVO_ALLOWS_DUPLICATE_SUBS} == 0    Check HTTP Response Status Code Is    303