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
     [Documentation]   Test ID: 5.3.3.2.1
    ...    Test title:POST Individual Alarm - Method not implemented
    ...    Test objective: The objective is to test that POST method is not allowed for Fault management individual alarm on NFV
    ...    Pre-conditions: none
    ...    Reference: clause 8.4.3.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions:  alarm is not created
    POST Individual Alarm
    Check HTTP Response Status Code Is    405

GET information about Individual Alarm 
    [Documentation]    Test ID: 5.3.3.2.2
    ...    Test title: GET information about Individual Alarm 
    ...    Test objective: The objective is to retrieve information about individual alarm and perform a JSON schema and content validation of the returned alarm data structure
    ...    Pre-conditions: The related alarm exists
    ...    Reference: clause 8.4.3.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none   
    GET Individual Alarm
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarm
    
GET information about Invalid Individual Alarm 
    [Documentation]    Test ID: 5.3.3.2.3
    ...    Test title: GET information about Invalid Individual Alarm 
    ...    Test objective: The objective is to try to read an Invalid individual alarm and get 404 not found response code
    ...    Pre-conditions: The related alarm does not exists
    ...    Reference: clause 8.4.3.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:   none 
    GET Invalid Individual Alarm
    Check HTTP Response Status Code Is    404
    

PUT Individual Alarm - Method not implemented
    [Documentation]    Test ID: 5.3.3.2.4
    ...    Test title:PUT Individual Alarm - Method not implemented
    ...    Test objective: The objective is to test that PUT method is not allowed for Fault management individual alarm on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.3.3.3 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:   none
    PUT Individual Alarm
    Check HTTP Response Status Code Is    405

PATCH Alarm
    [Documentation]    Test ID: 5.3.3.2.5
    ...    Test title: Modify an individual alarm resource
    ...    Test objective: The objective is to Modify an individual alarm resource and perform a JSON schema and content validation of the returned alarm modifications data structure
    ...    Pre-conditions: The related alarm exists
    ...    Reference: clause 8.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions:  none
    PATCH Individual Alarm
    Check HTTP Response Status Code Is    200  
    Check HTTP Response Body Json Schema Is    alarmModifications
    
PATCH Alarm - Conflict
    [Documentation]    Test ID: 5.3.3.2.6
    ...    Test title: Modify an individual alarm resource - Conflict
    ...    Test objective: The objective is to test that we cannot Modify an individual alarm resource if the alarm is already in the state that is requested to be set
    ...    Pre-conditions: The related alarm exists
    ...    Reference: clause 8.4.3.3.4 - SOL002 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: none
    PATCH Individual Alarm
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is    ProblemDetails
   

PATCH Alarm - Precondition failed
    [Documentation]    Test ID: 5.3.3.2.7
    ...    Test title: Modify an individual alarm resource - Precondition failed
    ...    Test objective: The objective is to test that we cannot Modify an individual alarm resource if the resource was modified by another entity
    ...    Pre-conditions: The related alarm exists
    ...    Reference: clause 8.4.3.3.4 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: 
    PATCH Individual Alarm Conflict
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is    ProblemDetails

DELETE Individual Alarm - Method not implemented
    [Documentation]    Test ID: 5.3.3.2.8
    ...    Test title:DELETE Individual Alarm - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed for Fault management individual alarm on NFV
    ...    Pre-conditions:  none
    ...    Reference: clause 8.4.3.3.5 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability:  none
    ...    Post-Conditions: alarm not deleted
    DELETE Individual Alarm
    Check HTTP Response Status Code Is    405
