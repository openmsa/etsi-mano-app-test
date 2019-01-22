*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${VNF_SCHEMA}://${VNF_HOST}:${VNF_PORT} 
...        spec=SOL002-VNFConfiguration-API.yaml
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    DependencyLibrary

*** Variables ***
${Etag}=    an etag
${Etag_modified}=    12345
${response}=    httpresponse

*** Test Cases ***
POST Configuration - Method not implemented
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405

Get information about a configuration
    [Documentation]    Test ID: 9.4.2.2
    ...    Test title: Get information about a configuration
    ...    Test objective: The objective is to test the retrieval of an existing VNF instance configuration
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID: 9.4.2.1)
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions: The VNF configuration is not modified by the operation
    Get VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Etag
    Check HTTP Response Body Json Schema Is   vnfConfiguration
    Check Postcondition VNF Configuration Untouched

PUT Config - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405

Set new VNF Configuration
    [Documentation]    Test ID: 9.4.2.1
    ...    Test title: Set a new VNF Configuration
    ...    Test objective: The objective is to test the creation of a new VNF configuration
    ...    Pre-conditions: A VNF instance is up and running
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions: The VNF configuration is set
    Send VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Etag
    Check HTTP Response Body Json Schema Is   vnfConfiModifications
    Check Postcondition VNF Is Configured

Set new VNF Configuration - HTTP Etag precondition failed
    [Documentation]    Test ID: 9.4.2.3
    ...    Test title: Set a new VNF Configuration - HTTP Etag precondition failed
    ...    Test objective: The objective is to test the failure in setting a duplication of VNF configuration identified by an already used HTTP Etag identifier.
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID: 9.4.2.1) with a given HTTP Etag identifier.
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions:  The VNF configuration is not modified by the operation
    Send Duplicated VNF configuration
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Configuration Untouched

DELETE Config - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/configuration
    Log    Validate Status code
    Integer    response status    405
    
*** Keywords ***    
Get VNF configuration
    Log    Query VNF The GET method queries information about a configuration.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/configuration

Send VNF configuration
    log    Trying to perform a PATCH. This method modifies the configuration    
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/vnfConfigModifications.json
    ${response}=    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}

Send Duplicated VNF configuration
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource  
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"} 
    Set Headers    {"If-Match": "${Etag}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    json/vnfConfigModifications.json
    ${response}=    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response.status_code}    ${expected_status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${schema}
    ${contentType}=    Get Value From Json    ${response.headers}    $..Content-Type
    Should Be Equal    ${contentType}    ${CONTENT_TYPE}
    ${json}=    evaluate    json.loads('''${response.body}''')    json
    Validate Json    ${schema}    ${json}
    Log    Json Schema Validation OK
    
Check Postcondition VNF Configuration Untouched
    Log    Check Postcondition for GET
    #todo
    
Check Postcondition VNF Is Configured
    Log    Check Postcondition for PATCH
    Get VNF configuration
    ${output}=    evaluate    json.loads('''${response.body}''')    json
    ${input}=    Get File    json/vnfConfigModifications.json
    Should Be Equal  ${output}    ${input}   