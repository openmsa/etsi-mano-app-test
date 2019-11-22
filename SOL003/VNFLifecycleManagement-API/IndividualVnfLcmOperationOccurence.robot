*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Resource    VnfLcmMntOperationKeywords.robot

*** Test Cases ***
Post Individual VNF LCM Operation occurrences - Method not implemented
    [Documentation]    Test ID: 7.3.1.12.1
    ...    Test title: Post Individual VNF LCM Operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.13.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post Individual VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    405
    
Get information about multiple VNF instances 
    [Documentation]    Test ID: 7.3.1.12.2
    ...    Test title: Get information about multiple VNF instances
    ...    Test objective: The objective is to test that this method retrieve information about a VNF lifecycle management operation occurrence 
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.13.3.2 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Get multiple VNF instances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    VnfLcmOpOcc 

PUT Individual VNF LCM Operation occurrences - Method not implemented
    [Documentation]    Test ID: 7.3.1.12.3
    ...    Test title: PUT Individual VNF LCM Operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.13.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none  
    Put multiple VNF instances
    Check HTTP Response Status Code Is    405

PATCH Individual VNF LCM Operation occurrences - Method not implemented 
    [Documentation]    Test ID: 7.3.1.12.4
    ...    Test title: PATCH Individual VNF LCM Operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.13.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none      
    Patch multiple VNF instances
    Check HTTP Response Status Code Is    405
    
 DELETE Individual VNF LCM Operation occurrences - Method not implemented
    [Documentation]    Test ID: 7.3.1.12.5
    ...    Test title: DELETE Individual VNF LCM Operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.13.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none  
    Delete multiple VNF instances
    Check HTTP Response Status Code Is    405
    
*** Keywords ***
Get multiple VNF instances	
    Log    Query status information about multiple VNF lifecycle management operation occurrences.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	