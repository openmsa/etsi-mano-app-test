*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Resource    VnfLcmMntOperationKeywords.robot
Documentation    This resource represents an individual subscription. The client can use this resource to read and to terminate a
...    subscription to notifications related to VNF lifecycle management
Suite Setup    Check resource existance

*** Test Cases ***
Post Individual Subscription - Method not implemented
    [Documentation]    Test ID: 7.3.1.18.1
    ...    Test title: Post Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.19.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Create Individual subscription
	Check HTTP Response Status Code Is    405

GET Individual Subscription
    [Documentation]    Test ID: 7.3.1.18.2
    ...    Test title: GET Individual Subscription
    ...    Test objective: The objective is Get the an individual subscription
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.19.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get Individual Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Subscription

PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 7.3.1.18.3
    ...    Test title: PUT Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.19.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Put Individual subscription
	Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 7.3.1.18.4
    ...    Test title: PATCH Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.19.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Patch Individual subscription
	Check HTTP Response Status Code Is    405    
    
DELETE an individual subscription
     [Documentation]    Test ID: 7.3.1.18.5
    ...    Test title: DELETE Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.19.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Delete Individual subscription
	Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200