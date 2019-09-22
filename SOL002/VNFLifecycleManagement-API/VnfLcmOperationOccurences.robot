*** Settings ***
Resource    environment/variables.txt 
Resource    VnfLcmOperationKeywords.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Documentation    This resource represents VNF lifecycle management operation occurrences. The client can use this resource to query
...    status information about multiple VNF lifecycle management operation occurrences.

*** Test Cases ***
POST VNF LCM operation occurences - Method not implemented
    [Documentation]    Test ID: 6.3.5.11.1
    ...    Test title: POST VNF LCM operation occurences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.1 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post VNF LCM OP occurences
    Check HTTP Response Status Code Is    405

GET status information about multiple VNF LCM operation occurrences 
    [Documentation]    Test ID: 6.3.5.11.2
    ...    Test title: GET status information about multiple VNF LCM operation occurrences
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET VNF LCM OP occurences
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs 

GET status information about multiple VNF LCM operation occurrences Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 6.3.5.11.3
    ...    Test title: GET status information about multiple VNF LCM operation occurrences Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to test that GET method fail retrieving status information about multiple VNF lifecycle management operation occurrences because attribute is invalid.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET VNF LCM OP occurences invalid attribute
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET status information about multiple VNF LCM Operation occurrences Bad Request Invalid attribute selector
    [Documentation]    Test ID: 6.3.5.11.4
    ...    Test title: GET status information about multiple VNF LCM Operation occurrences Bad Request Invalid attribute selector
    ...    Test objective: The objective is to test that GET method fail retrieving status information about multiple VNF lifecycle management operation occurrences because attribute is invalid.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET VNF LCM OP occurences invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET status information about multiple VNF LCM Operation OCC with "all_fields"   
    [Documentation]    Test ID: 6.3.5.11.5
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "all_fields"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with all_fields attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs 

GET status information about multiple VNF LCM Operation OCC with "exlude_default"   
    [Documentation]    Test ID: 6.3.5.11.6
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "exclude_default"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with exclude_default attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs 

GET status information about multiple VNF LCM Operation OCC with "fields"   
    [Documentation]    Test ID: 6.3.5.11.7
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "fields"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with fields attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs

GET status information about multiple VNF LCM Operation OCC with "exclude_fields"   
    [Documentation]    Test ID: 6.3.5.11.8
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "exclude_fields"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.2 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with exclude_fields attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs    
    
PUT status information about multiple VNF LCM operation occurrences - Method not implemented
     [Documentation]    Test ID: 6.3.5.11.5
    ...    Test title: PUT status information about multiple VNF LCM operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.3 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT VNF LCM OP occurences
    Check HTTP Response Status Code Is    405

PATCH status information about multiple VNF LCM operation occurrences - Method not implemented
    [Documentation]    Test ID: 6.3.5.11.6
    ...    Test title: PATCH status information about multiple VNF LCM operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT VNF LCM OP occurences
    Check HTTP Response Status Code Is    405

DELETE status information about multiple VNF LCM operation occurrences - Method not implemented
    [Documentation]    Test ID: 6.3.5.11.7
    ...    Test title: DELETE status information about multiple VNF LCM operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.12.3.5 - SOL002 v2.4.1
    ...    Config ID: Config_prod_VE
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE VNF LCM OP occurences
    Check HTTP Response Status Code Is    405