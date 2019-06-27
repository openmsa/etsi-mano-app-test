*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post Individual NS LCM occurences - Method not implemented
	POST Individual NS LCM OP Occurence
	Check HTTP Response Status Code Is    405

PUT stauts information about Individual NS LCM OP OCC - Method not implemented
    PUT Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405

PATCH stauts information about Individual NS LCM OP OCC - Method not implemented
    PATCH Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405

DELETE stauts information about Individual NS LCM OP OCC - Method not implemented
    DELETE Individual NS LCM OP Occurence
    Check HTTP Response Status Code Is    405
    
Get stauts information about Individual NS LCM OP OCC   
	GET Individual NS LCN OP Occurence
	Check HTTP Response Status Code Is    200
	Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
	Check HTTP Response Body Json Schema Is    NsLcmOpOcc.schema.json


	