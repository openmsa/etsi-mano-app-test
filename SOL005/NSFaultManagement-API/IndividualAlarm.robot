*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource   environment/variables.txt
Resource   NSFMOperationKeywords.robot  
Library    REST     ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    OperatingSystem
Library    DependencyLibrary

*** Test Cases ***
POST Individual Alarm - Method not implemented
     [Documentation]    Test ID: 8.4.3.1
    ...    Test title:POST Individual Alarm - Method not implemented
    ...    Test objective: The objective is to post alarms
    ...    Pre-conditions: 
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do POST Individual Alarm
    Check HTTP Response Status Code Is    405

GET information about Individual Alarm 
    [Documentation]    Test ID: 8.4.3.2-1
    ...    Test title: GET information about Individual Alarm 
    ...    Test objective: The objective is to read an individual alarm.
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID: 
    ...    Applicability: 
    ...    Post-Conditions:   
    Do GET Individual Alarm
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is   ${CONTENT_TYPE}
    Check HTTP Response Body Json Schema Is    alarm.schema.json
    
GET information about Invalid Individual Alarm 
    [Documentation]    Test ID: 8.4.3.2-2
    ...    Test title: GET information about Invalid Individual Alarm 
    ...    Test objective: The objective is to read an Invalid individual alarm.
    ...    Pre-conditions: The related alarm does not exists
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID: 
    ...    Applicability: 
    ...    Post-Conditions:   
    Do GET Invalid Individual Alarm
    Check HTTP Response Status Code Is    404
    

PUT Individual Alarm - Method not implemented
    [Documentation]    Test ID: 8.4.3.3
    ...    Test title:PUT Individual Alarm - Method not implemented
    ...    Test objective: The objective is to put an individual alarm
    ...    Pre-conditions: 
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do PUT Individual Alarm
    Check HTTP Response Status Code Is    405

PATCH Alarm
    [Documentation]    Test ID: 8.4.3.4-1
    ...    Test title: Modify an individual alarm resource
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: 
    Do PATCH Individual Alarm
    Check HTTP Response Status Code Is    200
    Check HTTP Response Header ContentType is    ${CONTENT_TYPE}    
    Check HTTP Response Body Json Schema Is    alarmModifications.schema.json
    
PATCH Alarm - Conflict
    [Documentation]    Test ID: 8.4.3.4-2
    ...    Test title: Modify an individual alarm resource - Conflict
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 8.4.3 - SOL002 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that the alarm is in ackownledged state
    Do PATCH Individual Alarm
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json
   

PATCH Alarm - Precondition failed
    [Documentation]    Test ID: 8.4.3.4-3
    ...    Test title: Modify an individual alarm resource - Precondition failed
    ...    Test objective: The objective is to Modify an individual alarm resource
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: 
    ...    Post-Conditions: The alarm resource is not modified
    Depends On Test    PATCH Alarm    # If the previous test scceeded, it means that Etag has been modified
    Do PATCH Individual Alarm Conflict
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is    ProblemDetails.schema.json

DELETE Individual Alarm - Method not implemented
    [Documentation]    Test ID: 8.4.3.5
    ...    Test title:DELETE Individual Alarm - Method not implemented
    ...    Test objective: The objective is to Delete an individual alarms
    ...    Pre-conditions: 
    ...    Reference: section 8.4.3 - SOL005 v2.4.1
    ...    Config ID:
    ...    Applicability: 
    ...    Post-Conditions:  
    Do DELETE Individual Alarm
    Check HTTP Response Status Code Is    405
