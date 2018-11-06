*** Settings ***
Resource    variables.txt 
Library    REST    http://${NFVO_HOST}:${NFVO_PORT}   
...    spec=SOL003-VNFFaultManagement-API.yaml

*** Test Cases ***
Deliver a notification - Operation Occurence
    log    The POST method delivers a notification from the server to the client.
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Post    ${notification_ep}    ${AlarmNotification}
    Log    Validate Status code
    Output    response
    Integer    response status    204

Deliver a notification - Id Creation
    log    The POST method delivers a notification from the server to the client.
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Post    ${notification_ep}    ${AlarmClearedNotification}
    Log    Validate Status code
    Output    response
    Integer    response status    204

Deliver a notification - Id deletion
    log    The POST method delivers a notification from the server to the client.
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Post    ${notification_ep}    ${AlarmListRebuiltNotification} 
    Log    Validate Status code
    Output    response
    Integer    response status    204

Test a notification end point
    log    The GET method allows the server to test the notification endpoint
    Get    ${notification_ep}
    Log    Validate Status code
    Output    response
    Integer    response status    204

PUT notification - Method not implemented
    log    Trying to perform a PUT. This method should not be implemented
    Put    ${notification_ep}    
    Log    Validate Status code
    Output    response
    Integer    response status    405

PATCH subscriptions - Method not implemented
    log    Trying to perform a PATCH. This method should not be implemented
    Patch    ${notification_ep}    
    Log    Validate Status code
    Output    response
    Integer    response status    405

DELETE subscriptions - Method not implemented
    log    Trying to perform a DELETE. This method should not be implemented
    Delete    ${notification_ep}
    Log    Validate Status code
    Output    response
    Integer    response status    405