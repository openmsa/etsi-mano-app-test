*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Post NS LCM occurences - Method not implemented
	Do POST NS LCM OP Occurences
	Check HTTP Response Status Code Is    405

PUT stauts information about multiple NS LCM OP OCC - Method not implemented
    Do PUT NS LCM OP Occurences
    Check HTTP Response Status Code Is    405

PATCH stauts information about multiple NS LCM OP OCC - Method not implemented
    Do PATCH NS LCM OP Occurences
    Check HTTP Response Status Code Is    405

DELETE stauts information about multiple NS LCM OP OCC - Method not implemented
    Do DELETE NS LCM OP Occurences
    Check HTTP Response Status Code Is    405
    
Get stauts information about multiple NS LCM OP OCC   
	Do GET NS LCN OP Occurences
	Check HTTP Response Status Code Is    200
	Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
	Check HTTP Response Body Json Schema Is    NsLcmOpOccs.schema.json

Get stauts information about multiple NS LCM OP OCC Bad Request Invalid attribute-based filtering parameters
	Do GET NS LCN OP Occurences Invalid attribute-based filtering parameters
	Check HTTP Response Status Code Is    400
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json

Get stauts information about multiple NS LCM OP OCC Bad Request Invalid attribute selector
	Do GET NS LCN OP Occurences Invalid attribute selector
	Check HTTP Response Status Code Is    400
	Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
	