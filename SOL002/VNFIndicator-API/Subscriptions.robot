*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}

*** Test Cases ***
GET VNF Indicators Subscriptions
    [Documentation]    Test ID: 6.3.2.4.1
    ...    Test title: Get all subscriptions to VNF performance indicators
    ...    Test objective: The objective is to test the retrieval of all VNF performance indicators subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions

GET VNF Indicators Subscriptions with attribute-based filter
    [Documentation]    Test ID: 6.3.2.4.2
    ...    Test title: Get all subscriptions to VNF performance indicators with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of all VNF performance indicators subscriptions using attribute-based filter and perform a JSON schema and content validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions
    Check HTTP Response Body Matches Attribute-Based Filter

GET VNF Indicators Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.2.4.3
    ...    Test title: Get all subscriptions to VNF performance indicators with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of all VNF performance indicators subscriptions fails when using invalid attribute-based filter. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails    

GET VNF Indicators Subscriptions with invalid resource endpoint
    [Documentation]    Test ID 6.3.2.4.4
    ...    Test title: Get all subscriptions to VNF performance indicators with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all VNF performance indicators subscriptions fails when using invalid resource endpoint. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is up and running. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: section 8.4.5.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

POST VNF Indicator Subscription
    [Documentation]    Test ID 6.3.2.4.5
    ...    Test title: Create a new VNF performance indicator subscription
    ...    Test objective: The objective is to test the creation of a new VNF performance indicator subscription perform a JSON schema and content validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is up and running
    ...    Reference: section 8.4.5.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The VNF indicator subscription is successfully set and it matches the issued subscription
    Send Post Request for VNF Indicator Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    VnfIndicatorSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Performance Indicator Subscription Is Set

PUT VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID 6.3.2.4.6
    ...    Test title: PUT VNF indicator subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF performance indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 8.4.5.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send Put Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405

PATCH VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID 6.3.2.4.7
    ...    Test title: PATCH VNF indicator subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF performance indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 8.4.5.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: none
    Send Patch Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405

DELETE VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID 6.3.2.4.8
    ...    Test title: DELETE VNF indicator subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to delete VNF performance indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: section 8.4.5.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
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
    Set Suite Variable    @{response}    ${output}

Get VNF Indicators Subscriptions with filter
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${POS_FILTER}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
Get VNF Indicators Subscriptions with invalid filter   
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${NEG_FILTER}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}   
    
Get VNF Indicators Subscriptions with invalid resource endpoint
        Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}   

Send Post Request for VNF Indicator Subscription
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}   

Send Put Request for VNF Indicator Subscriptions
    Log    Trying to create a new subscription
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Patch Request for VNF Indicator Subscriptions
    Log    Trying to create a new subscription
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Delete Request for VNF Indicator Subscriptions
    Log    Trying to create a new subscription
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response[0]['status']}    ${status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Log    ${response[0]['headers']}
    Should Contain    ${response[0]['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${schema}
    Should Contain    ${response[0]['headers']['Content-Type']}    application/json
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK

Check HTTP Response Body Matches the Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response[0]['body']['callbackUri']}    ${subscription.callbackUri}

Check Postcondition VNF Performance Indicator Subscription Is Set
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response[0]['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    Check HTTP Response Status Code Is    200
    
Check HTTP Response Body Matches Attribute-Based Filter
    Log    Check Response includes VNF Indicators according to filter
    #todo
