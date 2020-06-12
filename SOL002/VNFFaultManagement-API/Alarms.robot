*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library     Collections

*** Test Cases ***
POST Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.1
    ...    Test title: POST Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
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
    ...    Reference: Clause 7.4.2.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
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
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
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
    ...    Reference: Clause 7.4.2.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails   

GET information about multiple alarms with "all_fields" attribute selector
    [Documentation]    Test ID: 6.3.4.1.5
    ...    Test title: GET information about multiple alarms with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms with exclude_default attribute selector
    [Documentation]    Test ID: 6.3.4.1.6
    ...    Test title: GET information about multiple alarms with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

    
GET information about multiple alarms with fields attribute selector
    [Documentation]    Test ID: 6.3.4.1.7
    ...    Test title: GET information about multiple alarms with fields attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
     
GET information about multiple alarms with "exclude_fields" attribute selector
    [Documentation]    Test ID: 6.3.4.1.8
    ...    Test title: GET information about multiple alarms with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: none
    GET Alarms Task with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms  
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 6.3.4.1.9
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
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
    ...    Reference: Clause 7.4.2.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
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
    ...    Reference: Clause 7.4.2.3.6 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: the alarm is not deleted
    DELETE Alarms Task
    Check HTTP Response Status Code Is    405
    
GET information about multiple alarms to get Paged Response
    [Documentation]    Test ID: 6.3.4.1.12
    ...    Test title: GET information about multiple alarms to get Paged Response
    ...    Test objective: The objective is to retrieve information about the alarms to get paged response
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions:  
    GET Alarms Task
    Check HTTP Response Status Code Is    200
    Check LINK in Header 
    
GET information about multiple alarms for Bad Request Response too big
    [Documentation]    Test ID: 6.3.4.1.13
    ...    Test title: GET information about multiple alarms for Bad Request Response too big
    ...    Test objective: The objective is to test that GET method fail retrieving status information about Alarms when Response is too big, and perform the JSON schema validation of the failed operation HTTP response
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET information about alarms with attribute-based filter "id"
    [Documentation]    Test ID: 6.3.4.1.14
    ...    Test title: GET information about alarms with attribute-based filter "id"
    ...    Test objective: The objective is to retrieve information about the alarm list with alarm filter "id"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter "id"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarm
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "id"
    
GET information about multiple alarms with attribute-based filter "vnfcInstanceIds"
    [Documentation]    Test ID: 6.3.4.1.15
    ...    Test title: GET information about multiple alarms with attribute-based filter "vnfcInstanceIds"
    ...    Test objective: The objective is to retrieve information about the alarm list with attribute filter "vnfcInstanceIds"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter "vnfcInstanceIds"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms 
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "vnfcInstanceIds"
    
GET information about multiple alarms with attribute-based filter "rootCauseFaultyResource.faultyResourceType"
    [Documentation]    Test ID: 6.3.4.1.16
    ...    Test title: GET information about multiple alarms with attribute-based filter "rootCauseFaultyResource.faultyResourceType"
    ...    Test objective: The objective is to retrieve information about the alarm list with attribute filter "rootCauseFaultyResource.faultyResourceType"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter "rootCauseFaultyResource_faultyResourceType"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms 
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "rootCauseFaultyResource_faultyResourceType"
    
GET information about multiple alarms with attribute-based filter "eventType"
    [Documentation]    Test ID: 6.3.4.1.17
    ...    Test title: GET information about multiple alarms with attribute-based filter "eventType"
    ...    Test objective: The objective is to retrieve information about the alarm list with attribute filter "eventType"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter "eventType"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms 
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "eventType"
    
GET information about multiple alarms with attribute-based filter "perceivedSeverity"
    [Documentation]    Test ID: 6.3.4.1.18
    ...    Test title: GET information about multiple alarms with attribute-based filter "perceivedSeverity"
    ...    Test objective: The objective is to retrieve information about the alarm list with attribute filter "perceivedSeverity"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter "perceivedSeverity"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms 
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "perceivedSeverity"
    
GET information about multiple alarms with attribute-based filter "probableCause"
    [Documentation]    Test ID: 6.3.4.1.19
    ...    Test title: GET information about multiple alarms with attribute-based filter "probableCause"
    ...    Test objective: The objective is to retrieve information about the alarm list with attribute filter "probableCause"
    ...    Pre-conditions: 
    ...    Reference: Clause 7.4.2.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with filter "probableCause"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms 
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "probableCause"

*** Keywords ***
POST Alarms Task
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
PUT Alarms Task
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
PATCH Alarms Task
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
DELETE Alarms Task
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}			
GET Alarms Task	
	Log    Query VNF The GET method queries information about multiple alarms.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
GET Alarms Task with filter
	Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	   	
GET Alarms Task with invalid filter
	Log    Query VNF The GET method queries information about multiple alarms with filters.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?${invalid_alarm_filter}=${managedObjectId} 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
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
    Should Be Equal As Strings    ${response['status']}    ${expected_status}
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
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}
    
GET Alarms Task with filter "id"
	Log    Query VNF The GET method queries information about multiple alarms with filters "id".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?id=${alarmId}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "id"
    Should Be Equal As Strings    ${response['body']['id']}    ${alarmId}

GET Alarms Task with filter "vnfcInstanceIds"
	Log    Query VNF The GET method queries information about multiple alarms with filters "vnfcInstanceIds".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?vnfcInstanceIds=${vnfcInstanceIds}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "vnfcInstanceIds"
    :FOR   ${item}   IN  @{response['body']}
    Lists Should Be Equal     ${item['vnfcInstanceIds']}    ${vnfcInstanceIds}
    END
	
GET Alarms Task with filter "rootCauseFaultyResource_faultyResourceType"
	Log    Query VNF The GET method queries information about multiple alarms with filters "rootCauseFaultyResource.faultyResourceType".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?rootCauseFaultyResource.faultyResourceType=${faultyResourceType}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "rootCauseFaultyResource_faultyResourceType"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings    ${item['rootCauseFaultyResource']['faultyResourceType']}   ${faultyResourceType}
    END
	
GET Alarms Task with filter "eventType"
	Log    Query VNF The GET method queries information about multiple alarms with filters "eventType".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?eventType=${eventType}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "eventType"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings    ${item['eventType']}   ${eventType}
    END
	
GET Alarms Task with filter "perceivedSeverity"
	Log    Query VNF The GET method queries information about multiple alarms with filters "perceivedSeverity".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?perceivedSeverity=${perceivedSeverity}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "perceivedSeverity"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings    ${item['perceivedSeverity']}   ${perceivedSeverity}
    END
	
GET Alarms Task with filter "probableCause"
	Log    Query VNF The GET method queries information about multiple alarms with filters "probableCause".
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/alarms?probableCause=${probableCause}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "probableCause"
    :FOR   ${item}   IN  @{response['body']}
    Should Be Equal As Strings    ${item['probableCause']}   ${probableCause}
    END