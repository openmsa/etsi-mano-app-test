*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}     ssl_verify=false
Library     OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new subscription
    [Documentation]    Test ID: 6.3.4.4.1
    ...    Test title: Create a new subscription
    ...    Test objective: The objective is to create a new subscription.
    ...    Pre-conditions: no subscription with the same filter and callbackUri exists
    ...    Reference: Clause 7.4.5.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: Resource created successfully
    Post Create subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    FmSubscription
    Check resource existence

# Create a new Subscription - DUPLICATION
     # [Documentation]    Test ID: 6.3.4.4.2
    # ...    Test title: Create a new Subscription - DUPLICATION
    # ...    Test objective: The objective is to create a duplicate subscription.
    # ...    Pre-conditions: subscription with the same filter and callbackUri exists
    # ...    Reference: Clause 7.4.5.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    # ...    Config ID: Config_prod_VNFM
    # ...    Applicability: the VNFM does not allow creation of a subscription resource if another subscription resource with the same filter and callbackUri already exists
    # ...    Post-Conditions: duplicated subscription is created
    # Post Create subscription - DUPLICATION
    # Check HTTP Response Status Code Is    201
    # Check HTTP Response Body Json Schema Is    FmSubscription
    
# Create a new Subscription - NO-DUPLICATION
    # [Documentation]    Test ID: 6.3.4.4.3
    # ...    Test title: Create a new Subscription - NO-DUPLICATION
    # ...    Test objective: The objective is to create a subscription in case of not allowed DUPLICATION.
    # ...    Pre-conditions: subscription with the same filter and callbackUri exists
    # ...    Reference: Clause 7.4.5.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    # ...    Config ID: Config_prod_VNFM
    # ...    Applicability: the VNFM does not allow creation of a duplicate subscription resource 
    # ...    Post-Conditions: duplicated subscription is not created
    # Post Create subscription - DUPLICATION
    # Check HTTP Response Status Code Is    303

Create a duplicated Subscription
     [Documentation]    Test ID: 6.3.4.4.2a
    ...    Test title: Create a duplicated Subscription
    ...    Test objective: The objective is to create a duplicate subscription.
    ...    Pre-conditions: subscription with the same filter and callbackUri exists
    ...    Reference: Clause 7.4.5.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: duplicated subscription is created if the IUT allows duplications, otherwise the duplicated subscription is not created
    Post Create subscription
    Check Response for duplicated subscription

GET Subscriptions
    [Documentation]    Test ID: 6.3.4.4.4
    ...    Test title: GET Subscriptions
    ...    Test objective: The objective is to retrieve the list of active subscriptions
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: subscription is not deleted
    Get subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions 

GET Subscription - Filter
    [Documentation]    Test ID: 6.3.4.4.5
    ...    Test title: GET Subscription - Filter
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions - filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions 
    
GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 6.3.4.4.6
    ...    Test title: GET subscriptions - Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to retrieve the list of active subscriptions with Invalid attribute-based filtering parameters
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions - invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 

GET subscriptions with "all_fields" attribute selector
    [Documentation]    Test ID: 6.3.4.4.7
    ...    Test title: GET subscriptions with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions 

GET subscriptions with "exclude_default" attribute selector
    [Documentation]    Test ID: 6.3.4.4.8
    ...    Test title: GET subscriptions with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions

GET subscriptions with "fields" attribute selector
    [Documentation]    Test ID: 6.3.4.4.9
    ...    Test title: GET subscriptions with "fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions

GET subscriptions with "exclude_fields" attribute selector
    [Documentation]    Test ID: 6.3.4.4.10
    ...    Test title: GET subscriptions with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active subscriptions with attribute selector
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions    


        
PUT subscriptions - Method not implemented
    [Documentation]    Test ID: 6.3.4.4.11
    ...    Test title: PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    PUT subscriptions
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 6.3.4.4.12
    ...    Test title: PUT subscriptions - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    PATCH subscriptions
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 6.3.4.4.13
    ...    Test title: DELETE subscriptions - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: subscription not deleted
    DELETE subscriptions
    Check HTTP Response Status Code Is    405
    
GET Subscriptions to get Paged Response
    [Documentation]    Test ID: 6.3.4.4.14
    ...    Test title: GET Subscriptions to get Paged Response
    ...    Test objective: The objective is to retrieve the list of active subscriptions to get paged response
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: subscription is not deleted
    Get subscriptions
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
GET subscriptions - Bad Request Response too Big
    [Documentation]    Test ID: 6.3.4.4.15
    ...    Test title: GET subscriptions - Bad Request Response too Big
    ...    Test objective: The objective is to test that GET method fail retrieving list of active subscription because Response is too big, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions - invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails

GET Subscription with attribute-based filter "id"
    [Documentation]    Test ID: 6.3.4.4.16
    ...    Test title: GET Subscription with attribute-based filter "id"
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter "id"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with filter "id"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscription
    Check PostCondition HTTP Response Body Subscription Matches the requested attribute-based filter "id"
    
    
Get subscriptions with filter "filter.notificationTypes"
    [Documentation]    Test ID: 6.3.4.4.17
    ...    Test title: GET Subscription with attribute-based filter "filter.notificationTypes"
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter "filter.notificationTypes"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with filter "filter_notificationTypes"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions 
    Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_notificationTypes"
    
Get subscriptions with filter "filter.faultyResourceTypes"
    [Documentation]    Test ID: 6.3.4.4.18
    ...    Test title: GET Subscription with attribute-based filter "filter.faultyResourceTypes"
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter "filter.faultyResourceTypes"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with filter "filter_faultyResourceTypes"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions
    Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_faultyResourceTypes"
    
Get subscriptions with filter "filter.perceivedSeverities"
    [Documentation]    Test ID: 6.3.4.4.19
    ...    Test title: GET Subscription with attribute-based filter "filter.perceivedSeverities"
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter "filter.perceivedSeverities"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with filter "filter_perceivedSeverities"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions
    Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_perceivedSeverities"
    
Get subscriptions with filter "filter.eventTypes"
    [Documentation]    Test ID: 6.3.4.4.20
    ...    Test title: GET Subscription with attribute-based filter "filter.eventTypes"
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter "filter.eventTypes"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with filter "filter_eventTypes"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions
    Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_eventTypes"
    
Get subscriptions with filter "filter.probableCauses"
    [Documentation]    Test ID: 6.3.4.4.21
    ...    Test title: GET Subscription with attribute-based filter "filter.probableCauses"
    ...    Test objective: The objective is to retrieve the list of active subscriptions with filter "filter.probableCauses"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.5.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get subscriptions with filter "filter_probableCauses"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscriptions
    Check PostCondition HTTP Response Body Subscriptions Matches the requested attribute-based filter "filter_probableCauses"
    
*** Keywords ***
Post Create subscription
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
    Pass Execution If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 0    VNFM is not permitting duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}

Post Create subscription - NO-DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 1    VNFM is permitting duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/fmSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}

Get subscriptions
    Log    Get the list of active subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Get subscriptions - filter
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Get subscriptions - invalid filter  
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
PUT subscriptions
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions       
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
PATCH subscriptions
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions     
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
DELETE subscriptions
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions 	   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	  

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings   ${response['status']}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK  
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}
    
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
    Should Be Equal As Strings    ${item['filter']['notificationTypes']}   ${notification_type}
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
    Should Be Equal As Strings    ${item['filter']['faultyResourceTypes']}   ${faultyResourceType}
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
    Should Be Equal As Strings    ${item['filter']['perceivedSeverities']}   ${perceivedSeverity}
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
    Should Be Equal As Strings    ${item['filter']['eventTypes']}   ${eventType}
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
    Should Be Equal As Strings    ${item['filter']['probableCauses']}   ${probableCause}
    END
    
Check resource existence
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200

Check Response for duplicated subscription
    Run Keyword If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 1    Check HTTP Response Status Code Is    201
    Run Keyword If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 1    Check HTTP Response Body Json Schema Is    FmSubscription
    Run Keyword If    ${VNFM_ALLOWS_DUPLICATE_SUBS} == 0    Check HTTP Response Status Code Is    303
