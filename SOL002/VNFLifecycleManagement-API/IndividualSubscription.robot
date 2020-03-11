*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Individual Subscription - Method not implemented
    [Documentation]    Test ID: 6.3.5.18.1
    ...    Test title: POST Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.19.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Create Individual subscription
	Check HTTP Response Status Code Is    405

GET Individual Subscription
    [Documentation]    Test ID: 6.3.5.18.2
    ...    Test title: GET Individual Subscription
    ...    Test objective: The objective is to test the Get individual subscription
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.19.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get Individual Subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    Subscription

PUT an individual subscription - Method not implemented
    [Documentation]    Test ID: 6.3.5.18.3
    ...    Test title: PUT Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.19.3.3 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Put Individual subscription
	Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    [Documentation]    Test ID: 6.3.5.18.4
    ...    Test title: PATCH Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.19.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Patch Individual subscription
	Check HTTP Response Status Code Is    405    
    
DELETE an individual subscription
     [Documentation]    Test ID: 6.3.5.18.5
    ...    Test title: DELETE Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 5.4.19.3.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Delete Individual subscription
	Check HTTP Response Status Code Is    405

*** Keywords ***
Check resource existence
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    Integer    response status    200