*** Settings ***
Documentation     This resource represents subscriptions. The client can use this resource to subscribe to notifications related to VNF
...               performance management and to query its subscriptions.
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}
Library           OperatingSystem
Library           JSONLibrary
Resource          VNFPerformanceManagementKeywords.robot
Resource          environment/subscriptions.txt
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
GET all VNF Performance Subscriptions  
    Get all VNF Performance Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions


GET VNF Performance Subscription with attribute-based filter
    Get VNF Performance Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PmSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter 


GET VNF Performance Management Subscription with invalid attribute-based filter
    Get VNF Performance Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 


GET VNF Performance Subscription with invalid resource endpoint
    Get VNF Performance Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    
    
Create new VNF Performance subscription
    Send Post Request for VNF Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Performance Subscription Is Set 


Create duplicated VNF Performance subscription with duplication handler
    Send Post Request for Duplicated VNF Performance Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location


Create duplicated VNF Performance subscription without duplication handler
    Send Post Request for Duplicated VNF Performance Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Performance Subscription Is Set 


PUT VNF Performance Subscriptions - Method not implemented
    Send Put Request for VNF Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
    
PATCH VNF Performance Subscriptions - Method not implemented
    Send Patch Request for VNF Performance Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE VNF Performance Subscriptions - Method not implemented
    Send Delete Request for VNF Performance Subscriptions
    Check HTTP Response Status Code Is    405

