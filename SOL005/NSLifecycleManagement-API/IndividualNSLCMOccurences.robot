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
    ...    Test title: POST Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that POST method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.10.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	POST Individual NS LCM OP Occurence
	Check HTTP Response Status Code Is    405

Get stauts information about Individual NS LCM OP OCC   
    [Documentation]    Test ID: 5.3.2.9.2
    ...    Test title: GET NS LCM Occurrences
    ...    Test objective: The objective is to test that GET method return the LCM occurrence of the NS
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.10.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
	GET Individual NS LCN OP Occurence
	Check HTTP Response Status Code Is    200
	Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
	Check HTTP Response Body Json Schema Is    NsLcmOpOcc
	
PUT stauts information about Individual NS LCM OP OCC - Method not implemented
     [Documentation]    Test ID: 5.3.2.9.3
    ...    Test title: PUT Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.10.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PUT Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405

PATCH stauts information about Individual NS LCM OP OCC - Method not implemented
     [Documentation]    Test ID: 5.3.2.9.4
    ...    Test title: PATCH Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.10.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    PATCH Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405

DELETE stauts information about Individual NS LCM OP OCC - Method not implemented
         [Documentation]    Test ID: 5.3.2.9.5
    ...    Test title: DELETE Individual NS LCM occurrences - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.10.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    DELETE Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405
    



	