*** Settings ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Resource    environment/variables.txt
Resource   NSLCMOperationKeywords.robot   
Library    MockServerLibrary
Library    Process
Library    OperatingSystem


*** Test Cases ***
Deliver a notification - Operation Occurence
    [Documentation]    Test ID: 5.3.2.17.1
    ...    Test title: POST delivers a notification from the server to the client
    ...    Test objective: The objective is to test that POST method trigger a notification about lifecycle changes triggered by a NS LCM operation occurrence
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Operation occurrence
Deliver a notification - Id Creation
    [Documentation]    Test ID: 5.3.2.17.2
    ...    Test title: POST delivers a notification from the server to the client
    ...    Test objective: The objective is to test that POST method trigger a notification about the creation of a NS identifier and the related NS instance resource
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    POST Id creation
Deliver a notification - Id deletion
    [Documentation]    Test ID: 5.3.2.17.3
    ...    Test title: POST delivers a notification from the server to the client
    ...    Test objective: The objective is to test that POST method trigger a notification about the deletion of a NS identifier and the related NS instance resource
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none    
    POST Id deletion

GET a notification end point
    [Documentation]    Test ID: 5.3.2.17.4 
    ...    Test title: GET allows the server to test the notification endpoint that is provided by the client
    ...    Test objective: The objective is to test that GET method successfully test the notification endpoint
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    GET notification endpoint

PUT notification - Method not implemented
    [Documentation]    Test ID: 5.3.2.17.5
    ...    Test title: PUT notification endpoint  - Method not implemented
    ...    Test objective: The objective is to test that the PUT method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    PUT notification

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.2.17.6
    ...    Test title: PATCH notification endpoint  - Method not implemented
    ...    Test objective: The objective is to test that the PATCH method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none     
    PATCH subscriptions

DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 5.3.2.17.7
    ...    Test title: DELETE notification endpoint  - Method not implemented
    ...    Test objective: The objective is to test that the DELETE method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 6.4.18.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none 
    DELETE subscriptions
