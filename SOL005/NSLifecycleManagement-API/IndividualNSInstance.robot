*** Settings ***
Resource   environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Suite Setup    Check resource existance

*** Test Cases ***
Post Individual VNFInstance - Method not implemented
    Do POST IndividualNSInstance
    Check HTTP Response Status Code Is    405

Get Information about an individual NS Instance
    Do GET IndividualNSInstance
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    NsInstance.schema.json
    
PUT Individual NSInstance - Method not implemented 
    Do PUT IndividualNSInstance
    Check HTTP Response Status Code Is    405

PATCH Individual NSInstance - Method not implemented 
    Do PATCH IndividualNSInstance
    Check HTTP Response Status Code Is    405

DELETE Individual NSInstance
    Do DELETE IndividualNSInstance    
    Check HTTP Response Status Code Is    204

DELETE Individual NSInstance Conflict
    [Setup]    Check resource instantiated
    Do DELETE IndividualNSInstance
    Check HTTP Response Status Code Is    409
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
