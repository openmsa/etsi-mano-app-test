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
    ...    Pre-conditions: none.
    ...    Reference:  section 6.4.2.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: A Ns instance is instantiated.
    POST New nsInstance
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is    NsInstance

Get information about multiple NS instances  
    [Documentation]    Test ID: 5.3.2.1.2
    ...    Test title: Get information about multiple NS instances
    ...    Test objective: The objective is to test the retrieval of all the available NS Instances and perform a JSON schema and content validation of the collected instance data structure
    ...    Pre-conditions: A Ns instance is instantiated.
    ...    Reference:  section 6.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: A Ns instance is instantiated.
    GET NsInstances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsInstances  
    
Get information about multiple NS instances Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.3.2.1.3
    ...    Test title: Get information about multiple NS instances Bad Request Invalid attribute-based filtering parameters
    ...    Test objective: The objective is to test the retrieval of all the available NS Instances using attribute-based filter and perform a JSON schema and content validation of the collected instance data structure
    ...    Pre-conditions: A Ns instance is instantiated.
    ...    Reference:  section 6.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: none.
    GET NsInstance Invalid Attribute-Based filtering parameter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
Get information about multiple NS instances Bad Request Invalid attribute selector
    [Documentation]    Test ID: 5.3.2.1.4
    ...    Test title: Get information about multiple NS instances Bad Request Invalid attribute selector
    ...    Test objective: The objective is to test the retrieval of all the available NS Instances using attribute-based filter and perform a JSON schema and content validation of the collected instance data structure
    ...    Pre-conditions: A Ns instance is instantiated.
    ...    Reference:  section 6.4.2.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none.
    ...    Post-Conditions: none.
    GET NsInstance Invalid Attribute Selector
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
PUT NSInstances - Method not implemented
    [Documentation]    Test ID: 5.3.2.1.5
    ...    Test title: PUT Individual NS instance - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify a NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.2.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified by the operation
    PUT NSInstances
    Check HTTP Response Status Code Is    405
    
PATCH NSInstances - Method not implemented
     [Documentation]    Test ID: 5.3.2.1.6
    ...    Test title: PUT NSInstances - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to modify a NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.2.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified by the operation
    PATCH NSInstances
    Check HTTP Response Status Code Is    405

DELETE NSInstances - Method not implemented
     [Documentation]    Test ID: 5.3.2.1.7
    ...    Test title: DELETE NSInstances - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to modify a list of NS instance
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.2.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified by the operation
    DELETE NSInstances
    Check HTTP Response Status Code Is    405