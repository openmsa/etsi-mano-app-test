*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Individual NS LCM occurences - Method not implemented
    [Documentation]    Test ID: 5.3.2.9.1
    ...    Test title: Post Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.10.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not created in the NFVO
	POST Individual NS LCM OP Occurence
	Check HTTP Response Status Code Is    405

Get status information about Individual NS LCM occurrences   
    [Documentation]    Test ID: 5.3.2.9.2
    ...    Test title: Get status information about Individual NS LCM occurrences
    ...    Test objective: The objective is to test that GET method returns the LCM occurrence of the NS
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.10.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET Individual NS LCN OP Occurence
	Check HTTP Response Status Code Is    200
	Check HTTP Response Body Json Schema Is    NsLcmOpOcc
	
PUT status information about Individual NS LCM occurrences - Method not implemented
     [Documentation]    Test ID: 5.3.2.9.3
    ...    Test title: PUT status information about Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.10.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified from the NFVO
    PUT Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405

PATCH status information about Individual NS LCM occurrences - Method not implemented
     [Documentation]    Test ID: 5.3.2.9.4
    ...    Test title: PATCH status information about Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.10.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not modified from the NFVO
    PATCH Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405

DELETE status information about Individual NS LCM occurrences - Method not implemented
         [Documentation]    Test ID: 5.3.2.9.5
    ...    Test title: DELETE status information about Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference: clause 6.4.10.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: The NS instance is not deleted from the NFVO
    DELETE Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405
    



	