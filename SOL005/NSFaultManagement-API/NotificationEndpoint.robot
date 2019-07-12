*** Settings ***
Resource    environment/variables.txt 
Resource    NSFMOperationKeywords.robot   
Suite Teardown    Terminate All Processes    kill=true
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Suite Setup    Create Sessions

*** Test Cases ***
Deliver a notification - Alarm
    [Documentation]    Test ID: 8.4.6.2-1
    ...    Test title: Deliver a notification - Alarm
    ...    Test objective: The objective is to notify a NFVO alarm or that the alarm list has been rebuilt.
    ...    Pre-conditions: The NFVO has subscribed to the NSFM alarm
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:   
    Do POST Alarm Notification Endpoint 
    Check Alarm notification Endpoint has been delivered
    Clean Endpoint 

Deliver a notification - Alarm Clearance
    [Documentation]    Test ID: 8.4.6.2-2
    ...    Test title: Deliver a notification - Alarm Clearance
    ...    Test objective: The objective is to notify a NFVO alarm or that the alarm list has been rebuilt.
    ...    Pre-conditions: The NFVO has subscribed to the NSFM alarm
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:   
    Do POST Alarm Clearance Notification Endpoint 
    Check Alarm notification Endpoint has been delivered
    Clean Endpoint 

Deliver a notification - Alarm List Rebuilt
    [Documentation]    Test ID: 8.4.6.2-3
    ...    Test title: Deliver a notification - Alarm List Rebuilt
    ...    Test objective: The objective is to notify a NFVO alarm or that the alarm list has been rebuilt.
    ...    Pre-conditions: The NFVO has subscribed to the NSFM alarm
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do POST Alarm List Rebuilt Notification Endpoint 
    Check Alarm notification Endpoint has been delivered
    Clean Endpoint 

Test a notification end point
    [Documentation]    Test ID: 8.4.6.3
    ...    Test title: Test a notification end point
    ...    Test objective: The objective is to allow the server to test the notification endpoint that is provided by the client, e.g. during subscription
    ...    Pre-conditions: 
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do GET Notification Endpoint
    Check Alarm notification Endpoint has been delivered
    Clean Endpoint 
    
PUT notification - Method not implemented
    [Documentation]    Test ID: 8.4.6.4
    ...    Test title: PUT notification - Method not implemented
    ...    Test objective: The objective is to PUT a notification endpoint. The method should not be implemented
    ...    Pre-conditions: 
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do PUT Notification 
    Clean Endpoint

PATCH notification - Method not implemented
  [Documentation]    Test ID: 8.4.6.5
    ...    Test title: PATCH notification - Method not implemented
    ...    Test objective: The objective is to PATCH a notification endpoint. The method should not be implemented
    ...    Pre-conditions: 
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do PATCH Notification 
    Clean Endpoint
    
DELETE notification - Method not implemented
  [Documentation]    Test ID: 8.4.6.6
    ...    Test title: DELETE notification - Method not implemented
    ...    Test objective: The objective is to DELETE a notification endpoint. The method should not be implemented
    ...    Pre-conditions: 
    ...    Reference: section 8.4.6 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do DELETE Notification 
    Clean Endpoint