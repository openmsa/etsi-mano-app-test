*** Settings ***
Resource    environment/variables.txt
Resource   NSFMOperationKeywords.robot  
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem

*** Test Cases ***
POST Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.1
    ...    Test title:POST Alarms - Method not implemented
    ...    Test objective: The objective is to test that Post method is not allowed to create Fault management alarms on NFV
    ...    Pre-conditions: none
    ...    Reference: clause 8.4.2.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none 
    ...    Post-Conditions:  alarm not created
    POST Alarms
    Check HTTP Response Status Code Is    405

GET information about multiple alarms
    [Documentation]    Test ID: 5.3.3.1.2
    ...    Test title: GET information about multiple alarms
    ...    Test objective: The objective is to retrieve information about the alarm list and perform a JSON schema and content validation of the returned alarms data structure
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

GET information about multiple alarms with filters
     [Documentation]    Test ID: 5.3.3.1.3
    ...    Test title: GET information about multiple alarms with filters
    ...    Test objective: The objective is to retrieve information about the alarm list and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms With Filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    [Documentation]    Test ID: 5.3.3.1.4
    ...    Test title: GET information about multiple alarms Bad Request Invalid attribute-based filtering parameters
    ...    Test objective:  The objective is to try to retrieve information about the alarm list with invalid filters and perform a JSON schema and content validation of the returned problem details data structure
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:  none
    GET Alarms With Invalid Filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails

GET information about multiple alarms with "all_fields" attribute selector
    [Documentation]    Test ID: 5.3.3.1.5
    ...    Test title: GET information about multiple alarms with "all_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with all_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    
GET information about multiple alarms with exclude_default attribute selector
    [Documentation]    Test ID: 5.3.3.1.6
    ...    Test title: GET information about multiple alarms with "exclude_default" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with exclude_default attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms

    
GET information about multiple alarms with fields attribute selector
    [Documentation]    Test ID: 5.3.3.1.7
    ...    Test title: GET information about multiple alarms with fields attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: 
    GET Alarms Task with fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
     
GET information about multiple alarms with "exclude_fields" attribute selector
    [Documentation]    Test ID: 5.3.3.1.8
    ...    Test title: GET information about multiple alarms with "exclude_fields" attribute selector
    ...    Test objective: The objective is to retrieve information about the alarm list
    ...    Pre-conditions: 
    ...    Reference: clause 8.4.2.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: 
    ...    Post-Conditions: none
    GET Alarms Task with exclude_fields attribute selector
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms  
    
PUT Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.5
    ...    Test title: PUT Alarms - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed for Fault management alarms on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    PUT Alarms
    Check HTTP Response Status Code Is    405
    
    
PATCH Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.6
    ...    Test title: PATCH Alarms - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed for Fault management alarms on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    PATCH Alarms
    Check HTTP Response Status Code Is    405

DELETE Alarms - Method not implemented
    [Documentation]    Test ID: 5.3.3.1.7
    ...    Test title: DELETE Alarms - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed for Fault management alarms on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: alarm not deleted
    DELETE Alarms
    Check HTTP Response Status Code Is    405

GET information about multiple alarms as Paged Response
    [Documentation]    Test ID: 5.3.3.1.8
    ...    Test title: GET information about multiple alarms as Paged Response
    ...    Test objective: The objective is to retrieve information about the alarm list as paged response.
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
GET information about multiple alarms - Bad Request Response too Big
    [Documentation]    Test ID: 5.3.3.1.9
    ...    Test title: GET information about multiple alarms - Bad Request Response too Big
    ...    Test objective:  The objective is to test that the retrieval of information about the alarm list fails because response is too big, and perform a JSON schema and content validation of the returned problem details data structure
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:  none
    GET Alarms
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is    ProblemDetails
    
GET information about multiple alarms with filter "id"
     [Documentation]    Test ID: 5.3.3.1.10
    ...    Test title: GET information about multiple alarms with filter "id"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "id" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarm With Filter "id"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "id"
    
GET information about multiple alarms with filter "rootCauseFaultyComponent.faultyNestedNsInstanceId"
     [Documentation]    Test ID: 5.3.3.1.11
    ...    Test title: GET information about multiple alarms with filter "rootCauseFaultyComponent.faultyNestedNsInstanceId"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "rootCauseFaultyComponent.faultyNestedNsInstanceId" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms With Filter "rootCauseFaultyComponent_faultyNestedNsInstanceId"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "rootCauseFaultyComponent_faultyNestedNsInstanceId"
    
GET information about multiple alarms with filter "rootCauseFaultyComponent.faultyNsVirtualLinkInstanceId"
     [Documentation]    Test ID: 5.3.3.1.12
    ...    Test title: GET information about multiple alarms with filter "rootCauseFaultyComponent.faultyNsVirtualLinkInstanceId"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "rootCauseFaultyComponent.faultyNsVirtualLinkInstanceId" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms With Filter "rootCauseFaultyComponent_faultyNsVirtualLinkInstanceId"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "faultyNsVirtualLinkInstanceId"
    
GET information about multiple alarms with filter "rootCauseFaultyComponent.faultyVnfInstanceId"
     [Documentation]    Test ID: 5.3.3.1.13
    ...    Test title: GET information about multiple alarms with filter "rootCauseFaultyComponent.faultyVnfInstanceId"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "rootCauseFaultyComponent.faultyVnfInstanceId" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms With Filter "rootCauseFaultyComponent_faultyVnfInstanceId"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "faultyVnfInstanceId"
    

GET information about multiple alarms with filter "rootCauseFaultyResource.faultyResourceType"
     [Documentation]    Test ID: 5.3.3.1.14
    ...    Test title: GET information about multiple alarms with filter "rootCauseFaultyResource.faultyResourceType"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "rootCauseFaultyResource.faultyResourceType" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms With Filter "rootCauseFaultyResource_faultyResourceType"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "faultyResourceType"
    
GET information about multiple alarms with filter "eventType"
     [Documentation]    Test ID: 5.3.3.1.15
    ...    Test title: GET information about multiple alarms with filter "eventType"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "eventType" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms with filter "eventType"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "eventType"
    
GET information about multiple alarms with filter "perceivedSeverity"
     [Documentation]    Test ID: 5.3.3.1.16
    ...    Test title: GET information about multiple alarms with filter "perceivedSeverity"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "perceivedSeverity" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms with filter "perceivedSeverity"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "perceivedSeverity"
    
GET information about multiple alarms with filter "probableCause"
     [Documentation]    Test ID: 5.3.3.1.17
    ...    Test title: GET information about multiple alarms with filter "probableCause"
    ...    Test objective: The objective is to retrieve information about the alarm list with filter "probableCause" and perform a JSON schema and content validation of the returned alarms data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.2.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO 
    ...    Applicability:  none
    ...    Post-Conditions: none
    GET Alarms with filter "probableCause"
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarms
    Check PostCondition HTTP Response Body alarms Matches the requested attribute-based filter "probableCause"
    