*** Settings ***
Suite Setup    Create Sessions
Suite Teardown    Terminate All Processes    kill=true
Resource    environment/configuration.txt
Resource    environment/variables.txt 
Resource    VnfLcmMntOperationKeywords.robot
Library    MockServerLibrary
Library    Process
Library    OperatingSystem
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}

*** Variables ***
${sleep_interval}    20s

*** Test Cases ***
Deliver a notification - Operation Occurence
    [Documentation]    Test ID: 7.3.1.19.1
    ...    Test title: POST Deliver a notification - Operation Occurence
    ...    Test objective: The objective is to test that POST method trigger a notification about lifecycle changes triggered by a VNF LCM operation occurrence
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Operation occurrence

Deliver a notification - Id Creation
     [Documentation]    Test ID: 7.3.1.19.2
    ...    Test title: Deliver a notification - Id Creation
    ...    Test objective: The objective is to test that POST method trigger a notification about the creation of a VNF identifier and the related to a VNF instance resource.
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Id creation

Deliver a notification - Id deletion
    [Documentation]    Test ID: 7.3.1.19.3
    ...    Test title: Deliver a notification - Id deletion
    ...    Test objective: The objective is to test that POST method trigger A notification about the deletion of a VNF identifier and the related to a VNF instance resource
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.1 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    POST Id deletion

GET Test a notification end point
    [Documentation]    Test ID: 7.3.1.19.4
    ...    Test title: GET Test a notification end point
    ...    Test objective: The objective is to test that GET method allows the server to test the notification endpoint that is provided by the client    
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.2 - SOL005 v2.4.1
    ...    Config ID: Config_prod_NFVO
    ...    Applicability: none
    ...    Post-Conditions: none
    GET test endpoint

PUT notification - Method not implemented
    [Documentation]    Test ID: 7.3.1.19.5
    ...    Test title: PUT Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.3 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Put notification subscription
	Check HTTP Response Status Code Is   405

PATCH subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.1.19.6
    ...    Test title: PATCH Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.4 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Patch notification subscription
	Check HTTP Response Status Code Is   405
    
DELETE subscriptions - Method not implemented
    [Documentation]    Test ID: 7.3.1.19.7
    ...    Test title: DELETE Individual Subscription - Method not implemented
    ...    Test objective: The objective is to test that the method is not implemented
    ...    Pre-conditions: none
    ...    Reference:  section 5.4.20.3.5 - SOL003 v2.4.1
    ...    Config ID: Config_prod_VNFM
    ...    Applicability: none
    ...    Post-Conditions: none 
    Delete notification subscription
	Check HTTP Response Status Code Is   405
	
*** Keywords ***
Create Sessions
    Start Process  java  -jar  ${MOCK_SERVER_JAR}  -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}     #The API producer is set to NFVO according to SOL003-5.3.9
