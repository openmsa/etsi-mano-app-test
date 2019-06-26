*** Settings ***
Resource    environment/variables.txt
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    Process
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    MockServerLibrary

*** Keywords ***
Initialize System
    Start Process  java  -jar  ../../bin/mockserver-netty-5.5.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port} 
    
Check Operation Occurrence Id
    ${occid}=    Get Value From Json    ${response[0]['headers']['Location']}  ${response}
    Set Global Variable    @{nsLcmOpOccId}    ${occid}
    Should Not Be Empty    ${nsLcmOpOccId}
    
Create Sessions
    Start Process  java  -jar  ../../bin/mockserver-netty-5.5.0-jar-with-dependencies.jar  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}   
    
Check subscription existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200
    
Check Fail not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}
    # how to check if Fail is not supported? Also In Sol002
    
Check Cancel not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}
    # how to check if Cancel is not supported? Also In Sol002
    
Check Continue not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}
    # how to check if Continue is not supported? Also In Sol002
    
Check retry not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}
    # how to check if retry is not supported? Also In Sol002
    
Check Rollback not supported
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}
    # how to check if rollback is not supported? Also In Sol002
    
Check resource FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId} 
    String    response body operationState    FAILED_TEMP

Check Operation Notification Status is
    [Arguments]    ${status}
    Check Operation Notification    NsLcmOperationOccurrenceNotification   ${status}

Check Operation Notification
    [Arguments]    ${element}    ${status}=""
    ${json}=	Get File	schemas/${element}.schema.json
    Configure Notification Forward    ${element}    ${callback_endpoint}    ${callback_endpoint_fwd}
    Configure Notification Status Handler    ${callback_endpoint_fwd}    ${status}
    Wait Until Keyword Succeeds    2 min   10 sec   Verify Mock Expectation    ${notification_request}
    Clear Requests    ${callback_endpoint}
    Clear Requests    ${callback_endpoint_fwd}
    
Configure Notification Forward
    [Arguments]    ${element}    ${endpoint}    ${endpoint_fwd}    
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock HTTP forward to handle ${element}
    &{notification_tmp}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{notification_fwd}=  Create Mock Http Forward	${endpoint_fwd}
    Create Mock Expectation With Http Forward  ${notification_tmp}  ${notification_fwd}
    
Configure Notification Status Handler
    [Arguments]    ${endpoint}    ${status}=""
    Run Keyword If   ${status}!=""  set to dictionary    ${json["notificationStatus"]}    dp=${status}    
    ${BODY}=    evaluate    json.dumps(${json})    json
    Log  Creating mock request and response to handle ${element}
    &{notification_request}=  Create Mock Request Matcher	POST  ${endpoint}  body_type="JSON"    body=${BODY}
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}    
        
Check resource operationState is
    [Arguments]    ${state} 
    String    ${response[0]['body']['operationState']}   ${state}
    
Check resource instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId} 
    String    response body instantiationState    INSTANTIATED
    
Check resource not_instantiated
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId} 
    String    response body instantiationState    NOT_INSTANTIATED

Launch another LCM operation
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleNsToLevelRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/scale_to_level    ${body}
    Integer    response status    202

Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId} 
    Integer    response status    200
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    Log    Validate Status code    
    Should Be Equal as Strings  ${response[0]['status']}    ${expected_status}
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
    Should Be Equal as Strings   ${response[0]['headers']['Content-Type']}    ${expected_contentType}
    Log    Content Type validated 

Do POST New nsInstance
    Log    Create NS instance by POST to ${apiRoot}/${apiName}/${apiVersion}/ns_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/CreateNsRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}     

Do GET NsInstances
    Log    Query NS The GET method queries information about multiple NS instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	

Do GET NsInstance Invalid Attribute-Based filtering parameter
    Log    Query NS The GET method queries information about multiple NS instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get   ${apiRoot}/${apiName}/${apiVersion}/ns_instances?attribute_not_exist=some_value
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET NsInstance Invalid Attribute Selector
    Log    Query NS The GET method queries information about multiple NS instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?fields=wrong_field	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}  
	
Do PUT NSInstances
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}   
	
Do PATCH NSInstances
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}  
	
Do DELETE NSInstances
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 

DO POST IndividualNSInstance
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do GET IndividualNSInstance
    Log    Trying to get information about an individual NS instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}
    ${Etag}=    Output    response headers Etag
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 

DO PUT IndividualNSInstance
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 	
	
DO PATCH IndividualNSInstance
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 	
	
Do DELETE IndividualNSInstance
    log    Trying to delete an individual VNF instance
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 	
	

Do DELETE IndividualNSInstance Conflict
    log    Trying to delete an individual VNF instance
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${ConflictNsInstanceId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 	


Do DELETE Instantiate NSInstance
    log    Trying to delete an instantiate NS instance. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/instantiate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
 Do PATCH Instantiate NSInstance
    log    Trying to patch an instantiate NS instance. This method should not be implemented 
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/instantiate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
Do PUT Instantiate NSInstance
    log    Trying to put an instantiate NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/instantiate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do GET Instantiate NSInstance
    log    Trying to get an instantiate NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/instantiate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
 Do POST Instatiate nsInstance
    Log    Trying to Instantiate a ns Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/InstantiateNsRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/instantiate    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Scale NSInstance
    log    Trying to delete an Scale NS instance. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/scale
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
 Do PATCH Scale NSInstance
    log    Trying to patch an Scale NS instance. This method should not be implemented 
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/scale
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
Do PUT Scale NSInstance
    log    Trying to put an Scale NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/scale
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do GET Scale NSInstance
    log    Trying to get an Scale NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/scale
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do POST scale nsInstance
	Log    Trying to Instantiate a scale NS Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/ScaleNsRequest.json
	Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/scale    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do DELETE Update NSInstance
    log    Trying to delete an Update NS instance. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/update
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
 Do PATCH Update NSInstance
    log    Trying to patch an Update NS instance. This method should not be implemented 
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/update
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
Do PUT Update NSInstance
    log    Trying to put an Update NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/update
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do GET Update NSInstance
    log    Trying to get an Update NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/update
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do POST Update NSInstance
	Log    Trying to Instantiate a Update NS Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/UpdateNsRequest.json
	Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/update    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do DELETE Heal NSInstance
    log    Trying to Delete an Heal NS instance. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/heal
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
 Do PATCH Heal NSInstance
    log    Trying to patch an Heal NS instance. This method should not be implemented 
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/heal
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
Do PUT Heal NSInstance
    log    Trying to put an Heal NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/heal
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do GET Heal NSInstance
    log    Trying to get an Heal NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/heal
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do POST Heal NSInstance
	Log    Trying to Instantiate a Heal NS Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/HealNsRequest.json
	Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/heal    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do DELETE Terminate NSInstance
    log    Trying to Delete an Terminate NS instance. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
Do PATCH Terminate NSInstance
    log    Trying to patch an Terminate NS instance. This method should not be implemented 
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
 
Do PUT Terminate NSInstance
    log    Trying to put an Terminate NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do GET Terminate NSInstance
    log    Trying to Get an Terminate NS instance. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
	
Do POST Terminate NSInstance
	Log    Trying to Instantiate a Terminate NS Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/TerminateNsRequest.json
	Post    ${apiRoot}/${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
		
Do POST NS LCM OP Occurences
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT NS LCM OP Occurences
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH NS LCM OP Occurences
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE NS LCM OP Occurences
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET NS LCN OP Occurences
    Log    Query status information about multiple NS lifecycle management operation occurrences.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query and validate response
	Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
 
Do GET NS LCN OP Occurences Invalid attribute-based filtering parameters
    Log    Query status information about multiple NS lifecycle management operation occurrences.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
	GET    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs?attribute_not_exist=some_value
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET NS LCN OP Occurences Invalid attribute selector
    Log    Query NS The GET method queries information about multiple NS instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
	GET    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs?fields=wrong_field
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}

Do POST Individual NS LCM OP Occurence
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId} 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT Individual NS LCM OP Occurence
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId} 		
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH Individual NS LCM OP Occurence
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId} 	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Individual NS LCM OP Occurence
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId} 	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET Individual NS LCN OP Occurence
    Log    Query status information about individual NS lifecycle management operation occurrence.
	Set Headers  {"Accept":"${ACCEPT}"}  
	Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
	Log    Execute Query and validate response
	Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId} 	
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
	
Do GET Retry operation task
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/retry 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT Retry operation task
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/retry  		
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH Retry operation task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/retry  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Retry operation task
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/retry  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST Retry operation task
    Log    Retry a NS lifecycle operation if that operation has experienced a temporary failure
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/retry
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET Rollback operation task
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/rollback 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT Rollback operation task
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/rollback  		
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH Rollback operation task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/rollback  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Rollback operation task
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/rollback  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST Rollback operation task
    Log    Rollback a NS lifecycle operation task
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/rollback
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET Continue operation task
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/continue 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT Continue operation task
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/continue  		
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH Continue operation task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/continue  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Continue operation task
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/continue  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST Continue operation task
    Log    Continue a NS lifecycle operation task
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/continue
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}

Do GET Fail operation task
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/fail 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT Fail operation task
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/fail  		
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH Fail operation task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/fail  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Fail operation task
    log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/fail  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST Fail operation task
    Log    Fail a NS lifecycle operation task
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/fail
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET Cancel operation task
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/cancel 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT Cancel operation task
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/cancel  		
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH Cancel operation task
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/cancel  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Cancel operation task
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/cancel  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST Cancel operation task
    Log    Cancel a NS lifecycle operation task
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/ns_lcm_op_occs/${nsLcmOpOccId}/cancel
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PUT subscriptions
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do PATCH subscriptions
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE subscriptions
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST subscriptions
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/LccnSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}    
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST subscriptions DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 0    NFVO is not permitting duplication. Skipping the test
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/LccnSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}    
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do POST subscriptions NO DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 1    NFVO is permitting duplication.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/LccnSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}    
	${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	

Do GET Subscriptions
    Log    Get the list of active subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do GET Subscriptions with filter
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}

Do POST Individual Subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}  
	
Do PUT Individual Subscription
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}  
	
Do PATCH Individual Subscription
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}

Do GET Individual subscription
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
	
Do DELETE Individual subscription
    log    Try to delete an individual subscription
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}    
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
