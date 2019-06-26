*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/individualSubscription.txt
Library           OperatingSystem
Library           REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}    ssl_verify=false

*** Test Cases ***
GET Individual VNF Indicator Subscription
    [Documentation]    Test ID: 6.3.2.5.1
    ...    Test title: Get individual subscription to VNF performance indicators
    ...    Test objective: The objective is to test the retrieval of individual VNF performance indicator subscription and perform a JSON schema validation of the returned subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.6.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    Get Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscription

GET Individual VNF Indicator Subscription with invalid resource identifier
    [Documentation]    Test ID: 6.3.2.5.2
    ...    Test title: Get individual subscription to VNF performance indicators
    ...    Test objective: The objective is to test that the retrieval of individual VNF performance indicator subscription fails when using an invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.6.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none
    GET Individual VNF Indicator Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails
    
PUT Individual VNF Indicator Subscription - Method not implemented
    [Documentation]    Test ID 6.3.2.5.5
    ...    Test title: PUT individual VNF indicator subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an individual VNF performance indicator subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: section 8.4.6.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The individual VNF indicator subscription is not modified by the operation
    Send Put Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF individual subscription Unmodified (Implicit)

PATCH Individual VNF Indicator Subscription - Method not implemented
    [Documentation]    Test ID 6.3.2.5.6
    ...    Test title: PUT individual VNF indicator subscription - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update an individual VNF performance indicator subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: section 8.4.6.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The individual VNF indicator subscription is not modified by the operation
    Send Patch Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF individual subscription Unmodified (Implicit) 

POST Individual VNF Indicator Subscription - Method not implemented
    [Documentation]    Test ID 6.3.2.5.7
    ...    Test title: PUT individual VNF indicator subscription - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an individual VNF performance indicator subscription
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference: section 8.4.6.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators.
    ...    Post-Conditions: The individual VNF indicator subscription is not created by the operation
    Send Post Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF individual subscription is not created  

DELETE Individual VNF Indicator Subscription
    [Documentation]    Test ID: 6.3.2.5.3
    ...    Test title: Delete individual subscription to VNF performance indicators
    ...    Test objective: The objective is to test the deletion of an individual VNF performance indicator subscription.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.6.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: The subscription to VNF performance indicators is deleted
    Send Delete Request for Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    204
    Check Postcondition Individual VNF Indicator Subscription is Deleted

DELETE Individual VNF Indicator Subscription with invalid resource identifier
    [Documentation]    Test ID: 6.3.2.5.4
    ...    Test title: Delete individual subscription to VNF performance indicators
    ...    Test objective: The objective is to test that the deletion of an individual VNF performance indicator subscription fails when using an invalid resource identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNF.
    ...    Reference:  section 8.4.6.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation and maintenance of performance indicators
    ...    Post-Conditions: none   
    Send Delete Request for Individual VNF Indicator Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404
    Check HTTP Response Body Json Schema Is   ProblemDetails

*** Keywords ***
Get Individual VNF Indicator Subscription
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
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Check Postcondition Individual VNF Indicator Subscription is Deleted
    Log    Check Postcondition subscription is deleted
    GET Individual VNF Indicator Subscription
    Check HTTP Response Status Code Is    404

Check Postcondition VNF individual subscription Unmodified (Implicit)
    Log    Check Postcondition subscription is not modified
    GET Individual VNF Indicator Subscription
    Log    Check Response matches original subscription
    Should Be Equal As Strings    ${origResponse['body']['callbackUri']}    ${response['body']['callbackUri']}
    
Check Postcondition VNF individual subscription is not created
    Log    Check Postcondition subscription is not created
    GET Individual VNF Indicator Subscription with invalid resource identifier
    Check HTTP Response Status Code Is    404
