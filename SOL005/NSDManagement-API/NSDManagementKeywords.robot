*** Settings ***
Resource    environment/variables.txt
Resource    environment/subscriptions.txt
Resource    environment/nsDescriptors.txt    # Specific nsDescriptors Parameters
Resource    environment/pnfDescriptors.txt    # Specific pnfDescriptors Parameters
Resource    environment/individualSubscription.txt
Library    REST    ${NFVO_SCHEMA}://${NFVO_HOST}:${NFVO_PORT}    ssl_verify=false
Library    MockServerLibrary 
Library    OperatingSystem
Library    BuiltIn
Library    JSONLibrary
Library    Collections
Library    JSONSchemaLibrary    schemas/
Library    Process

*** Keywords ***
GET all Network Service Descriptors Information
    Log    The GET method queries multiple NS descriptors
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET Network Service Descriptors Information with attribute-based filter
    Log    The GET method queries multiple NS descriptors using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Check HTTP Response Body NsdInfos Matches the requested attribute-based filter
    Log    Checking that attribute-based filter is matched
    #todo

GET Network Service Descriptors Information with invalid attribute-based filter
    Log    The GET method queries multiple NS descriptors using Attribute-based filtering parameters. Negative case, with erroneous attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all Network Service Descriptors Information with malformed authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as NFVO is not supporting authentication
    Log    The GET method queries using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${BAD_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all Network Service Descriptors Information without authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as it is not supporting authentication
    Log    The GET method queries omitting token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get all Network Service Descriptors Information with expired or revoked authorization token
    Pass Execution If    ${AUTH_USAGE} == 0    Skipping test as it is not supporting authentication
    Log    The GET method queries  using invalid token
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Authorization": "${NEG_AUTHORIZATION}"}
    Log    Execute Query and validate response
    Get    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET all Network Service Descriptors Information with all_fields attribute selector
    Log    The GET method queries multiple NS descriptors using Attribute-based filtering parameters "all_fields"
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body NsdInfos Matches the requested all_fields selector
    Log    Validating user defined data schema
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

GET all Network Service Descriptors Information with exclude_default attribute selector
    Log    Trying to get all NSDs present in the NFVO Catalogue, using exclude_default filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body NsdInfos Matches the requested exclude_default selector
    Log    Checking that element is missing
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Should Be Empty    ${user}
    Log    Reports element is empty as expected


GET all Network Service Descriptors Information with fields attribute selector
    Log    Trying to get all NSDs present in the NFVO Catalogue, using fields filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body NsdInfos Matches the requested fields selector
    Log    Validating user defined data schema
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

GET all Network Service Descriptors Information with exclude_fields attribute selector
    Log    Trying to get all NSD Managements present in the NFVO Catalogue, using filter params
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use exclude_fields option
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body NsdInfos Matches the requested exclude_fields selector
    Log    Checking that element is missing
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Should Be Empty    ${user}
    Log    Reports element is empty as expected   

Send Post Request to create new Network Service Descriptor Resource
    Log    Creating a new network service descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/createNsdInfoRequest.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition NsdInfo Exists
    Log    Checking that nsd info exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdInfo

Send PUT Request for all Network Service Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for all Network Service Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all Network Service Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Network Service Descriptors Exist
    Log    Checking that Pm Job still exists
    GET all Network Service Descriptors Information

GET Individual Network Service Descriptor Information
    Log    The GET method reads information about an individual NS descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body NsdInfo Identifier matches the requested Network Service Descriptor Information
    Log    Going to validate info retrieved
    Should Be Equal    ${response['body']['id']}    ${nsdInfoId} 
    Log    NSD identifier as expected

GET Individual Network Service Descriptor Information with invalid resource identifier
    Log    Trying to perform a GET on an erroneous nsDescriptorInfoId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${erroneous_nsdInfoId}
    Integer    response status    404
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable    ${usageState}    ${response['body']['nsdUsageState']}

Send PATCH to disable Individual Network Service Descriptor
    Log    Trying to perform a PATCH. As prerequisite the nsdInfo shall be in enabled operational state
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set Headers    {"If-Match": "${original_etag[0]}"}
    ${body}=    Get File    jsons/NsdInfoModificationDisable.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Network Service Descriptor is in operational state
    [Arguments]    ${status}
    Log    Checking postcondition op status
    Should Be Equal As Strings   ${response['body']['nsdOperationalState']}    ${status} 

Check Postcondition Network Service Descriptor usage state is unmodified (Implicit)
    Log    Checking postcondition use status
    Should Be Equal As Strings   ${response['body']['nsdUsageState']}    ${usageState} 

Send PATCH to enable Individual Network Service Descriptor
    Log    Trying to perform a PATCH. As prerequisite the nsdInfo shall be in disabled operational state
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set Headers    {"If-Match": "${original_etag[0]}"}
    ${body}=    Get File    jsons/NsdInfoModificationEnable.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PATCH to enable Individual Network Service Descriptor in onboarding state different from ONBOARDED
    Log    Trying to patch a NSD present in the NFVO Catalogue, but not in ONBOARDED operationalStatus
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set Headers    {"If-Match": "${original_etag[0]}"}
    ${body}=    Get File    jsons/NsdInfoModificationEnable.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${notOnboardedNsdInfoId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

 Send PATCH to enable Individual Network Service Descriptor with HTTP Etag precondition failure
    Log    Trying to perform a PATCH. As prerequisite the nsdInfo shall be modified by another entity
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set Headers    {"If-Match": "${wrong_etag[0]}"}
    ${body}=    Get File    jsons/NsdInfoModificationEnable.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for Individual Network Service Descriptor
    Log    Trying to perform a DELETE nsdInfo. The nsdInfo should be in "NOT_USED" usageState and in "DISABLED" operationalState.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${disabledNsdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Network Service Descriptor is Deleted
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${disabledNsdInfoId}
    Integer    response status    404

Send DELETE Request for Individual Network Service Descriptor in operational state ENABLED
    Log    Trying to perform a DELETE nsdInfo in ENABLED operational state
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition Network Service Descriptor Exists
    GET Individual Network Service Descriptor Information

Send POST Request for Individual Network Service Descriptor
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for Individual Network Service Descriptor
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Header Content-Type Is
    [Arguments]   ${header}
    Should Contain    ${response['headers']['Content-Type']}    ${header}

Check HTTP Response Header Content-Type Is Any of
    [Arguments]   ${header1}    ${header2}
    Should Contain Any  ${response['headers']['Content-Type']}    ${header1}    ${header2}

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

Get single file NSD Content in Plain Format
    Log    Trying to get a NSD present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdPlain}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get NSD Content in Zip Format
    Log    Trying to get a NSD present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get single file NSD Content in Plain or Zip Format
    Log    Trying to get a NSD present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdPlain}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get multi file NSD Content in Plain or Zip Format
    Log    Trying to get a VNFD from a given NSD Management present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get multi file NSD Content in Plain Format
    Log    Trying to get a negative case performing a get on a NSD present in the NFVO Catalogue. Accept will be text/plain but NSD is composed my multiple files.
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get NSD Content with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${erroneous_nsdInfoId}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get NSD Content with conflict due to onboarding state
    Log    Trying to get a VNFD from a given NSD Management present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${notOnboardedNsdInfoId}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

GET NSD Content with Range Request
    Log    Trying to get a NSD Content using RANGE using an NFVO that can handle it
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${range}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET NSD Content with invalid Range Request
    Log    Trying to get a range of bytes of the limit of the NSD
    Pass Execution If    ${NFVO_RANGE_OK} == 0    Skipping this test as NFVO is not able to handle partial Requests.
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Set Headers    {"Range": "${erroneousRange}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request to upload NSD Content as zip file in asynchronous mode
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get File  ${contentZipFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content    ${body}
    ${response}=    Output    response body
    Should Be Empty    ${response}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request to upload NSD Content as plain text file in asynchronous mode
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get File  ${contentPlainFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdPlain}/nsd_content    ${body}
    ${response}=    Output    response body
    Should Be Empty    ${response}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request to upload NSD Content as zip file in synchronous mode
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get File  ${contentZipFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content    ${body}
    ${response}=    Output    response body
    Should Be Empty    ${response} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request to upload NSD Content as plain text file in synchronous mode
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get File  ${contentPlainFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdPlain}/nsd_content    ${body}
    ${response}=    Output    response body
    Should Be Empty    ${response}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition NSD Content is uploaded and available in the NFVO
    Get single file NSD Content in Plain or Zip Format
    Check HTTP Response Status Code Is    200
 
Send PUT Request to upload NSD Content with conflict due to onboarding state
    Log    Trying to perform a PUT. This method upload the content of a NSD
    Set Headers    {"Accept": "${ACCEPT_ZIP}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentZipFile}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${creatingNsdInfoId}/nsd_content    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send POST Request for NSD Content
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a POST. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PATCH Request for NSD Content
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send DELETE Request for NSD Content
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors/${nsdInfoIdZip}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition NSD Content Exists
    Get NSD Content in Zip Format

GET all PNF Descriptors Information
    Log    The GET method queries multiple PNF descriptors
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET PNF Descriptors Information with attribute-based filter
    Log    The GET method queries multiple PNF descriptors using Attribute-based filtering parameters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?${POS_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Check HTTP Response Body PnfdInfos Matches the requested attribute-based filter
    Log    Checking that attribute-based filter is matched
    #todo

GET PNF Descriptors Information with invalid attribute-based filter
    Log    The GET method queries multiple PNF descriptors using Attribute-based filtering parameters. Negative case, with erroneous attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?${NEG_FIELDS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

GET all PNF Descriptors Information with all_fields attribute selector
    Log    The GET method queries multiple PNF descriptors using Attribute-based filtering parameters "all_fields"
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?all_fields
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body PnfdInfos Matches the requested all_fields selector
    Log    Validating user defined data schema
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

GET all PNF Descriptors Information with exclude_default attribute selector
    Log    Trying to get all PNFDs present in the NFVO Catalogue, using exclude_default filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?exclude_default
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body PnfdInfos Matches the requested exclude_default selector
    Log    Checking that element is missing
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Should Be Empty    ${user}
    Log    Reports element is empty as expected


GET all PNF Descriptors Information with fields attribute selector
    Log    Trying to get all PNFDs present in the NFVO Catalogue, using fields filter.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body PnfdInfos Matches the requested fields selector
    Log    Validating user defined data schema
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Validate Json    UserDefinedData.schema.json    ${user[0]}
    Log    Validation for schema OK

GET all PNF Descriptors Information with exclude_fields attribute selector
    Log    Trying to get all PNF present in the NFVO Catalogue, using filter params
    Pass Execution If    ${NFVO_FIELDS} == 0    The NFVO is not able to use exclude_fields option
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors?exclude_fields=${fields}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   

Check HTTP Response Body PnfdInfos Matches the requested exclude_fields selector
    Log    Checking that element is missing
    ${user}=    Get Value From Json    ${response['body']}    $..UserDefinedData
    Should Be Empty    ${user}
    Log    Reports element is empty as expected   

Send Post Request to create new PNF Descriptor Resource
    Log    Creating a new network service descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/createPnfdInfoRequest.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition PnfdInfo Exists
    Log    Checking that nsd info exists
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NsdInfo

Send PUT Request for all PNF Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/ns_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send PATCH Request for all PNF Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send DELETE Request for all PNF Descriptors
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition PNF Descriptors Exist
    Log    Checking that PNFD still exists
    GET all PNF Descriptors Information

GET Individual PNF Descriptor Information
    Log    The GET method reads information about an individual PNF descriptor
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Body PnfdInfo Identifier matches the requested PNF Descriptor Information
    Log    Going to validate info retrieved
    Should Be Equal    ${response['body']['id']}    ${pnfdInfoId} 
    Log    PNFD identifier as expected

GET Individual PNF Descriptor Information with invalid resource identifier
    Log    Trying to perform a GET on an erroneous nsDescriptorInfoId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${erroneous_pnfdInfoId}
    Integer    response status    404
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PATCH to update Individual PNF Descriptor
    Log    Trying to perform a PATCH.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set Headers    {"If-Match": "${original_etag[0]}"}
    ${body}=    Get File    jsons/PnfdInfoModification.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Set Suite Variable    ${body["userDefinedData"]}    ${userDefinedDataSet}

Check Postcondition PNF Descriptor is modified according to the requested update
    Log    Checking postcondition op status
    Should Be Equal   ${response['body']['userDefinedData']}    ${userDefinedDataSet} 

Send PATCH to update Individual PNF Descriptor with HTTP Etag precondition failure
    Log    Trying to perform a PATCH. As prerequisite the pnfdInfo shall be modified by another entity
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Set Headers    {"If-Match": "${wrong_etag[0]}"}
    ${body}=    Get File    jsons/PnfdInfoModification.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send DELETE Request for Individual PNF Descriptor
    Log    Trying to perform a DELETE pnfdInfo.
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition PNF Descriptor is Deleted
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}
    Integer    response status    404

Send POST Request for Individual PNF Descriptor
    Log    Trying to perform a POST. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send PUT Request for Individual PNF Descriptor
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get PNFD Content
    Log    Trying to get a NSD present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get PNFD Content with invalid resource identifier
    Log    Trying to perform a negative get, using an erroneous package ID
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${erroneous_pnfdInfoId}/pnfd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Get PNFD Content with conflict due to onboarding state
    Log    Trying to get a PNFD present in the NFVO Catalogue
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${onboardingStatePnfdId}/pnfd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request to upload PNFD Content as plain text file
    Log    Trying to perform a PUT. This method upload the content of a PNFD
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get File  ${contentFilePnfd}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/pnfd_content    ${body}
    ${response}=    Output    response body
    Should Be Empty    ${response}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PUT Request to upload PNFD Content with conflict due to onboarding state
    Log    Trying to perform a PUT. This method upload the content of a PNFD
    Set Headers    {"Accept": "${ACCEPT_PLAIN}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    ${body}=  Get Binary File  ${contentFilePnfd}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${creatingNsdInfoId}/pnfd_content    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send POST Request for PNFD Content
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a POST. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send PATCH Request for PNFD Content
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Send DELETE Request for PNFD Content
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/pnf_descriptors/${pnfdInfoId}/nsd_content
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 

Check Postcondition PNFD Content Exists
    Get PNFD Content
    
Get all NSD Management Subscriptions
    [Documentation]    This method shall support the URI query parameters, request and response data structures, and response codes, as
    ...    specified in the Tables 5.4.8.3.2-1 and 5.4.8.3.2-2.
    Log    Trying to get the list of subscriptions
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get NSD Management Subscriptions with attribute-based filters
    Log    Trying to get the list of subscriptions using filters
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ok}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NSD Management Subscriptions with invalid attribute-based filters
    Log    Trying to get the list of subscriptions using filters with wrong attribute name
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?${filter_ko}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get NSD Management Subscriptions with invalid resource endpoint
    Log    Trying to perform a request on a Uri which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscription
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}    


Send Post Request for NSD Management Subscription
    [Documentation]    This method shall support the URI query parameters, request and response data structures, and response codes, as
    ...    specified in the Tables 5.4.8.3.1-1 and 5.4.8.3.1-2.
    Log    Trying to create a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...    Check Notification Endpoint  


Send Post Request for Duplicated NSD Management Subscription
    Log    Trying to create a subscription with an already created content
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Set Headers    {"Content-Type": "${CONTENT_TYPE_JSON}"}
    ${body}=    Get File    jsons/subscriptions.json
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Run Keyword If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 1
    ...    Check Notification Endpoint  



Send Put Request for NSD Management Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PUT. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send Patch Request for NSD Management Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a PATCH. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete Request for NSD Management Subscriptions
    Pass Execution If    ${testOptionalMethods} == 0    optional methods are not implemented on the FUT. Skipping test.
    Log    Trying to perform a DELETE. This method should not be implemented
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NSD Management Subscriptions Exists
    Log    Checking that subscriptions exists
    Get all NSD Management Subscriptions    

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}    
    Should Be Equal    ${response['status']}    ${expected_status}
    Log    Status code validated 
    
    
    
Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK  


Check HTTP Response Body Is Empty
    Should Be Empty    ${response['body']}    
    Log    No json schema is provided. Validation OK  


Check HTTP Response Body Subscriptions Match the requested Attribute-Based Filter
    Log    Check Response includes NSD Management Management according to filter
    #TODO


Check HTTP Response Body NsdmSubscription Attributes Values Match the Issued Subscription
    Log    Check Response matches subscription
    ${body}=    Get File    jsons/subscriptions.json
    ${subscription}=    evaluate    json.loads('''${body}''')    json
    Should Be Equal    ${response['body']['callbackUri']}    ${subscription['callbackUri']}


Check Postcondition NSD Management Subscription Is Set
    Log    Check Postcondition subscription exist
    Log    Trying to get the subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${response['body']['id']}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    
    
Check Postcondition Subscription Resource Returned in Location Header Is Available
    Log    Going to check postcondition
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${response.headers['Location']}
    Integer    response status    200
    Log    Received a 200 OK as expected
    ${contentType}=    Output    response headers Content-Type
    Should Contain    ${contentType}    application/json
    ${result}=    Output    response body
    Validate Json    NsdmSubscription.schema.json    ${result}
    Log    Validated NsdmSubscription schema
        
Get Individual NSD Management Subscription
    Log    Trying to get a single subscription identified by subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
GET individual NSD Management Subscription with invalid resource identifier
    Log    Trying to perform a request on a subscriptionID which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Delete request for individual NSD Management Subscription
    Log    Trying to perform a DELETE on a subscriptionId
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check Postcondition NSD Management Subscription is Deleted
    Log    Check Postcondition Subscription is deleted
    GET individual NSD Management Subscription
    Check HTTP Response Status Code Is    404 

Send Delete request for individual NSD Management Subscription with invalid resource identifier
    Log    Trying to perform a DELETE on a subscriptionId which doesn't exist
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${erroneousSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Send Post request for individual NSD Management Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}

Send Put request for individual NSD Management Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    
Send Patch request for individual NSD Management Subscription
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": ${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${origOutput}=    Output    response
    Set Suite Variable    ${origResponse}    ${origOutput}
    PATCH    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
   
Check Postcondition NSD Management Subscription is Unmodified (Implicit)
    Log    Check postconidtion subscription not modified
    GET individual NSD Management Subscription
    Log    Check Response matches original VNF Threshold
    ${subscription}=    evaluate    json.loads('''${response['body']}''')    json
    Should Be Equal    ${origResponse['body']['id']}    ${subscription.id}
    Should Be Equal    ${origResponse['body']['callbackUri']}    ${subscription.callbackUri}

Check Postcondition NSD Management Subscription is not Created
    Log    Trying to get a new subscription
    Set Headers    {"Accept": "${ACCEPT_JSON}"}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Headers    {"Authorization": "${AUTHORIZATION}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${newSubscriptionId}
    ${output}=    Output    response
    Set Suite Variable    @{response}    ${output}
    Check HTTP Response Status Code Is    404

Check HTTP Response Body Subscription Identifier matches the requested Subscription
    Log    Trying to check response ID
    Should Be Equal    ${response['body']['id']}    ${subscriptionId} 
    Log    Subscription identifier as expected

Check HTTP Response Header Contains
    [Arguments]    ${CONTENT_TYPE}
    Should Contain    ${response.headers}    ${CONTENT_TYPE}
    Log    Header is present

Check HTTP Response Header Contains Etag
    Should Contain    ${response.headers}    Etag
    Log    Header is present
    Set Suite Variable    &{original_etag}    ${response.headers['Etag']}


Create Sessions
    Pass Execution If    ${NFVO_CHECKS_NOTIF_ENDPOINT} == 0    MockServer not started as NFVO is not checking the notification endpoint
    Start Process  java  -jar  ${MOCK_SERVER_JAR}    -serverPort  ${callback_port}  alias=mockInstance
    Wait For Process  handle=mockInstance  timeout=5s  on_timeout=continue
    Create Mock Session  ${callback_uri}
    
    
Check Notification Endpoint
    &{notification_request}=  Create Mock Request Matcher	GET  ${callback_endpoint}    
    &{notification_response}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${notification_request}  ${notification_response}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${notification_request}
    Clear Requests  ${callback_endpoint}
