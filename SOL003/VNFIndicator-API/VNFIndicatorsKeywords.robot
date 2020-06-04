*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    environment/vnfIndicators.txt
Resource    environment/vnfIndicatorinVnfInstance.txt
Resource    environment/individualVnfIndicator.txt
Resource    environment/individualSubscription.txt
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process    
Library    String

*** Keywords ***
Get All VNF Indicators Subscriptions
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # Log    Received a 200 OK as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscriptions.schema.json    ${result}
    # Log    Validated VnfIndicatorSubscription schema


Get VNF Indicators Subscriptions with filter
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    200
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Received a 200 OK as expected
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscriptions.schema.json    ${result}
    # Log    Validated VnfIndicatorSubscriptions schema


Get VNF Indicators Subscriptions with invalid filter
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    400
    # Log    Received a 400 Bad Request as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK
    
    
Get VNF Indicators Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    404
    # Log    Received 404 Not Found as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK


Get VNF Indicators Subscriptions with invalid authentication token
    Log    Trying to perform a negative get, using wrong authorization bearer
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as VNFM is not supporting authentication
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    401
    # Log    Received 401 Unauthorized as expected
    # ${contentType}=    Output    response headers Content-Type
    # Should Contain    ${contentType}    application/json
    # Log    Trying to validate ProblemDetails
    # ${problemDetails}=    Output    response body
    # Validate Json    ProblemDetails.schema.json    ${problemDetails}
    # Log    Validation OK    
    

Send Post Request for VNF Indicator Subscription
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${VNFM_CHECKS_NOTIF_ENDPOINT} == 1
    ...       Check Notification Endpoint
    # Integer    response status    201
    # Log    Received 201 Created as expected
    # ${headers}=    Output    response headers
    # Should Contain    ${headers}    Location
    # Log    Response has header Location
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscription.schema.json    ${result}
    # Log    Validation of VnfIndicatorSubscription OK



Send Post Request for Duplicated VNF indicator Subscription
    Log    Trying to create a subscription with an already created content
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    # Integer    response status    201
    # Log    Received 201 Created as expected
    # ${headers}=    Output    response headers
    # Should Contain    ${headers}    Location
    # Log    Response has header Location
    # ${result}=    Output    response body
    # Validate Json    VnfIndicatorSubscription.schema.json    ${result}
    # Log    Validation of VnfIndicatorSubscription OK
    
    
Send Put Request for VNF Indicator Subscriptions
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Send Patch Request for VNF Indicator Subscriptions
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Send Delete Request for VNF Indicator Subscriptions
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK  

Check HTTP Response Body Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  

Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes VNF Performance Management according to filter
    Should Be Equal As Strings    ${response[0]['body']['callbackUri']}    ${filter_ok['callbackUri']}

Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}


Check Postcondition VNF Indicator Subscription Is Set
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

Check Postcondition Subscription Resource Returned in Location Header Is Available
    Log    Going to check postcondition
    GET    ${response['headers]['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    VnfIndicatorSubscription.schema.json    ${result}
    Log    Validated VnfIndicatorSubscription schema
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${result['callbackUri']}    ${subscription['callbackUri']}
    Log    Validated Issued subscription is same as original

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present

Get all VNF indicators
    Log    The GET method queries multiple VNF indicators
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable    ${vnfIndicators}    ${response['body']}
    
Get VNF indicators with filter
    Log    The GET method queries multiple VNF indicators using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get VNF indicators with invalid filter
    Log    The GET method queries multiple VNF indicators using invalid Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all VNF indicators with malformed authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${BAD_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all VNF indicators with expired or revoked authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all VNF indicators without authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as EM/VNF is not supporting authentication
    Log    The GET method queries multiple VNF indicators omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get all VNF indicators with invalid resource endpoint
    Log    The GET method queries multiple VNF indicators omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for all VNF indicators
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PUT Request for all VNF indicators
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for all VNF indicators
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all VNF indicators
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT_JSON}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/indicators
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Indicators Exist
    Log    Check  Postcondition indicators exist
    Get all VNF indicators
    Check HTTP Response Status Code Is    200
    
Check HTTP Response Body vnfIndicators Matches the requested attribute-based filter
    Log    Check Response includes VNF Indicators according to filter
    @{attr} =  Split String    ${POS_FIELDS}       ,${VAR_SEPERATOR} 
    @{var_name} =    Split String    @{attr}[0]       ,${SEPERATOR}
    @{var_id} =    Split String    @{attr}[1]       ,${SEPERATOR}
    Should Be True     "${response['body'][0]['name']}"=="@{var_name}[1]" and "${response['body'][0]['vnfInstanceId']}"=="@{var_id}[1]"
    
Get all indicators for a VNF instance
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get all indicators for a VNF instance with filter  
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
       
Get all indicators for a VNF instance with invalid filter
    Log    This resource represents VNF indicators related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all indicators for a VNF instance with invalid resource identifier
    Log    Trying to perform a negative get, using wrong identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${erroneousVnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for indicators in VNF instance
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for indicators in VNF instance
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for indicators in VNF instance
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     
Send DELETE Request for indicators in VNF instance
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check HTTP Response Body Includes Requested VNF Instances ID
    Log    Check Response includes Indicators according to resource identifier
    Should Be Equal As Strings   ${response['body'][0]['vnfInstanceId']}    ${vnfInstanceId}

Check Postcondition Indicators for VNF instance Exist
    Log    Check Postcondition Indicators for VNF instance Exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}
    Should Be Equal    ${response.status_code}    200
    

Get Individual Indicator for a VNF instance
    Log    This resource represents a VNF indicator related to a VNF instance.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get Individual Indicator for a VNF instance with invalid indicator identifier
    Log    Trying to perform a negative get, using wrong identifier
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${erroneousIndicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for individual indicator in VNF instance
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${notAllowedIndicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual indicator in VNF instance
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for individual indicator in VNF instance
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     
Send DELETE Request for individual indicator in VNF instance
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/indicators/${vnfInstanceId}/${indicatorId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check HTTP Response Body Includes Requested Indicator ID
    Log    Check Response includes propoer VNF instance and Indicator identifiers
    Should Be Equal    ${response['body']['id']}    ${indicatorId}

Check HTTP Response Body Includes Requested VNF Instance ID
    Log    Check Response includes propoer VNF instance and Indicator identifiers
    Should Be Equal    ${response['body']['vnfInstanceId']}    ${vnfInstanceId}

Check Postcondition Indicator for VNF instance Exist
    Log    Check Response includes VNF Indicator
    Get Individual Indicator for a VNF instance
    Should Be Equal    ${response['body']['vnfInstanceId']}    ${vnfInstanceId}
    Should Be Equal    ${response['body']['id']}    ${indicatorId}

Check Postcondition VNF Indicator Subscriptions Exists
    Log    Checking that subscriptions exists
    Get all VNF Indicators Subscriptions  

GET Individual VNF Indicator Subscription
    Log    Trying to get a given subscription identified by subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Individual VNF Indicator Subscription with invalid resource identifier
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete Request for Individual VNF Indicator Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete Request for Individual VNF Indicator Subscription with invalid resource identifier
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Post Request for Individual VNF Indicator Subscription
    Log    Trying to create a new subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Send Put Request for Individual VNF Indicator Subscription
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Send Patch Request for Individual VNF Indicator Subscription
    Log    Trying to create a new subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Individual VNF Indicator Subscription is Deleted
    Log    Check Postcondition subscription is deleted
    GET Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    404

Check Postcondition VNF indicator subscription Unmodified (Implicit)
    Log    Check Postcondition subscription is not modified
    GET Individual VNF Indicator Subscription
    Log    Check Response matches original subscription
    ${subscription}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origResponse['body']['callbackUri']}    ${subscription.callbackUri}
    
Check Postcondition VNF indicator subscription is not created
    Log    Check Postcondition subscription is not created
    GET Individual VNF Indicator Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404

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
