*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    DependencyLibrary

*** Test Cases ***
Set new VNF Configuration
    [Documentation]    Test ID: 6.3.1
    ...    Test title: Set a new VNF Configuration
    ...    Test objective: The objective is to test the creation of a new VNF configuration
    ...    Pre-conditions: A VNF instance is up and running
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions: The VNF configuration is set
    Send VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Etag
    Check HTTP Response Body Json Schema Is   vnfConfigModifications
    Check Postcondition VNF Is Configured

Get information about a VNF configuration
    [Tags]    no-etag
    [Documentation]    Test ID: 6.3.2
    ...    Test title: Get information about a VNF configuration
    ...    Test objective: The objective is to test the retrieval of an existing VNF instance configuration
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID 6.3.1)
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: The VNF configuration is not modified by the operation
    Get VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfConfiguration
    Check Postcondition VNF Configuration Untouched (Implicit)

Get information about a VNF configuration - with HTTP Etag
    [Tags]    etag
    [Documentation]    Test ID: 6.3.3
    ...    Test title: Get information about a VNF configuration with HTTP Etag
    ...    Test objective: The objective is to test the retrieval of an existing VNF instance configuration with usage of HTTP Etag
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID 6.3.1)
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions: The VNF configuration is not modified by the operation
    Get VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    Etag
    Check HTTP Response Body Json Schema Is   vnfConfiguration
    Check Postcondition VNF Configuration Untouched (Implicit)

Set new VNF Configuration - HTTP Etag precondition failed
    [Tags]    etag
    [Documentation]    Test ID: 6.3.4
    ...    Test title: Set a new VNF Configuration - HTTP Etag precondition failed
    ...    Test objective: The objective is to test the failure in setting a duplication of VNF configuration identified by an already used HTTP Etag identifier.
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID 6.3.1) with a given HTTP Etag identifier.
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions:  The VNF configuration is not modified by the operation
    Send Duplicated VNF configuration
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Configuration Untouched (Implicit)

POST VNF Configuration - Method not implemented
    [Documentation]    Test ID: 6.3.5
    ...    Test title: POST VNF Configuration - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF configuration
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID 6.3.1)
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: The VNF configuration is not modified by the operation
    Send POST Request for VNF Configuration
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Configuration Untouched (Implicit)    

PUT VNF Configuration - Method not implemented
    [Documentation]    Test ID: 6.3.6
    ...    Test title: PUT VNF Configuration - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an existing VNF configuration
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID 6.3.1)
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: The VNF configuration is not modified by the operation
    Send PUT Request for VNF Configuration
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Configuration Untouched (Implicit)   

DELETE VNF Configuration - Method not implemented
    [Documentation]    Test ID: 6.3.7
    ...    Test title: Delete VNF Configuration - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete an existing VNF configuration
    ...    Pre-conditions: A VNF instance is up and running. The VNF instance is already configured (Test ID 6.3.1)
    ...    Reference: section 9.4.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: The VNF configuration is not modified by the operation
    Send DELETE Request for VNF Configuration
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Configuration Untouched (Implicit)
    
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
    ${body}=    Get File    jsons/vnfConfigModifications.json
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
      
Check Postcondition VNF Configuration Untouched (Implicit)
    Log    Check Implicit Postcondition
    Check Postcondition VNF Is Configured
    
Check Postcondition VNF Is Configured
    Log    Check Postcondition for VNF Configuration
    Get VNF configuration
    ${output}=    evaluate    json.loads('''${response.body}''')    json
    ${input}=    Get File    jsons/vnfConfigModifications.json
    Should Be Equal  ${output}    ${input} 

Send Duplicated VNF configuration
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"}
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Set Headers    {"If-Match": "${Etag}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/vnfConfigModifications.json
    ${response}=    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}

Send POST Request for VNF Configuration
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    
Send PUT Request for VNF Configuration
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Put    ${apiRoot}/${apiName}/${apiVersion}/configuration
    
Send DELETE Request for VNF Configuration
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Delete    ${apiRoot}/${apiName}/${apiVersion}/configuration