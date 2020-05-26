*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library           OperatingSystem
Library           JSONLibrary
Resource          VNFPerformanceManagementKeywords.robot
Resource          environment/subscriptions.txt
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
GET all VNF Performance Subscriptions
    [Documentation]    Test ID: 6.3.3.6.1
    ...    Test title: GET all VNF Performance Subscriptions
    ...    Test objective: The objective is to test the retrieval of all VNF performance subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get all VNF Performance Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions

GET VNF Performance Subscriptions with attribute-based filter
    [Documentation]    Test ID: 6.3.3.6.2
    ...    Test title: GET VNF Performance Subscriptions with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF performance subscriptions using attribute-based filter, perform a JSON schema validation of the collected indicators data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Performance Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter 

GET VNF Performance Management Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 6.3.3.6.3
    ...    Test title: GET VNF Performance Management Subscriptions with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF performance subscriptions fails when using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Performance Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 

GET VNF Performance Subscriptions with invalid resource endpoint
    [Documentation]    Test ID: 6.3.3.6.4
    ...    Test title: GET VNF Performance Subscriptions with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all VNF performance subscriptions fails when using invalid resource endpoint.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get VNF Performance Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    
Create new VNF Performance subscription
    [Documentation]    Test ID: 6.3.3.6.5
    ...    Test title: Create new VNF Performance subscription
    ...    Test objective: The objective is to test the creation of a new VNF performance subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: Clause 6.4.7.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF performance subscription is successfully set and it matches the issued subscription    
    Send Post Request for VNF Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body PmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition VNF Performance Subscription Is Set 


Create duplicated VNF Performance subscription with VNFM not creating duplicated subscriptions
    [Tags]    no-duplicated-subs
    [Documentation]    Test ID: 6.3.3.6.6
    ...    Test title: Create duplicated VNF Performance subscription with VNFM not creating duplicated subscriptions
    ...    Test objective: The objective is to test the attempt of a creation of a duplicated VNF performance subscription and check that no new subscription is created by the VNFM and a link to the original subscription is returned
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM does not support the creation of duplicated subscriptions
    ...    Post-Conditions: The existing VNF performance subscription returned is available in the VNFM 
    Send Post Request for Duplicated VNF Performance Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource Returned in Location Header Is Available

Create duplicated VNF Performance subscription with VNFM creating duplicated subscriptions
    [Tags]    duplicated-subs
    [Documentation]    Test ID: 6.3.3.6.7
    ...    Test title: Create duplicated VNF Performance subscription with VNFM creating duplicated subscriptions
    ...    Test objective: The objective is to test the creation of a duplicated VNF performance subscription and perform a JSON schema and content validation of the returned duplicated subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.1 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM supports the creation of duplicated subscriptions
    ...    Post-Conditions: The duplicated VNF performance subscription is successfully set and it matches the issued subscription
    Send Post Request for Duplicated VNF Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body PmSubscription Attributes Values Match the Issued Subscription
    Check Postcondition VNF Performance Subscription Is Set 

PUT VNF Performance Subscriptions - Method not implemented
    [Documentation]    Test ID: 6.3.3.6.8
    ...    Test title: PUT VNF Performance Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF performance subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.3 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put Request for VNF Performance Subscriptions
    Check HTTP Response Status Code Is    405 
    
PATCH VNF Performance Subscriptions - Method not implemented
    [Documentation]    Test ID: 6.3.3.6.9
    ...    Test title: PATCH VNF Performance Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF performance subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.4 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch Request for VNF Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
DELETE VNF Performance Subscriptions - Method not implemented
    [Documentation]    Test ID: 6.3.3.6.10
    ...    Test title: DELETE VNF Performance Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF performance subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.5 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF performance subscriptions are not deleted by the failed operation   
    Send Delete Request for VNF Performance Subscriptions
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Performance Subscriptions Exists
    
GET VNF Performance Subscriptions to get Paged Response
    [Documentation]    Test ID: 6.3.3.6.11
    ...    Test title: GET VNF Performance Subscriptions to get Paged Response
    ...    Test objective: The objective is to test the retrieval of all VNF performance subscriptions to get Paged Response
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get all VNF Performance Subscriptions
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
GET VNF Performance Management Subscriptions for Bad Request Response too big
    [Documentation]    Test ID: 6.3.3.6.12
    ...    Test title: GET VNF Performance Management Subscriptions for Bad Request Response too big
    ...    Test objective: The objective is to test that the retrieval of VNF performance subscriptions fails when response is too big, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF performance subscription is available in the VNFM.
    ...    Reference: Clause 6.4.7.3.2 - ETSI GS NFV-SOL 002 [2] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Performance Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 
