*** Settings ***
Library           JSONSchemaLibrary    schemas/
Resource          environment/variables.txt    # Generic Parameters
Resource          environment/subscriptions.txt
Resource          VNFIndicatorsKeywords.robot
Library           OperatingSystem
Library           JSONLibrary
Library           REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library           MockServerLibrary
Library           Process
Suite Setup       Create Sessions
Suite Teardown    Terminate All Processes    kill=true

*** Test Cases ***
GET All VNF Indicators Subscriptions
    Get All VNF Indicators Subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions


GET VNF Indicators Subscriptions with attribute-based filter
    Get VNF Indicators Subscriptions with filter
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   VnfIndicatorSubscriptions
    Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter


GET VNF Indicators Subscriptions with invalid attribute-based filter
    Get VNF Indicators Subscriptions with invalid filter
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 
    

GET VNF Indicators Subscriptions with invalid resource endpoint
    Get VNF Indicators Subscriptions with invalid resource endpoint
    Check HTTP Response Status Code Is    404


GET VNF Indicators Subscriptions with invalid authentication token
    Get VNF Indicators Subscriptions with invalid authentication token
	Check HTTP Response Status Code Is    401
    Check HTTP Response Body Json Schema Is   ProblemDetails 


Create new VNF indicator subscription
    Send Post Request for VNF Indicator Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    VnfIndicatorSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF Indicator Subscription Is Set
    
    
 
Create duplicated VNF indicator subscription with duplication handler
    Send Post Request for Duplicated VNF indicator Subscription
    Check HTTP Response Status Code Is    303
    Check HTTP Response Body Is Empty
    Check HTTP Response Header Contains    Location
    Check Postcondition VNF indicator Subscription Is Set    Location


Create duplicated VNF indicator subscription without duplication handler
    Send Post Request for Duplicated VNF indicator Subscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    PmSubscription
    Check HTTP Response Body Matches the Subscription
    Check Postcondition VNF indicator Subscription Is Set        




PUT VNF Indicator Subscriptions - Method not implemented
    Send Put Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405



PATCH VNF Indicator Subscriptions - Method not implemented
    Send Patch Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405


DELETE VNF Indicator Subscriptions - Method not implemented
    Send Delete Request for VNF Indicator Subscriptions
    Check HTTP Response Status Code Is    405


