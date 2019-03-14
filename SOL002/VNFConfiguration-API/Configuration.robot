*** Settings ***
Resource    environment/variables.txt 
Library    REST    ${EM-VNF_SCHEMA}://${EM-VNF_HOST}:${EM-VNF_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    DependencyLibrary

*** Test Cases ***
Set new VNF Configuration
    [Documentation]    Test ID: 6.3.1.1.1
    ...    Test title: Set a new VNF Configuration
    ...    Test objective: The objective is to test the creation of a new VNF configuration and perform a JSON schema validation of the returned configuration data structure
    ...    Pre-conditions: A VNF instance is instantiated
    ...    Reference:  section 9.4.2.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions: The configuration is successfully set in the VNF and it matches the issued configuration
    Send VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    ETag
    Check HTTP Response Body Json Schema Is   vnfConfigModifications.schema.json
    Check Postcondition VNF Is Configured

Get information about a VNF configuration
    [Tags]    no-etag
    [Documentation]    Test ID: 6.3.1.1.2
    ...    Test title: Get information about a VNF configuration
    ...    Test objective: The objective is to test the retrieval of an existing VNF instance configuration and perform a JSON schema validation of the collected configuration data structure
    ...    Pre-conditions: A VNF instance is instantiated. The VNF instance is already configured.
    ...    Reference: section 9.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   vnfConfiguration.schema.json

Get information about a VNF configuration with HTTP Etag
    [Tags]    etag
    [Documentation]    Test ID: 6.3.1.1.3
    ...    Test title: Get information about a VNF configuration with HTTP Etag
    ...    Test objective: The objective is to test the retrieval of an existing VNF instance configuration, check the generation by the VNF of an HTTP Etag opaque identifier, and perform a JSON schema validation of the collected configuration data structure
    ...    Pre-conditions:  A VNF instance is instantiated. The VNF instance is already configured
    ...    Reference:  section 9.4.2.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions: none
    Get VNF configuration
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header Contains    ETag
    Check HTTP Response Body Json Schema Is   vnfConfiguration.schema.json

Set new VNF Configuration - HTTP Etag precondition unsuccessful
    [Tags]    etag
    [Documentation]    Test ID: 6.3.1.1.4
    ...    Test title: Set a new VNF Configuration - HTTP Etag precondition unsuccessful
    ...    Test objective: The objective is to test the unsuccess in setting a duplication of VNF configuration identified by an already used HTTP Etag identifier. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions:  A VNF instance is instantiated. The VNF instance is already configured (Test ID 6.3.1.1.1) with a given HTTP Etag identifier.
    ...    Reference:  section 9.4.2.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: The VNF supports the generation of HTTP Etag opaque identifiers
    ...    Post-Conditions:  The VNF configuration is not modified by the unsuccessful operation and it matches the configuration issued in Test ID 6.3.1.1.1
    Send Duplicated VNF configuration
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is   ProblemDetails
    Check Postcondition VNF Configuration Unmodified (Implicit)

POST VNF Configuration - Method not implemented
    [Documentation]    Test ID: 6.3.1.1.5
    ...    Test title: POST VNF Configuration - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed to create a new VNF configuration
    ...    Pre-conditions: A VNF instance is instantiated. The VNF instance is alrseady configured
    ...    Reference: section 9.4.2.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    Send POST Request for VNF Configuration
    Check HTTP Response Status Code Is    405 

PUT VNF Configuration - Method not implemented
    [Documentation]    Test ID: 6.3.1.1.6
    ...    Test title: PUT VNF Configuration - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify an existing VNF configuration
    ...    Pre-conditions:  A VNF instance is instantiated. The VNF instance is already configured
    ...    Reference: section 9.4.2.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    Send PUT Request for VNF Configuration
    Check HTTP Response Status Code Is    405

DELETE VNF Configuration - Method not implemented
    [Documentation]    Test ID: 6.3.1.1.7
    ...    Test title: Delete VNF Configuration - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete an existing VNF configuration
    ...    Pre-conditions:  A VNF instance is instantiated. The VNF instance is already configured
    ...    Reference: section 9.4.2.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: The VNF configuration is not deleted by the unsuccessful operation
    Send DELETE Request for VNF Configuration
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Configuration Exists
    
*** Keywords ***    
Get VNF configuration
    Log    Query VNF The GET method queries information about a configuration.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/configuration
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send VNF configuration
    log    Trying to perform a PATCH. This method modifies the configuration    
    Set Headers  {"Accept":"${ACCEPT}"} 
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"} 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/vnfConfigModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}
    Set Suite Variable    &{etag}    ${response[0]['headers']['ETag']}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    ${status}=    Convert To Integer    ${expected_status}    
    Should Be Equal    ${response[0]['status']}    ${status}
    Log    Status code validated

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Log    ${response[0]['headers']}
    Should Contain    ${response[0]['headers']}    ${CONTENT_TYPE}
    Log    Header is present
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${schema}
    Should Contain    ${response[0]['headers']['Content-Type']}    application/json
    Validate Json    ${schema}    ${response[0]['body']}
    Log    Json Schema Validation OK
      
Check Postcondition VNF Configuration Unmodified (Implicit)
    Log    Check Implicit Postcondition
    Check Postcondition VNF Is Configured

Check Postcondition VNF Configuration Exists
    Log    Check Postcondition VNF exists
    Check Postcondition VNF Is Configured
    
Check Postcondition VNF Is Configured
    Log    Check Postcondition for VNF Configuration
    Get VNF configuration
    ${input_file}=    Get File    jsons/vnfConfigModifications.json
    ${input}=    evaluate    json.loads('''${input_file}''')    json
    Should Be Equal  ${response[0]['body']}    ${input} 

Send Duplicated VNF configuration
    Depends On Test    Send VNF configuration    # If the previous test scceeded, it means that Etag has been modified
    log    Trying to perform a PATCH. This method modifies an individual alarm resource
    Set Headers  {"Accept":"${ACCEPT}"}
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Set Headers    {"If-Match": "${etag[0]}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/vnfConfigModifications.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/configuration    ${body}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send POST Request for VNF Configuration
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/configuration
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
Send PUT Request for VNF Configuration
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/configuration
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
Send DELETE Request for VNF Configuration
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/configuration
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}