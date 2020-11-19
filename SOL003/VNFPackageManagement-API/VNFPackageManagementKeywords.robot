*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    environment/individualSubscription.txt
Resource    environment/vnfPackages.txt
Resource    environment/individualVnfPackage.txt
Resource    environment/vnfPackageContent.txt
Resource    environment/vnfPackageArtifacts.txt
Resource    environment/vnfdInIndividualVnfPackage.txt
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process
Library    String


*** Keywords ***
Get all VNF Packages
    Log    Trying to get all VNF Packages present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body Does Not Contain softwareImages
    Log    Checking that field element is missing
    ${softwareImages}=    Get Value From Json    ${response['body']}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    Element is empty as expected
    
Check HTTP Response Body Does Not Contain additionalArtifacts
    Log    Checking that field element is missing
    ${additionalArtifacts}=    Get Value From Json    ${response['body']}    $..additionalArtifacts
    Should Be Empty    ${additionalArtifacts}
    Log    Element is empty as expected
    
Check HTTP Response Body Does Not Contain userDefinedData 
    Log    Checking that field element is missing
    ${userDefinedData}=    Get Value From Json    ${response['body']}    $..userDefinedData
    Should Be Empty    ${userDefinedData}
    Log    Element is empty as expected

GET VNF Packages with attribute-based filter
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${POS_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body VnfPkgsInfo Matches the requested Attribute-Based Filter
    Log    Checking that attribute-based filter is matched
    @{attr} =    Split String    ${POS_FILTER}       ,${VAR_SEPERATOR} 
    @{var_id} =    Split String    @{attr}[0]       ,${SEPERATOR}
    @{var_provider} =    Split String    @{attr}[1]       ,${SEPERATOR}
    Should Be True     "${response['body'][0]['vnfdId']}"=="@{var_id}[1]" and "${response['body'][0]['vnfProvider']}"=="@{var_provider}[1]"

GET VNF Packages with invalid attribute-based filter
    Log    Trying to perform a negative get, filtering by the inexistent filter 'nfvId'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?${NEG_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET VNF Packages with all_fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Check HTTP Response Body VnfPkgsInfo Matches the requested all_fields selector
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${response['body']}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${response['body']}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK
    ${links}=    Get Value From Json    ${response['body']}    $.._links
    Validate Json    links.schema.json    ${links[0]}
    Log    Validation for _links schema OK

GET VNF Packages with exclude_default attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using exclude_default filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?exclude_default   
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body VnfPkgsInfo Matches the requested exclude_default selector
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${response['body']}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${response['body']}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted

GET VNF Packages with fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body vnfPkgsInfo Matches the requested fields selector
    Log    Trying to validate softwareImages schema
    ${softwareImages}=    Get Value From Json    ${response['body']}    $..softwareImages
    Validate Json    softwareImage.schema.json    ${softwareImages[0]}
    Log    Validation for softwareImage schema OK
    Log    Trying to validate additionalArtifacts schema
    ${additional_artifacts}=    Get Value From Json    ${response['body']}    $..additionalArtifacts
    Validate Json    additionalArtifacts.schema.json    ${additional_artifacts[0]}
    Log    Validation for additionalArtifacts schema OK
    
GET VNF Packages with exclude_fields attribute selector
    Log    Trying to get all VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body vnfPkgsInfo Matches the requested exclude_fields selector
    Log    Checking missing information for softwareImages element
    ${softwareImages}=    Get Value From Json    ${response['body']}    $..softwareImages
    Should Be Empty    ${softwareImages}
    Log    softwareImages element is missing as excepted
    Log    Checking missing information for additionalArtifact element
    ${additional_artifacts}=    Get Value From Json    ${response['body']}    $..additionalArtifacts
    Should Be Empty    ${additional_artifacts}
    Log    additionalArtifact element is missing as excepted

GET all VNF Packages with invalid resource endpoint
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_package
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for all VNF Packages
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for all VNF Packages
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PATCH Request for all VNF Packages
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for all VNF Packages
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Packages Exist
    Log    Checking that Pm Job still exists
    GET all VNF Packages

GET Individual VNF Package
    Log    Trying to get a VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Check HTTP Response Body vnfPkgInfo Identifier matches the requested VNF Package
    Log    Going to validate pacakge info retrieved
    Should Be Equal    ${response['body']['id']}    ${vnfPackageId} 
    Log    Pacakge identifier as expected

GET Individual VNF Package with invalid resource identifier
    Log    Trying to perform a negative get, using wrong authorization bearer
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPackageId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for individual VNF Package
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual VNF Package
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
Send PATCH Request for individual VNF Package
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for individual VNF Package
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Package Exist
    Log    Checking that vnf pacakge still exists
    GET Individual VNF Package
    
GET Individual VNF Package Content  
    Log    Trying to get a VNF Package Content
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Header Content-Type Is
    [Arguments]   ${header}
    Should Contain    ${response['headers']['Content-Type']}    ${header}

GET Individual VNF Package Content with Range Request
    Log    Trying to get a VNF Package Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Header Content-Range Is Present and Matches the requested range
    Log    Check Content-Range HTTP Header
    Should Contain    ${response['headers']}    Content-Range
    Should Be Equal As Strings    ${response['headers']['Content-Range']}    ${range}
    Log    Header Content-Range is present
    
Check HTTP Response Header Content-Length Is Present and Matches the requested range length
    Log    Check Content-Length HTTP Header
    Should Contain    ${response['headers']}    Content-Length
    Should Be Equal As Integers    ${response['headers']['Content-Length']}    ${length}
    Log    Header Content-Length is present

GET Individual VNF Package Content with invalid Range Request
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Individual VNF Package Content with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Content for VNF Package in onboarding state different from ONBOARDED
    Log    Trying to get a VNF Package content present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for individual VNF Package Content
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual VNF Package Content
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
Send PATCH Request for individual VNF Package Content
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for individual VNF Package Content
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Package Content Exist
    Log    Checking that vnf pacakge still exists
    GET Individual VNF Package Content

Get all VNF Package Subscriptions
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get VNF Package Subscriptions with attribute-based filters
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    

Get VNF Package Subscriptions with invalid attribute-based filters
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Get VNF Package Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send Post Request for VNF Package Subscription
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...       Check Notification Endpoint

Send Post Request for Duplicated VNF Package Subscription
    Log    Trying to create a subscription with an already created content
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send Put Request for VNF Package Subscriptions
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send Patch Request for VNF Package Subscriptions
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send Delete Request for VNF Package Subscriptions
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition VNF Package Subscriptions Exists
    Log    Checking that subscriptions exists
    Get all VNF Package Subscriptions    

Get single file VNFD in Individual VNF Package in Plain Format
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get VNFD in Individual VNF Package in Zip Format
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get single file VNFD in Individual VNF Package in Plain or Zip Format
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgPlainVNFD}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get multi file VNFD in Individual VNF Package in Plain or Zip Format
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check HTTP Response Header Content-Type Is Any of
    [Arguments]   ${header1}    ${header2}
    Should Contain Any  ${response['headers']['Content-Type']}    ${header1}    ${header2}

Get multi file VNFD in Individual VNF Package in Plain Format
    Log    Trying to get a negative case performing a get on a VNFD from a given VNF Package present in the NFVO Catalogue. Accept will be text/plain but VNFD is composed my multiple files.
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get VNFD in Individual VNF Package with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get VNFD in Individual VNF Package Content with conflict due to onboarding state 
    Log    Trying to get a VNFD from a given VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send POST Request for VNFD in individual VNF Package
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request for VNFD in individual VNF Package
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Send PATCH Request for VNFD in individual VNF Package
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send DELETE Request for VNFD in individual VNF Package
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition VNFD Exist
    Log    Checking that vnf pacakge still exists
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPkgZipVNFD}/vnfd
    Check HTTP Response Status Code Is    200

GET Individual VNF Package Artifact
    Log    Trying to get a VNF Package Artifact
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Individual VNF Package Artifact in octet stream format  
    Log    Trying to get a VNF Package Artifact
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageOctetStreamId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Individual VNF Package Artifact with Range Request
    Log    Trying to get an Artifact using RANGE Header and using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual VNF Package Artifact with invalid Range Request
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
GET Individual VNF Package Artifact with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${erroneousVnfPkgId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Artifact for VNF Package in onboarding state different from ONBOARDED
    Log    Trying to get a VNF Package artifact present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${onboardingStateVnfPkgId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for individual VNF Package Artifact
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual VNF Package Artifact
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
Send PATCH Request for individual VNF Package Artifact
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for individual VNF Package Artifact
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Package Artifact Exist
    Log    Checking that vnf pacakge still exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/vnf_packages/${vnfPackageId}/artifacts/${artifactPath}
    Check HTTP Response Status Code Is    200
    
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal As Strings   ${response['status']}    ${expected_status}
    Log    Status code validated 
    

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK  


Check HTTP Response Body Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  


Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes VNF Package Management according to filter
    @{words} =  Split String    ${filter_ok}       ,${SEPERATOR} 
    Should Be Equal As Strings    ${response['body'][0]['callbackUri']}    @{words}[1]

Check HTTP Response Body PkgmSubscription Attributes Values Match the Issued Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}


Check Postcondition VNF Package Subscription Is Set
    [Arguments]    ${location}=""
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    Run Keyword If    ${location} == Location
    ...    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    Run Keyword If    ${location} == Location
    ...    GET    ${response['headers']['Location']}  
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200

Check Postcondition Subscription Resource Returned in Location Header Is Available
    Log    Going to check postcondition
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${response['headers']['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    PkgmSubscription.schema.json    ${result}
    Log    Validated PkgmSubscription schema
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${result['callbackUri']}    ${subscription['callbackUri']}
    Log    Validated Issued subscription is same as original

Get Individual VNF Package Subscription
    Log    Trying to get a single subscription identified by subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET individual VNF Package Subscription with invalid resource identifier
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual VNF Package Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition VNF Package Subscription is Deleted
    Log    Check Postcondition Subscription is deleted
    GET individual VNF Package Subscription
    Check HTTP Response Status Code Is    404 

Send Delete request for individual VNF Package Subscription with invalid resource identifier
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual VNF Package Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Put request for individual VNF Package Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send Patch request for individual VNF Package Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Check Postcondition VNF Package Subscription is Unmodified (Implicit)
    Log    Check postconidtion subscription not modified
    GET individual VNF Package Subscription
    Log    Check Response matches original VNF Threshold
    ${subscription}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origResponse['body']['id']}    ${subscription.id}
    Should Be Equal    ${origResponse['body']['callbackUri']}    ${subscription.callbackUri}

Check Postcondition VNF Package Subscription is not Created
    Log    Trying to get a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response['headers']}    ${CONTENT_TYPE}
    Log    Header is present

Check HTTP Response Body Subscription Identifier matches the requested Subscription
    Log    Trying to check response ID
    Should Be Equal    ${response['body']['id']}    ${subscriptionId} 
    Log    Subscription identifier as expected

Create Sessions
    Pass Execution If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 0    MockServer not started as NFVO is not checking the notification endpoint
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}:${callback_port}
    
    
Check Notification Endpoint
    &{notification_request}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${notification_request}
    Clear Requests  ${callback_endpoint}
    
Check LINK in Header
    ${linkURL}=    Get Value From Json    ${response['headers']}    $..Link
    Should Not Be Empty    ${linkURL}

Get all OnBoarded VNF Packages
    Log    Trying to get all OnBoarded VNF Packages present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
GET OnBoarded VNF Packages with attribute-based filter
    Log    Trying to get all OnBoarded VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages?${POS_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET OnBoarded VNF Packages with invalid attribute-based filter
    Log    Trying to perform a negative get, filtering by the inexistent filter 'nfvId'
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages?${NEG_FILTER}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET OnBoarded VNF Packages with all_fields attribute selector
    Log    Trying to get all OnBoarded VNF Packages present in the NFVO Catalogue, using filter params
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET OnBoarded VNF Packages with exclude_default attribute selector
    Log    Trying to get all OnBoarded VNF Packages present in the NFVO Catalogue, using exclude_default filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages?exclude_default   
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET OnBoarded VNF Packages with fields attribute selector
    Log    Trying to get all OnBoarded VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET OnBoarded VNF Packages with exclude_fields attribute selector
    Log    Trying to get all OnBoarded VNF Packages present in the NFVO Catalogue, using fields
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use fields parameter
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET OnBoarded all VNF Packages with invalid resource endpoint
    Log    Trying to perform a GET on a erroneous URI
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_package
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send OnBoarded POST Request for all VNF Packages
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send OnBoarded PUT Request for all VNF Packages
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send OnBoarded PATCH Request for all VNF Packages
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send OnBoarded DELETE Request for all VNF Packages
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package
    Log    Trying to get a OnBoarded VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package with invalid resource identifier
    Log    Trying to perform a negative get, using wrong authorization bearer
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${erroneousVnfdId} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send POST Request for individual OnBoarded VNF Package
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual OnBoarded VNF Package
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
Send PATCH Request for individual OnBoarded VNF Package
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for individual OnBoarded VNF Package
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get single file VNFD in Individual OnBoarded VNF Package in Plain Format
    Log    Trying to get a VNFD from a given OnBoarded VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get VNFD in Individual OnBoarded VNF Package in Zip Format
    Log    Trying to get a VNFD from a given OnBoarded VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get single file VNFD in Individual OnBoarded VNF Package in Plain or Zip Format
    Log    Trying to get a VNFD from a given OnBoarded VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get multi file VNFD in Individual OnBoarded VNF Package in Plain or Zip Format
    Log    Trying to get a VNFD from a given OnBoarded VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get multi file VNFD in Individual OnBoarded VNF Package in Plain Format
    Log    Trying to get a negative case performing a get on a VNFD from a given VNF Package present in the NFVO Catalogue. Accept will be text/plain but VNFD is composed my multiple files.
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndIdZipVnfd}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Get VNFD in Individual OnBoarded VNF Package with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${erroneousVnfdId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Get VNFD in Individual OnBoarded VNF Package Content with conflict due to onboarding state 
    Log    Trying to get a VNFD from a given OnBoarded VNF Package present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${onboardingStateVnfdId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send POST Request for VNFD in individual OnBoarded VNF Package
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request for VNFD in individual OnBoarded VNF Package
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Send PATCH Request for VNFD in individual OnBoarded VNF Package
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send DELETE Request for VNFD in individual OnBoarded VNF Package
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndIdZipVnfd}/vnfd
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
GET Individual OnBoarded VNF Package Content  
    Log    Trying to get a VNF Package Content
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package Content with Range Request
    Log    Trying to get a VNF Package Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package Content with invalid Range Request
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package Content with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${erroneousVnfdId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Content for OnBoarded VNF Package in onboarding state different from ONBOARDED
    Log    Trying to get a VNF Package content present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${onboardingStateVnfdId}/package_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package Artifact
    Log    Trying to get a VNF Package Artifact
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package Artifact in octet stream format  
    Log    Trying to get a VNF Package Artifact
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vnfdOctetStreamId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Individual OnBoarded VNF Package Artifact with Range Request
    Log    Trying to get an Artifact using RANGE Header and using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET Individual OnBoarded VNF Package Artifact with invalid Range Request
    Log    Trying to get a range of bytes of the limit of the VNF Package
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
GET Individual OnBoarded VNF Package Artifact with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${erroneousVnfdId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Artifact for OnBoarded VNF Package in onboarding state different from ONBOARDED
    Log    Trying to get a VNF Package artifact present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${onboardingStateVnfdId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send POST Request for individual OnBoarded VNF Package Artifact
    Log    Trying to perform a POST (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for individual OnBoarded VNF Package Artifact
    Log    Trying to perform a PUT (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
 
Send PATCH Request for individual OnBoarded VNF Package Artifact
    Log    Trying to perform a PATCH (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for individual OnBoarded VNF Package Artifact
    Log    Trying to perform a DELETE (method should not be implemented)
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition OnBoarded VNF Package Artifact Exist
    Log    Checking that vnf pacakge still exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/onboarded_vnf_packages/${vndId}/artifacts/${artifactPath}
    Check HTTP Response Status Code Is    200
