*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          NSDManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           Process
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Get All NS Descriptor Subscriptions
    Get all NS Descriptor Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdmSubscriptions
    

Get NS Descriptor Subscriptions with attribute-based filter
    Get NS Descriptor Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdmSubscription
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    

Get NS Descriptor Subscriptions with invalid attribute-based filter
    Get NS Descriptor Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 


GET NS Descriptor Subscription with invalid resource endpoint
    Get NS Descriptor Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404
    
    
Create new NS Descriptor subscription
    Send Post Request for NS Descriptor Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    NsdmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition NS Descriptor Subscription Is Set 
    

Create duplicated NS Descriptor subscription with duplication handler
    Send Post Request for Duplicated NS Descriptor Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition Subscription Resource URI Returned in Location Header Is Valid


Create duplicated NS Descriptor subscription without duplication handler
    Send Post Request for Duplicated NS Descriptor Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition NS Descriptor Subscription Is Set 


PUT NS Descriptor Subscriptions - Method not implemented
    Send Put Request for NS Descriptor Subscriptions
    Check HTTP Response Status Code Is    405
    
    
PATCH NS Descriptor Subscriptions - Method not implemented
    Send Patch Request for NS Descriptor Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE NS Descriptor Subscriptions - Method not implemented
    Send Delete Request for NS Descriptor Subscriptions
    Check HTTP Response Status Code Is    405
