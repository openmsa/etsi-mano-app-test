*** Settings ***
Resource   environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}     ssl_verify=false
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existence

*** Test Cases ***
POST Individual NSInstance - Method not implemented
    [Documentation]    Test ID: 5.3.2.2.1
    ...    Test title: POST Individual NSInstance - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.3.3.1 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: Check Postcondition NS Instance is not created
    POST IndividualNSInstance
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Instance is not created

GET Information about an individual NS Instance
    [Documentation]    Test ID: 5.3.2.2.2
    ...    Test title: GET Information about an individual NS Instance
    ...    Test objective: The objective is to test that GET method returns an individual NS instance
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.3.3.2 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET IndividualNSInstance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsInstance
    
PUT Individual NSInstance - Method not implemented 
    [Documentation]    Test ID: 5.3.2.2.3
    ...    Test title: PUT Individual NSInstance - Method not implemented
    ...    Test objective: TThe objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.3.3.3 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: Check Postcondition NS Instance is not modified
    PUT IndividualNSInstance
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Instance is not modified

PATCH Individual NSInstance - Method not implemented 
    [Documentation]    Test ID: 5.3.2.2.4
    ...    Test title: PATCH Individual NSInstance - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: Clause 6.4.3.3.4 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: Check Postcondition NS Instance is not modified
    PATCH IndividualNSInstance
    Check HTTP Response Status Code Is    405
    Check Postcondition NS Instance is not modified

DELETE Individual NSInstance
     [Documentation]    Test ID: 5.3.2.2.5
    ...    Test title: DELETE Individual NSInstance
    ...    Test objective: The objective is to test that DELETE method delete a not INSTANTIATED NS instance
    ...    Pre-conditions: NS instance is not INSTANTIATED .
    ...    Reference: Clause 6.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: Check Postcondition NS Instance is deleted
    DELETE IndividualNSInstance    
    Check HTTP Response Status Code Is    204
    Check Postcondition NS Instance is deleted

DELETE Individual NSInstance Conflict
    [Documentation]    Test ID: 5.3.2.2.6
    ...    Test title: DELETE Individual NSInstance Conflict
    ...    Test objective: The objective is to test that DELETE method cannot delete an INSTANTIATED NS instance
    ...    Pre-conditions: one instance of a NS in INSTANTIATED state
    ...    Reference: Clause 6.4.3.3.5 - ETSI GS NFV-SOL 005 [3] v2.6.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: Check Postcondition NS Instance is not deleted
    DELETE IndividualNSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
    Check Postcondition NS Instance is not deleted
