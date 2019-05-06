*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          VNFPackageManagementKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
Get All VNF Package Subscriptions
    Get all VNF Package Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PkgmSubscriptions


Get VNF Package Subscriptions with attribute-based filter
    Get VNF Package Subscriptions with attribute-based filters
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PkgmSubscription
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter


Get VNF Package Subscriptions with invalid attribute-based filter
    Get VNF Package Subscriptions with invalid attribute-based filters
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails    
    
GET VNF Package Subscription with invalid resource endpoint
    Get VNF Package Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404


Create new VNF Package subscription
    Send Post Request for VNF Package Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PkgmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Package Subscription Is Set 


Create duplicated VNF Package subscription with duplication handler
    [Tags]    no-duplicated-subs
    Send Post Request for Duplicated VNF Package Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition VNF Package Subscription Is Set    Location


Create duplicated VNF Package subscription without duplication handler
    [Tags]    duplicated-subs
    Send Post Request for Duplicated VNF Package Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Package Subscription Is Set 



PUT VNF Package Subscriptions - Method not implemented
    Send Put Request for VNF Package Subscriptions
    Check HTTP Response Status Code Is    405
    
    
PATCH VNF Package Subscriptions - Method not implemented
    Send Patch Request for VNF Package Subscriptions
    Check HTTP Response Status Code Is    405
    
        
DELETE VNF Package Subscriptions - Method not implemented
    Send Delete Request for VNF Package Subscriptions
    Check HTTP Response Status Code Is    405



