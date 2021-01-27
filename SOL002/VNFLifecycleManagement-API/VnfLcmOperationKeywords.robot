*** Settings ***
#Resource    environment/configuration.txt
Resource    environment/variables.txt
#Resource    environment/scaleVariables.txt
Library    MockServerLibrary
Library    REST    ${VNFM_SCHEMA}://${VNFM_HOST}:${VNFM_PORT}    ssl_verify=false
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/

*** Keywords ***

Get Vnf Instance 
    [Arguments]    ${vnfInstanceId}
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    ${body}=    Output    response body
    [Return]    ${body}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings   ${response['status']}    ${expected_status}
    Log    Status code validated 

Check Operation Occurrence Id
    ${vnfLcmOpOccId}=    Get Value From Json    ${response['headers']}    $..Location
    Should Not Be Empty    ${vnfLcmOpOccId}

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Check resource Instantiated
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    200
    Check VNF Status    ${response['body']['instantiationState']}    INSTANTIATED

Check resource not Instantiated
    Check VNF Instance    ${vnfInstanceId}
    Check HTTP Response Status Code Is    200
    Check VNF Status    ${response['body']['instantiationState']}    NOT_INSTANTIATED

Check VNF Instance
    [Arguments]    ${vnfId}
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${response}=    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfId}

Check VNF Status
    [Arguments]    ${current}    ${expected}
    Should Be Equal As Strings    ${current}    ${expected}
    Log    VNF Status in the correct status

Check operation resource state is FAILED_TEMP
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body instantiationState    FAILED_TEMP   

Check operation resource state is FINALLY_FAILED      
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId} 
    String    response body instantiationState    FINALLY_FAILED  
     
Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present

POST Create a new vnfInstance	
     Log    Create VNF instance by POST to ${apiRoot}/${apiName}/${apiVersion}/vnf_instances
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/createVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	

GET multiple vnfInstances	
     Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 		

GET multiple vnfInstances with bad attribute	
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?attribute_not_exist=some_value
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	

GET multiple vnfInstances with bad filter	
    Log    Query VNF The GET method queries information about multiple VNF instances.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?fields=wrong_field
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	
GET multiple vnfInstances with all_fields attribute selector
    Log    Query status information about multiple VNF instances, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET multiple vnfInstances with exclude_default attribute selector
    Log    Query status information about multiple VNF instances using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
GET multiple vnfInstances with fields attribute selector
    Log    Query status information about multiple VNF instances, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
GET multiple vnfInstances with exclude_fields attribute selector
    Log    Query status information about multiple VNF instances, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 	
PUT multiple vnfInstances
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances   	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PATCH multiple vnfInstances
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfLcmOpOccId}	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
DELETE multiple vnfInstances
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfLcmOpOccId} 	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}   

POST individual vnfInstance
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}        

GET individual vnfInstance
    log    Trying to get information about an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId} 		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}      
	
PUT individual vnfInstance
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}	  	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
	
PATCH individual vnfInstance
    log    Trying to modify an individual VNF instance
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE_PATCH}"}
    Set Headers    {"If-Match": "${original_etag}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/patchBodyRequest.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}    ${body}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
DELETE individual vnfInstance
    log    Trying to delete an individual VNF instance
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 

POST instantiate individual vnfInstance	
    Log    Trying to Instantiate a vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/instantiateVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate    ${body}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	
	
GET instantiate individual vnfInstance
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 

PUT instantiate individual vnfInstance
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 

PATCH instantiate individual vnfInstance
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 

DELETE instantiate individual vnfInstance
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/instantiate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	
	
POST Scale vnfInstance
    [Arguments]    ${vnf_state}
    [Documentation]    ${vnf_state} differentiate the VNF ID to be used in the different POST requests
    ...    ${vnf_state} == 0 -> VNF in instantiated state
    ...    ${vnf_state} == 1 -> VNF in not_instantiated state
    ...    ${vnf_state} == 2 -> VNF ID not stored
    ...     
    Log    Trying to Instantiate a vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Run Keyword If    ${vnf_state} == 0    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${instantiatedVnfInstanceId}/scale    ${body}
    Run Keyword If    ${vnf_state} == 1    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${notInstantiatedVnfInstanceId}/scale    ${body}
    Run Keyword If    ${vnf_state} == 2    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${NOT_EXISTANT_VNF_INSTANCE_ID}/scale    ${body}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    ${body}
	${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 

GET Scale vnfInstance				
    Log    Trying to get a scale a vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale    
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
PUT Scale vnfInstance				
    Log    Trying to modify a scale vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
PATCH Scale vnfInstance				
    Log    Trying to modify a scale vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	
DELETE Scale vnfInstance				
    Log    Trying to modify a scale vnf Instance
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfRequest.json
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 	

POST Scale vnfInstance to level
    Log    Trying to scale a vnf Instance to level
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/scaleVnfToLevelRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
GET Scale vnfInstance to level
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PUT Scale vnfInstance to level
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PATCH Scale vnfInstance to level
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
	
DELETE Scale vnfInstance to level
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/scale_to_level 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	

POST Change VNF deployment flavour
    Log    Trying to change the deployment flavour of a VNF instance.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/changeVnfFlavourRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_flavour    ${body} 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}  	 
GET Change VNF deployment flavour
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_flavour 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PUT Change VNF deployment flavour
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_flavour 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PATCH Change VNF deployment flavour
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_flavour   	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
DELETE Change VNF deployment flavour
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_flavour   	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
			
POST Terminate VNF
    Log    Trying to terminate a VNF instance.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/terminateVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/terminate    ${body}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

GET Terminate VNF
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/terminate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PUT Terminate VNF
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/terminate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PATCH Terminate VNF
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/terminate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
	
DELETE Terminate VNF
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/terminate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	

POST Heal VNF
    Log    Trying to heal a VNF instance.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/healVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/heal    ${body}		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	

GET Heal VNF
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/heal  
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PUT Heal VNF
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/heal 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PATCH Heal VNF
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/heal 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
	
DELETE Heal VNF
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/heal 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}			

POST Change External VNF Connectivity
    Log    Trying to change the external connectivity of a VNF instance.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/changeExtVnfConnectivityRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}  

GET Change External VNF Connectivity
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PUT Change External VNF Connectivity
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn  		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PATCH Change External VNF Connectivity
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
DELETE Change External VNF Connectivity
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/change_ext_conn  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse} 
	
POST Operate VNF
    Log    Trying to operate a VNF instance.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/operateVnfRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/operate    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	

GET Operate VNF
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/operate  
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PUT Operate VNF
    log    Trying to perform a PUT. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/operate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

PATCH Operate VNF
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/operate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
	
DELETE Operate VNF
    log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_instances/${vnfInstanceId}/operate 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		

Post VNF LCM OP occurrences
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs  	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
GET VNF LCM OP occurrences
    Log    Query status information about multiple VNF lifecycle management operation occurrences.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
GET VNF LCM OP occurrences invalid attribute
    Log    Query status information about multiple VNF lifecycle management operation occurrences.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs?attribute_not_exist=some_value	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
GET VNF LCM OP occurrences invalid filter
    Log    Query status information about multiple VNF lifecycle management operation occurrences.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"} 
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs?fields=wrong_field	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
PUT VNF LCM OP occurrences	
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
PATCH VNF LCM OP occurrences	
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}			
DELETE VNF LCM OP occurrences	
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Post Individual VNF LCM OP occurrences
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	

Post Retry operation
    Log    Retry a VNF lifecycle operation if that operation has experienced a temporary failure
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	    
Get Retry operation	
    Log    Trying to perform a GET. This method should not be implemented.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Put Retry operation	
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Patch Retry operation	
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Delete Retry operation    
	log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/retry	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Post Rollback operation
    Log    Rollback a VNF lifecycle operation if that operation has experienced a temporary failure
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/rollback
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	    
Get Rollback operation	
    Log    Trying to perform a GET. This method should not be implemented.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/rollback	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Put Rollback operation	
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/rollback	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Patch Rollback operation	
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/rollback	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Delete Rollback operation    
	log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/rollback	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Post Fail operation
    Log    mark as Failed a VNF lifecycle operation if that operation has experienced a temporary failure
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	    
Get Fail operation	
    Log    Trying to perform a GET. This method should not be implemented.
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Put Fail operation	
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Patch Fail operation	
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Delete Fail operation    
	log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/fail
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	

POST Cancel operation task
    Log    Cancel an ongoing VNF lifecycle operation
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Cancel a VNF lifecycle operation
    Post    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/cancel    ${CancelMode}
    Log    Validate Status code
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
    
GET Cancel operation task
    log    Trying to perform a GET. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/cancel 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PUT Cancel operation task
    log    Trying to perform a PUT. This method should not be implemented 
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/cancel  		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
PATCH Cancel operation task
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Patch    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/cancel  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
	
DELETE Cancel operation task
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs/${vnfLcmOpOccId}/cancel  	 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}        

Post Create subscription
    Log    Create subscription instance by POST to ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    ${body}=    Get File    jsons/lccnSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}				
Post Create subscription - DUPLICATION
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${VNFM_DUPLICATION} == 0    VNFM is not permitting duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/lccnSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}		
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}			
Post Create subscription - NO-DUPLICATION	
    Log    Trying to create a subscription with an already created content
    Pass Execution If    ${VNFM_DUPLICATION} == 1    VNFM permits duplication. Skipping the test
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=    Get File    jsons/lccnSubscriptionRequest.json
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Get subscriptions
    Log    Get the list of active subscriptions
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Get subscriptions - filter
    Log    Get the list of active subscriptions using a filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Get subscriptions - invalid filter  
    Log    Get the list of active subscriptions using an invalid filter
    Set Headers    {"Accept": "${ACCEPT}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${sub_filter_invalid}   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Get subscriptions with all_fields attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
Get subscriptions with exclude_default attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
Get subscriptions with fields attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
Get subscriptions with exclude_fields attribute selector
    Log    Get the list of active subscriptions, using fields
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}	
PUT subscriptions
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions  	   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
PATCH subscriptions
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions  	   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
DELETE subscriptions
    log    Trying to perform a DELETE. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions  	   
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	
Post Create Individual subscription
    log    Trying to perform a POST. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Get Individual subscription	
    log    Trying to get information about an individual subscription
    Set Headers    {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Put Individual subscription	
    log    Trying to perform a PUT. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}		
Patch Individual subscription	
    log    Trying to perform a PATCH. This method should not be implemented
    Set Headers  {"Accept":"${ACCEPT}"}  
    Set Headers  {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId} 	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}	    
Delete Individual subscription
    log    Try to delete an individual subscription
    Set Headers  {"Accept":"${ACCEPT}"}  
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
Put Notification subscription
    log    Trying to perform a PUT. This method should not be implemented
    Put    ${callback_endpoint}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
Patch Notification subscription
    log    Trying to perform a PATCH. This method should not be implemented
    Patch    ${callback_endpoint}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
Delete Notification subscription
    log    Trying to perform a DELETE. This method should not be implemented
    Delete    ${callback_endpoint}	
    ${outputResponse}=    Output    response
	Set Global Variable    ${response}    ${outputResponse}
POST Operation occurrence
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/NsLcmOperationOccurrenceNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle NSLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 
POST Id creation
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/vnfIdentifierCreationNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle vnfLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}
POST Id deletion
    log    The POST method delivers a notification from the server to the client.
    ${json}=	Get File	schemas/vnfIdentifierCreationNotification.schema.json
    ${BODY}=	evaluate	json.loads('''${json}''')	json
    Log  Creating mock request and response to handle vnfLcmOperationOccurrenceNotification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${BODY}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint}    
GET test endpoint
    log    The GET method allows the server to test the notification endpoint
    &{req}=  Create Mock Request Matcher	GET  ${callback_endpoint}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Sleep  ${sleep_interval}
    Verify Mock Expectation  ${req}
    Clear Requests  ${callback_endpoint}   
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}

Check Subscription resource exist
    Set Headers    {"Accept":"${ACCEPT}"}  
    Set Headers    {"Content-Type": "${CONTENT_TYPE}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization":"${AUTHORIZATION}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    Integer    response status    200

Get VNF LCM Operation occurrences with all_fields attribute selector
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Get VNF LCM Operation occurrences with exclude_default attribute selector
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get VNF LCM Operation occurrences with fields attribute selector
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get VNF LCM Operation occurrences with exclude_fields attribute selector
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_lcm_op_occs?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 	
    