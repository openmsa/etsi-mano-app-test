*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
POST Create a new NsInstance
    [Documentation]    Test ID: 5.3.2.1.1
    ...    Test title: POST Create a new NsInstance
    ...    Test objective: The objective is to test the creation of a new Ns Instances and perform a JSON schema validation of the collected instance data structure
    ...    Pre-conditions: An NS Instance is already created
    ...    Reference: clause 6.4.2.3.1 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: A Ns instance is instantiated.
    POST New nsInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    NsInstance

GET information about multiple NS instances  
    [Documentation]    Test ID: 5.3.2.1.2
    ...    Test title: GET information about multiple NS instances
    ...    Test objective: The objective is to test the retrieval of all the available NS Instances and perform a JSON schema and content validation of the collected instance data structure
    ...    Pre-conditions: An NS Instance is already created
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: none.
    GET NsInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsInstances  
    
GET information about multiple NS instances Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.3.2.1.3
    ...    Test title: GET information about multiple NS instances Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to query information about multiple NS instances with Invalid attribute-based filtering parameters
    ...    Pre-conditions: An Ns instance is instantiated, a bad attribute-based filter parameter is either malformed or syntactically incorrect (filter parameters are listed in Table 6.4.2.3.2-1  - SOL005 v2.4.1)
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: none.
    GET NsInstance Invalid Attribute-Based filtering parameter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET information about multiple NS instances Bad Request Invalid attribute selector
    [Documentation]    Test ID: 5.3.2.1.4
    ...    Test title: GET information about multiple NS instances Bad Request Invalid attribute selector
    ...    Test objective: The objective is to query information about multiple NS instances with Invalid attribute selector
    ...    Pre-conditions: A Ns instance is instantiated, a bad attribute selector parameter is either malformed or syntactically incorrect (filter parameters are listed in Table 6.4.2.3.2-1  - SOL005 v2.4.1)
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: none.
    GET NsInstance Invalid Attribute Selector
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
GET NSInstances with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.2.1.5
    ...    Test title: GET NSInstances with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active NSInstances with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  
    ...    Post-Conditions: 
    Get NSInstances with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsInstances 

GET NSInstances with "exclude_default" attribute selector
    [Documentation]    Test ID: 5.3.2.1.6
    ...    Test title: GET NSInstances with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve the list of active NSInstances with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  
    ...    Post-Conditions: 
    Get NSInstances with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsInstances

GET NSInstances with "fields" attribute selector
    [Documentation]    Test ID: 5.3.2.1.7
    ...    Test title: GET NSInstances with "fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active NSInstances with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  
    ...    Post-Conditions: 
    Get NSInstances with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsInstances

GET NSInstances with "exclude_fields" attribute selector
    [Documentation]    Test ID: 5.3.2.1.8
    ...    Test title: GET NSInstances with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve the list of active NSInstances with attribute selector
    ...    Pre-conditions: 
    ...    Reference: clause 6.4.2.3.2 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  
    ...    Post-Conditions: 
    Get NSInstances with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   NsInstances
        
PUT NSInstances - Method not implemented
    [Documentation]    Test ID: 5.3.2.1.9
    ...    Test title: PUT Individual NS instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.2.3.3 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified by the operation
    PUT NSInstances
    Check HTTP Response Status Code Is    405
    
PATCH NSInstances - Method not implemented
     [Documentation]    Test ID: 5.3.2.1.10
    ...    Test title: PATCH NSInstances - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.2.3.4 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified by the operation
    PATCH NSInstances
    Check HTTP Response Status Code Is    405

DELETE NSInstances - Method not implemented
     [Documentation]    Test ID: 5.3.2.1.11
    ...    Test title: DELETE NSInstances - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.2.3.5 - ETSI GS NFV-SOL 005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not deleted by the operation
    DELETE NSInstances
    Check HTTP Response Status Code Is    405
