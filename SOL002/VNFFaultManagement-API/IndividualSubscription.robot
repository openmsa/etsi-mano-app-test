*** Settings ***
Resource    environment/variables.txt 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Documentation    This resource represents an individual subscription for VNF alarms. 
...    The client can use this resource to read and to terminate a subscription to notifications related to VNF fault management.
Suite Setup    Check resource existence

*** Test Cases ***
POST Individual Subscription - Method not implemented
    [Documentation]    Test ID: 6.3.4.5.1
    ...    Test title: POST Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.6.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Post Create individual subscription
    Check HTTP Response Status Code Is    405
    
GET Information about an individual subscription
    [Documentation]    Test ID: 6.3.4.5.2
    ...    Test title: GET Information about an individual subscription
    ...    Test objective: The objective is to read an individual subscription for VNF alarms subscribed by the client
    ...    Pre-conditions: The subscription with the given id exists
    ...    Reference: clause 7.4.6.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability:  
    ...    Post-Conditions: 
    Get individual subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   FmSubscription

PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 6.3.4.5.3
    ...    Test title: PUT an individual subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.6.3.3 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Put individual subscription
    Check HTTP Response Status Code Is    405
    

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 6.3.4.5.4
    ...    Test title: PATCH an individual subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.6.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    Patch individual subscription
    Check HTTP Response Status Code Is    405
    
    
DELETE an individual subscription
    [Documentation]    Test ID: 6.3.4.5.5
    ...    Test title: DELETE an individual subscription
    ...    Test objective: The objective is to test that the deletion of a subscription
    ...    Pre-conditions: an existing subscription
    ...    Reference: clause 7.4.6.3.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: the subscription is deleted
    Check resource existence
    Delete individual subscription
    Check HTTP Response Status Code Is    204
    
*** Keywords ***
Check resource existence
    Set Headers    {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200
Post Create individual subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}				
Get individual subscription
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
Get individual subscription - filter
    Log    Get the list of active individual subscription using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}		
Get individual subscription - invalid filter  
    Log    Get the list of active individual subscription using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}		
PUT individual subscription
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}        
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
PATCH individual subscription
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}		
DELETE individual subscription
    log    Try to delete an individual subscription
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}    	   
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	      
	
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated 
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}	.schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK