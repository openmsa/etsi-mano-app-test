*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Library           OperatingSystem
Library           JSONLibrary
Library           Process
Library           MockServerLibrary    
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}    ssl_verify=false
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
GET VNF Indicators Subscriptions
    [Documentation]    Test ID: 6.3.2.4.1
    ...    Test title: GET VNF Indicators Subscriptions
    ...    Test objective: The objective is to test the retrieval of all VNF indicators subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions

GET VNF Indicators Subscriptions with attribute-based filter
    [Documentation]    Test ID: 6.3.2.4.2
    ...    Test title: GET VNF Indicators Subscriptions with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of all VNF indicators subscriptions using attribute-based filter and perform a JSON schema and content validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter

GET VNF Indicators Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.2.4.3
    ...    Test title: GET VNF Indicators Subscriptions with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of all VNF indicators subscriptions fails when using invalid attribute-based filter. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails    

GET VNF Indicators Subscriptions with invalid resource endpoint
    [Documentation]    Test ID 6.3.2.4.4
    ...    Test title: GET VNF Indicators Subscriptions with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all VNF indicators subscriptions fails when using invalid resource endpoint.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators.
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404

Create new VNF indicator subscription
    [Documentation]    Test ID 6.3.2.4.5
    ...    Test title: Create new VNF indicator subscription
    ...    Test objective: The objective is to test the creation of a new VNF indicator subscription perform a JSON schema and content validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: clause 8.4.5.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators.
    ...    Post-Conditions: The VNF indicator subscription is successfully set and it matches the issued subscription
    Send Post Request for VNF Indicator Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    VnfIndicatorSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Indicator Subscription Is Set

PUT VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID 6.3.2.4.6
    ...    Test title: PUT VNF Indicator Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.3 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators.
    ...    Post-Conditions: none
    Send Put Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405

PATCH VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID 6.3.2.4.7
    ...    Test title: PATCH VNF Indicator Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators.
    ...    Post-Conditions: none
    Send Patch Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405

DELETE VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID 6.3.2.4.8
    ...    Test title: DELETE VNF Indicator Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: clause 8.4.5.3.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of indicators.
    ...    Post-Conditions: none
    Send Delete Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405
    
 *** Keywords ***
Get VNF Indicators Subscriptions
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get VNF Indicators Subscriptions with filter
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${POS_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get VNF Indicators Subscriptions with invalid filter   
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${NEG_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    
Get VNF Indicators Subscriptions with invalid resource endpoint
        Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

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

Send Put Request for VNF Indicator Subscriptions
    Log    Trying to create a new subscription
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Patch Request for VNF Indicator Subscriptions
    Log    Trying to create a new subscription
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete Request for VNF Indicator Subscriptions
    Log    Trying to create a new subscription
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response['status']}    ${status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Log    ${response['headers']}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}

Check Postcondition VNF Indicator Subscription Is Set
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    
Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes VNF Indicators according to filter
    Should Be Equal As Strings    ${response[0]['body']['callbackUri']}    ${POS_FILTER['callbackUri']}


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