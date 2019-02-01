*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
...        spec=SOL003-VirtualisedResourcesQuotaAvailableNotification-API.yaml
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/


*** Test Cases ***
Create a new subscription
    [Documentation]    Test ID: 11.4.2.1
    ...    Test title: Create a new subscription related to the availability of the virtualised resources quotas
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/vrQuotaAvailSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    Integer    response status    201
    Log    Status code validated
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VrQuotaAvailSubscription.schema.json    ${json}
    Log    Validation OK

Create a new Subscription - DUPLICATION
    [Documentation]    Test ID: 11.4.2.2
    ...    Test title: Create a new resource quota subscription - DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 7.4.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM allows creating a subscription resource if another subscription resource with the same filter and callbackUri already exists
    ...    Post-Conditions: 
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 0    NVFO is not permitting duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    json/vrQuotaAvailSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    Integer    response status    201
    Log    Status code validated
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VrQuotaAvailSubscription.schema.json    ${json}
    Log    Validation OK

Create a new Subscription - NO-DUPLICATION
    [Documentation]    Test ID: 11.4.2.3
    ...    Test title: Create a new resource quota subscription - NO DUPLICATION
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: the VNFM decides to not create a duplicate subscription resource 
    ...    Post-Conditions: 
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${NFVO_DUPLICATION} == 1    VNFM permits duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    json/vrQuotaAvailSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    Integer    response status    303
    Log    Status code validated
    ${headers}=    Output    response headers
    Should Contain    ${headers}    Location
    Log    Validation OK

GET Subscriptions
    [Documentation]    Test ID: 11.4.2.4
    ...    Test title: Retrieve a list of resource quota subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions
    ...    Pre-conditions: 
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Log    Get the list of active subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Log    Validate Status code
    Integer    response status    200
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    subscriptions.schema.json    ${json}
    Log    Validation OK

GET Subscription - Filter
    [Documentation]    Test ID: 11.4.2.5
    ...    Test title: Retrieve a list of resource quota subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter
    ...    Pre-conditions: 
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${result}=    Output    response body
    ${json}=    evaluate    json.loads('''${result}''')    json
    Validate Json    VrQuotaAvailSubscriptions.schema.json    ${json}
    Log    Validation OK
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 11.4.2.5-1
    ...    Test title: Retrieve a list of resource quota subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: section 11.4.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Log    Get the list of active subscriptions using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}
    Integer    response status    400
    Log    Received a 400 Bad Request as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    ${CONTENT_TYPE}
    ${problemDetails}=    Output    response body
    ${json}=    evaluate    json.loads('''${problemDetails}''')    json
    Validate Json    ProblemDetails.schema.json    ${json}
    Log    Validation OK
    
PUT subscriptions - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    Log    Validate Status code
    Integer    response status    405

PATCH subscriptions - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    
    Integer    response status    405

DELETE subscriptions - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Log    Validate Status code
    Integer    response status    405

    