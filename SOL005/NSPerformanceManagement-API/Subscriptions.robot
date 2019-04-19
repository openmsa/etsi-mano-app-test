*** Settings ***
Documentation     This resource represents subscriptions. The client can use this resource to subscribe to notifications related to VNF
...               performance management and to query its subscriptions.
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          NSPerformanceManagementKeywords.robot
Library           OperatingSystem
Library           JSONSchemaLibrary    schemas/
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Get All NSD Performance Subscriptions
    Get all NSD Performance Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions


Get NSD Performance Subscriptions with attribute-based filter
    Get NSD Performance Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter


Get NSD Performance Subscriptions with invalid attribute-based filter
    Get NSD Performance Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 


GET NSD Performance Subscription with invalid resource endpoint
    Get NSD Performance Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    

Create new NSD Performance subscription
    Send Post Request for NSD Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition NSD Performance Subscription Is Set
    

Create duplicated NSD Performance subscription with NFVO not creating duplicated subscriptions
    [Tags]    no-duplicated-subs
    Send Post Request for Duplicated NSD Performance Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource URI Returned in Location Header Is Valid



Create duplicated NSD Performance subscription with NFVO creating duplicated subscriptions
    [Tags]    duplicated-subs
    Send Post Request for Duplicated NSD Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition NSD Performance Subscription Is Set 


PUT NSD Performance Subscriptions - Method not implemented
    Send Put Request for NSD Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
    
PATCH NSD Performance Subscriptions - Method not implemented
    Send Patch Request for NSD Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE NSD Performance Subscriptions - Method not implemented
    Send Delete Request for NSD Performance Subscriptions
    Check HTTP Response Status Code Is    405

