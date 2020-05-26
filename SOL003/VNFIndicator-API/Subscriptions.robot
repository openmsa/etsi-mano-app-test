*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          VNFIndicatorsKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
GET All VNF Indicator Subscriptions
    [Documentation]    Test ID: 7.3.6.4.1
    ...    Test title: GET All VNF Indicator Subscriptions
    ...    Test objective: The objective is to test the retrieval of all VNF indicator subscriptions and perform a JSON schema validation of the returned subscriptions data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none        
    Get All VNF Indicators Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions

GET VNF Indicator Subscriptions with attribute-based filter
    [Documentation]    Test ID: 7.3.6.4.2
    ...    Test title: GET VNF Indicator Subscriptions with attribute-based filter
    ...    Test objective: The objective is to test the retrieval of VNF indicator subscriptions using attribute-based filter, perform a JSON schema validation of the collected indicators data structure, and verify that the retrieved information matches the issued attribute-based filters 
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter

GET VNF Indicator Subscriptions with invalid attribute-based filter
    [Documentation]    Test ID: 7.3.6.4.3
    ...    Test title: GET VNF Indicator Subscriptions with invalid attribute-based filter
    ...    Test objective: The objective is to test that the retrieval of VNF indicator subscriptions fails when using invalid attribute-based filters, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get VNF Indicators Subscriptions with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 
    
GET VNF Indicator Subscriptions with invalid resource endpoint
    [Documentation]    Test ID: 7.3.6.4.4
    ...    Test title: GET VNF Indicator Subscriptions with invalid resource endpoint
    ...    Test objective: The objective is to test that the retrieval of all VNF indicator subscriptions fails when using invalid resource endpoint.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none    
    Get VNF Indicators Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404

Create new VNF indicator subscription
    [Documentation]    Test ID: 7.3.6.4.5
    ...    Test title: Create new VNF indicator subscription
    ...    Test objective: The objective is to test the creation of a new VNF indicator subscription and perform a JSON schema and content validation of the returned subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated.
    ...    Reference: clause 8.4.5.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF indicator subscription is successfully set and it matches the issued subscription   
    Send Post Request for VNF Indicator Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    VnfIndicatorSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Indicator Subscription Is Set
    
Create duplicated VNF indicator subscription with VNFM not creating duplicated subscriptions
    [Tags]    no-duplicated-subs
    [Documentation]    Test ID: 7.3.6.4.6
    ...    Test title: Create duplicated VNF indicator subscription with VNFM not creating duplicated subscriptions
    ...    Test objective: The objective is to test the attempt of a creation of a duplicated VNF indicator subscription and check that no new subscription is created by the VNFM and a link to the original subscription is returned
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM does not support the creation of duplicated subscriptions
    ...    Post-Conditions: The existing VNF indicator subscription returned is available in the VNFM
    Send Post Request for Duplicated VNF indicator Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource Returned in Location Header Is Available

Create duplicated VNF indicator subscription with VNFM creating duplicated subscriptions
    [Tags]    duplicated-subs
    [Documentation]    Test ID: 7.3.6.4.7
    ...    Test title: Create duplicated VNF indicator subscription with VNFM creating duplicated subscriptions
    ...    Test objective: The objective is to test the creation of a duplicated VNF indicator subscription and perform a JSON schema and content validation of the returned duplicated subscription data structure
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.1 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: The VNFM supports the creation of duplicated subscriptions
    ...    Post-Conditions: The duplicated VNF indicator subscription is successfully set and it matches the issued subscription
    Send Post Request for Duplicated VNF indicator Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF indicator Subscription Is Set        

PUT VNF Indicator Subscriptions - Method not implemented
    [Documentation]    TTest ID: 7.3.6.4.8
    ...    Test title: PUT VNF Indicator Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed to modify VNF indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.3 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Put Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405

PATCH VNF Indicator Subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.6.4.9
    ...    Test title: PATCH VNF Indicator Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not allowed to update VNF indicator subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.4 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Send Patch Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405

DELETE VNF Indicator Subscriptions - Method not implemented
   [Documentation]    Test ID: 7.3.6.4.10
    ...    Test title: DELETE VNF Indicator Subscriptions - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to delete VNF indicators subscriptions
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.5 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: The VNF indicator subscriptions are not deleted by the failed operation   
    Send Delete Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF Indicator Subscriptions Exists

GET All VNF Indicator Subscriptions as Paged Response
    [Documentation]    Test ID: 7.3.6.4.11
    ...    Test title: GET All VNF Indicator Subscriptions as Paged Response
    ...    Test objective: The objective is to test the retrieval of all VNF indicator subscriptions as Paged Response.
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none        
    Get All VNF Indicators Subscriptions
    Check HTTP Response Status Code Is    200
    Check LINK in Header
    
GET VNF Indicator Subscriptions - Bad Request Response too Big
    [Documentation]    Test ID: 7.3.6.4.12
    ...    Test title: GET VNF Indicator Subscriptions - Bad Request Response too Big
    ...    Test objective: The objective is to test that the retrieval of VNF indicator subscriptions fails because reponse is too big, and perform the JSON schema validation of the failed operation HTTP response. 
    ...    Pre-conditions: A VNF instance is instantiated. At least one VNF indicator subscription is available in the VNFM.
    ...    Reference: clause 8.4.5.3.2 - ETSI GS NFV-SOL 003 [1] v2.6.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Get All VNF Indicators Subscriptions
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 