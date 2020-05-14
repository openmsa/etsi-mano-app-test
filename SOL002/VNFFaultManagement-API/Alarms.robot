*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem

*** Test Cases ***
POST Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.1
    ...    Test title: POST Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.1 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    POST Alarms Task
    Check HTTP Response Status Code Is    405

GET information about multiple alarms 
    [Documentation]    Test ID: 6.3.4.1.2
    ...    Test title: GET information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    GET Alarms Task
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms    

GET information about multiple alarms with attribute-based filter
    [Documentation]    Test ID: 6.3.4.1.3
    ...    Test title: GET information about multiple alarms with attribute-based filter
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.4.1.4
    ...    Test title: GET information about multiple alarms with invalid attribute-based filter
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.2 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails   
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.9
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PUT Alarms Task
    Check HTTP Response Status Code Is    405

PATCH Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.10
    ...    Test title: PATCH Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.4 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    PATCH Alarms Task
    Check HTTP Response Status Code Is    405

DELETE Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.11
    ...    Test title: DELETE Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: clause 7.4.2.3.5 - ETSI GS NFV-SOL 002 [2] v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: the alarm is not deleted
    DELETE Alarms Task
    Check HTTP Response Status Code Is    405

*** Keywords ***
POST Alarms Task
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
PUT Alarms Task
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
PATCH Alarms Task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
DELETE Alarms Task
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}			
GET Alarms Task	
	Log    Query VNF The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}
GET Alarms Task with filter
	Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	   	
GET Alarms Task with invalid filter
	Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
GET Alarms Task with all_fields attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET Alarms Task with exclude_default attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET Alarms Task with fields attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
GET Alarms Task with exclude_fields attribute selector
    Log    Query VNF The GET method queries information about multiple alarms, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/alarms?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
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
