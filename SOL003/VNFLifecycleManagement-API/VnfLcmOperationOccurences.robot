*** Settings ***
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Resource    VnfLcmMntOperationKeywords.robot

*** Test Cases ***
POST VNF LCM Operation occurrences - Method not implemented
    [Documentation]    Test ID: 7.3.1.11.1
    ...    Test title: POST VNF LCM Operation occurrences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Post VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    405

GET status information about multiple VNF LCM Operation OCC 
    [Documentation]    Test ID: 7.3.1.11.2
    ...    Test title: GET status information about multiple VNF LCM Operation OCC
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs 

GET status information about multiple VNF LCM Operation OCC Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 7.3.1.11.3
    ...    Test title: GET status information about multiple VNF LCM Operation OCC Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to test that GET method fail retrieving status information about multiple VNF lifecycle management operation occurrences because attribute is invalid.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET VNF LCM Operation occurrences invalid attribute
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET status information about multiple VNF LCM Operation OCC Bad Request Invalid attribute selector
    [Documentation]    Test ID: 7.3.1.11.4
    ...    Test title: GET status information about multiple VNF LCM Operation OCC Bad Request Invalid attribute selector
    ...    Test objective: The objective is to test that GET method fail retrieving status information about multiple VNF lifecycle management operation occurrences because attribute is invalid.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET VNF LCM Operation occurrences invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET status information about multiple VNF LCM Operation OCC with "all_fields"   
    [Documentation]    Test ID: 7.3.1.11.5
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "all_fields"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with all_fields attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs 

GET status information about multiple VNF LCM Operation OCC with "exlude_default"   
    [Documentation]    Test ID: 7.3.1.11.6
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "exclude_default"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with exclude_default attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs 

GET status information about multiple VNF LCM Operation OCC with "fields"   
    [Documentation]    Test ID: 7.3.1.11.7
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "fields"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with fields attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs

GET status information about multiple VNF LCM Operation OCC with "exclude_fields"   
    [Documentation]    Test ID: 7.3.1.11.8
    ...    Test title: GET status information about multiple VNF LCM Operation OCC with "exclude_fields"
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    Get VNF LCM Operation occurrences with exclude_fields attribute selector
    Check HTTP Response Status Code Is    202
    Check HTTP Response Body Json Schema Is    VnfLcmOpOccs
            
PUT status information about multiple VNF LCM Operation OCC - Method not implemented
     [Documentation]    Test ID: 7.3.1.11.9
    ...    Test title: PUT status information about multiple VNF LCM Operation OCC - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    405

PATCH status information about multiple VNF LCM Operation OCC - Method not implemented
    [Documentation]    Test ID: 7.3.1.11.10
    ...    Test title: PATCH status information about multiple VNF LCM Operation OCC - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    405

DELETE status information about multiple VNF LCM Operation OCC - Method not implemented
    [Documentation]    Test ID: 7.3.1.11.11
    ...    Test title: DELETE status information about multiple VNF LCM Operation OCC - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    405

GET status information about multiple VNF LCM Operation OCC to get Paged Response
    [Documentation]    Test ID: 7.3.1.11.12
    ...    Test title: GET status information about multiple VNF LCM Operation OCC to get Paged Response
    ...    Test objective: The objective is to test that GET method retrieve Query status information about multiple VNF lifecycle management operation occurrences to get a Paged Response.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    202
    Check LINK in Header

GET status information about multiple VNF LCM Operation OCC - Bad Request Response too Big
    [Documentation]    Test ID: 7.3.1.11.13
    ...    Test title: GET status information about multiple VNF LCM Operation OCC - Bad Request Response too Big
    ...    Test objective: The objective is to test that GET method fail retrieving status information about multiple VNF lifecycle management operation occurrences because response is too big. The test also checks the JSON schema of the unsuccessful operation HTTP response.
    ...    Pre-conditions: none
    ...    Reference: Clause 5.4.12.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none   
    GET VNF LCM Operation occurrences
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails