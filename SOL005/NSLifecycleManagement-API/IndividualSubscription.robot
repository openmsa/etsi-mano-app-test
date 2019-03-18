*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

Suite Setup    Check subscription existance 

*** Test Cases ***
Post Individual Subscription - Method not implemented
    Do POST Individual Subscription
    Check HTTP Response Status Code Is    405

Get Information about an individual subscription
    Do GET Individual subscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   subscription.schema.json

PUT an individual subscription - Method not implemented
    Do PUT Individual Subscription
    Check HTTP Response Status Code Is    405

PATCH an individual subscription - Method not implemented
    Do PATCH Individual Subscription
    Check HTTP Response Status Code Is    405
    
DELETE an individual subscription
    Do DELETE Individual Subscription
    Check HTTP Response Status Code Is    204