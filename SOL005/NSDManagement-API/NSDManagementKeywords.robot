*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process

*** Keywords ***
GET all Network Service Descriptors Information
    Log    The GET method queries multiple NS descriptors
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Network Service Descriptors Information with attribute-based filter
    Log    The GET method queries multiple NS descriptors using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Check HTTP Response Body NsdInfos Matches the requested attribute-based filter
    Log    Checking that attribute-based filter is matched
    #todo

GET Network Service Descriptors Information with invalid attribute-based filter
    Log    The GET method queries multiple NS descriptors using Attribute-based filtering parameters. Negative case, with erroneous attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all Network Service Descriptors Information with malformed authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Log    The GET method queries using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${BAD_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all Network Service Descriptors Information without authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as it is not supporting authentication
    Log    The GET method queries omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all Network Service Descriptors Information with expired or revoked authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as it is not supporting authentication
    Log    The GET method queries  using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET all Network Service Descriptors Information with all_fields attribute selector
    Log    The GET method queries multiple NS descriptors using Attribute-based filtering parameters "all_fields"
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body NsdInfos Matches the requested all_fields selector
    Log    Validating user defined data schema
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

GET all Network Service Descriptors Information with exclude_default attribute selector
    Log    Trying to get all NSDs present in the NFVO Catalogue, using exclude_default filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body NsdInfos Matches the requested exclude_default selector
    Log    Checking that element is missing
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Should Be Empty    ${user}
    Log    Reports element is empty as expected


GET all Network Service Descriptors Information with fields attribute selector
    Log    Trying to get all NSDs present in the NFVO Catalogue, using fields filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body NsdInfos Matches the requested fields selector
    Log    Validating user defined data schema
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

GET all Network Service Descriptors Information with exclude_fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use exclude_fields option
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body NsdInfos Matches the requested exclude_fields selector
    Log    Checking that element is missing
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Should Be Empty    ${user}
    Log    Reports element is empty as expected   

Send Post Request to create new Network Service Descriptor Resource
    Log    Creating a new network service descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/createNsdInfoRequest.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition NsdInfo Exists
    Log    Checking that nsd info exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdInfo

Send PUT Request for all Network Service Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for all Network Service Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all Network Service Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Network Service Descriptors Exist
    Log    Checking that Pm Job still exists
    GET all Network Service Descriptors Information
    
Get all NS Descriptor Subscriptions
    [Documentation]    This method shall support the URI query parameters, request and response data structures, and response codes, as
    ...    specified in the Tables 5.4.8.3.2-1 and 5.4.8.3.2-2.
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get NS Descriptor Subscriptions with attribute-based filters
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NS Descriptor Subscriptions with invalid attribute-based filters
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NS Descriptor Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Send Post Request for NS Descriptor Subscription
    [Documentation]    This method shall support the URI query parameters, request and response data structures, and response codes, as
    ...    specified in the Tables 5.4.8.3.1-1 and 5.4.8.3.1-2.
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...    Check Notification Endpoint  


Send Post Request for Duplicated NS Descriptor Subscription
    Log    Trying to create a subscription with an already created content
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...    Check Notification Endpoint  



Send Put Request for NS Descriptor Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send Patch Request for NS Descriptor Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete Request for NS Descriptor Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
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


Check Postcondition NS Descriptor Subscription Is Set
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
    Validate Json    NsdmSubscription.schema.json    ${result}
    Log    Validated NsdmSubscription schema
        

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
