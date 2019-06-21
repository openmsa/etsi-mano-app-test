*** Settings ***
# Suite setup     Expect spec    SOL003-VNFLifecycleManagement-API.yaml
Resource    environment/variables.txt 
Resource    FaultManagement-APIKeyword.robot
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT} 
Library    OperatingSystem
Library    JSONLibrary
Library    JSONSchemaLibrary    schemas/
Library    DependencyLibrary



*** Test Cases ***
POST Alarm - Method not implemented
     [Documentation]    Test ID: 7.3.5.2.1
    ...    Test title: POST Alarm - Method not implemented
    ...    Test objective: The objective is to test that Post method is not allowed to create Fault management individual alarm on VNF 
    ...    Pre-conditions: none
    ...    Reference: section 7.4.3.3.1 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none  
    Send POST request for fault management Individual Alarm
    Check HTTP Response Status Code Is    405   

Get information about an fault management individual alarm
    [Documentation]    Test ID: 7.3.5.2.2
    ...    Test title: Get information about an fault management individual alarm
    ...    Test objective: The objective is to retrieve information about an individual alarm and perform a JSON schema and content validation of the returned alarm data structure
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none 
    GET Fault Management Individual Alarm
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    alarm

PUT Alarm - Method not implemented
    [Documentation]    Test ID: 7.3.5.2.3
    ...    Test title: PUT Alarm - Method not implemented
    ...    Test objective: he objective is to test that PUT method is not allowed to for Fault management individual alarm on VNF 
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  none 
    PUT Fault Management Individual Alarm
    Check HTTP Response Status Code Is    405

PATCH Fault Management Individual Alarm
    [Documentation]    Test ID: 7.4.5.2.4
    ...    Test title: PATCH Fault Management Individual Alarm
    ...    Test objective: The objective is to Modify an individual alarm resource and perform a JSON schema and content validation of the returned alarm data structure
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Check Postcondition VNF fault management individual alarm Exists
    PATCH Fault Management Individual Alarm
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is  alarmModification

Modify an individual alarm resource - Precondition failed
    [Documentation]    Test ID: 7.4.5.2.5
    ...    Test title: Modify an individual alarm resource - Precondition failed
    ...    Test objective: The objective is to test that we cannot Modify an individual alarm resource if the alarm is already in the state that is requested to be set
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Check Postcondition VNF fault management individual alarm Exists  
    PATCH Fault Management Individual Alarm - precondition failed
    Check HTTP Response Status Code Is    409
    Check HTTP Response Body Json Schema Is  ProblemDetails

Modify an individual alarm resource - Conflict
    [Documentation]    Test ID: 7.4.5.2.6
    ...    Test title: Modify an individual alarm resource - Conflict
    ...    Test objective: The objective is to test that we cannot Modify an individual alarm resource if the resource was modified by another entity
    ...    Pre-conditions: The related alarm exists
    ...    Reference: section 7.4.3.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none
    Depends On Test    PATCH Fault Management Individual Alarm
    Check Postcondition VNF fault management individual alarm Exists
    PATCH Fault Management Individual Alarm Conflict
    Check HTTP Response Status Code Is    412
    Check HTTP Response Body Json Schema Is     ProblemDetails

DELETE Alarm - Method not implemented
     [Documentation]    Test ID: 7.3.5.2.7
    ...    Test title: DELETE Alarm - Method not implemented
    ...    Test objective: The objective is to test that DELETE method is not allowed to for Fault management individual alarm on VNF 
    ...    Pre-conditions: nona
    ...    Reference: section 7.4.3.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions:  The individual alarm still exists 
    DELETE Fault Management Individual Alarm
    Check HTTP Response Status Code Is    405
    Check Postcondition VNF fault management individual alarm Exists