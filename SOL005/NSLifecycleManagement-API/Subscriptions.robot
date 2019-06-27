*** Settings ***
Resource    environment/variables.txt 
Resource   NSLCMOperationKeywords.robot   
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/

*** Test Cases ***
Create a new subscription
    POST subscriptions
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is  ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    subscription.schema.json
    

Create a new Subscription - DUPLICATION
    POST subscriptions DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is  ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    subscription.schema.json

Create a new Subscription - NO-DUPLICATION
    POST subscriptions NO DUPLICATION
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Header ContentType is  ${CONTENT_TYPE}

GET Subscriptions
    GET Subscriptions
    Check HTTP Response Status Code Is  200
    Check HTTP Response Body Json Schema Is  subscriptions.schema.json

GET Subscription - Filter
    GET Subscriptions with filter
    Check HTTP Response Status Code Is  200
    Check HTTP Response Body Json Schema Is  subscriptions.schema.json
    
PUT subscriptions - Method not implemented
    PUT subscriptions
    Check HTTP Response Status Code Is    405

PATCH subscriptions - Method not implemented
    PATCH subscriptions
    Check HTTP Response Status Code Is    405

DELETE subscriptions - Method not implemented
    DELETE subscriptions
    Check HTTP Response Status Code Is    405