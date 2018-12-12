*** Settings ***
Library           HttpLibrary.HTTP
Resource          ../variables.txt
Library           JSONSchemaLibrary    schemas/

VNFD of an individual VNF package
    Log    Request that will generate a 409 Error. As prerequisite is needed a VNF Package in PROCESSING onboardingState
    Create HTTP Context    ${NFVO_HOST}:${NFVO_PORT}    ${NFVO_SCHEMA}
    Run Keyword If    ${AUTH_USAGE} == 1    Set Request Header    Authorization    ${AUTHORIZATION}
    Set Request Header    Accept    ${ACCEPT_PLAIN}
    Set Request Header    Accept    ${ACCEPT_ZIP}
    GET    ${apiRoot}/vnfpkgm/v1/vnf_packages/${vnfPkgId_processing}/vnfd
    Response Status Code Should Equal    409
    Log    Received 409 Conflict