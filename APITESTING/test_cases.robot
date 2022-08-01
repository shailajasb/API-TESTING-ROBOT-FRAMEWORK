*** Settings ***
Documentation  API Testing in Robot Framework
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Library SeleniumLibrary

*** Variables ***
${Base_URl}  https://gorest.co.in
${endpoint}  /public/v2/users/24
${userid}   24
${delete_userid}    3553
${create_user_endpoint}  /public/v2/users
${bearerToken}=  "Bearer 0b835b2ef92904c99ed311419f09ddb3bb4373669c586ac900c8200376f4874d"

*** Test Cases ***
TC_001_Verify_Non_Ssl_Get_user_details
   Get User Api non ssl

TC_002_Get_user_details_verify_status_code
   Verify status code Get User Api

TC_003_Create_New_User_Api
   Create New user Api

TC_004_Validate_Response_Has_Valid_Json_data
    Verify Response has valid Json Data

TC_005_Verify_Response_Has_Email_Adress
    Verify Response has Email

TC_006_Fetch_user_details_by_user_id
    Get User Details by user id

TC_007_Delete_User_by_id
    Delete user by id


***keywords***
Get User Api non ssl
    Create session  mysession  ${Base_URl}  verify=False
    ${response}=  GET On Session  mysession  ${endpoint}
    Status Should Be  200  ${response}
    log  to console ${response.status_code}


Verify status code Get User Api
    Create session  mysession  ${Base_URl}
    ${response}=  GET On Session  mysession  ${endpoint}
    log  to console ${response.status_code}
    Status Should Be  200  ${response}

Create New user Api
    Create session  mysession  ${Base_URl}
    ${body}=  Create Dictionary  firstname=test34 gender=female status=active  email=test19@gmail.com
    ${headers}=  Create Dictionary  Authorization=${bearertoken}
    ${response}=    POST On Session  /public/v2/users    data=${body}  headers=${headers}
    log  to console ${response.status_code}
    #VALIDATIONS
    ${status_code}=  convert to string  ${response.status_code}
    should be equal  ${status_code}  201

Verify Response has valid Json Data
    Create session  mysession  ${Base_URl}
    ${get_response}=  GET On Session  mysession  ${endpoint}
    log  to console ${get_response}
    ${json_response}=       set variable    ${get_response.json()}
    log to console  ${json_response}
   @{email_adress}=     get value from json     ${json_response}    email
   log to console   @{email_adress}
   log to console       @{email_adress}     gandhi_trilok@mayer.net
   ${id}=      get value from json     ${json_response}    id
   ${idFromList}=        Get From List  ${id}   0
   ${idFromListAsString}=       Convert To String   ${idFromList}
   log to console       ${id}
   Should be equal As Strings       ${idFromListAsString}       24
   @{name}=     get value from json     ${json_response}    name
   ${nameFromList}=        Get From List  ${name}   0
   log to console   @{name}
    Should be equal As Strings       ${nameFromList}       Rohana Gill

Verify Response has Email
    Create session  mysession  ${Base_URl}
    ${get_response}=  GET On Session  mysession  ${endpoint}
    log  to console ${get_response}
    ${json_response}=       set variable    ${get_response.json()}
    log to console  ${json_response}
    @{email_adress}=     get value from json     ${json_response}    email
    log to console   @{email_adress}
    Should Contain   ${json_response}    email

Get User Details by user id
    Create session  mysession  ${Base_URl}
    ${get_response}=  GET On Session  mysession  /public/v2/users/${userid}
    log  to console ${get_response}
    log  to console ${get_response.status_code}
    ${json_response}=       set variable    ${get_response.json()}
    log to console  ${json_response}
    ${id}=      get value from json     ${json_response}    id
   ${idFromList}=        Get From List  ${id}   0
   ${idFromListAsString}=       Convert To String   ${idFromList}
   log to console       ${id}
   Should be equal As Strings       ${idFromListAsString}       ${userid}

Delete user by id
    Create session  mysession  ${Base_URl}
    ${headers}=  Create Dictionary  Authorization=${bearertoken}
    ${get_response}=  DELETE On Session  mysession  /public/v2/users/${delete_userid}   headers=${headers}
    Status Should Be  204  ${response}
    log  to console ${response.status_code}


