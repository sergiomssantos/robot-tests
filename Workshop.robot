*** Settings ***
Library           OperatingSystem
Library           SeleniumLibrary
Resource          my_resource.resource
Library           String
#Library           MyLibrary.py
#Library           LoginLibrary.py
Library           Collections

*** Variables ***
${MESSAGE}        Hello, world!
${URL}    www.saucedemo.com
${USER}    standard_user
${PASSWD}       secret_sauce

*** Test Cases ***
My first test
    [Tags]    first
    Should Be Equal    ${MESSAGE}    Hello, world

My 2nd test
    Log    ${MESSAGE}
    Log    ${CURDIR}
    My keyword    ${CURDIR}

Valid Login
    Open Login Page
    Input Username    ${USER}
    Input Passwd    ${PASSWD}
    Submit Credentials
    Welcome Page Should Be Open
    [Teardown]    Close Browser

Invalid Login
    Open Login Page
    Input Username    ${USER}
    Input Passwd    wrong_pass
    Submit Credentials
    Login Not Successful
    Several Args Keyword
    [Teardown]    Close Browser

Variables
    ${my_var}    Set Variable    123
    ${name}    Set Variable    Jose
    ${var}=    Set Variable    ${name}${my_var}
    Log    ${CURDIR}
    ${name1}=    Several Args Keyword    Jose    Pedro
    ${name2}=    Several Args Keyword    Jose
    Several Args As List Keyword    Jose    Pedro    Marta
    my_resource_keyword

String
    ${my_string}=    Set Variable    Hello World!
    @{words}=    Split String    ${my_string}    ${SPACE}
    Log Many    @{words}
    ${substring}=    Get Substring    ${my_string}    1    5
    ${str}=    Fetch From Left    ${my_string}    ${SPACE}
    ${str2}=    Fetch From Right    ${my_string}    ${SPACE}

If Statement 1
    ${var}=    Set Variable    11
    Run Keyword If    ${var} == 0    Log    Enters in the if statement since value is '${var}'
    ...    ELSE IF    0 < ${var} < 10    Log    Enters in the ElseIf statement since value is '${var}'
    ...    ELSE    Log    Enters in the Else statement since value is '${var}'

If Statement 2
    ${var}=    Set Variable    -1
    Run Keyword If    ${var} == 0    Log    Enters in the 1st if statement since value is '${var}'
    Run Keyword If    0 < ${var} < 10    Log    Enters in the 2nd if statement since value is '${var}'
    Run Keyword Unless    0 <= ${var} < 10    Log    Enters in the Unless statement since value is '${var}'

If Statement 3
    ${var}=    Set Variable    mary
    Run Keyword If    '${var}' == 'john'    Log    Its ${var}
    Run Keyword Unless    '${var}' == 'john'    Log    Its not John but ${var}

If Statement 4
    ${passed}=    Run Keyword And Return Status    Should Contain    ${MESSAGE}    Hello2
    Run Keyword If    ${passed}    Log    Passed!
    Comment    Run Keyword If    '${status}' == 'False'    Log    Failed! (If)
    Run Keyword Unless    ${passed}    Log    Failed! (Unless)

Normal For Loop
    FOR    ${animal}    IN    cat    dog
        Log    ${animal}
        Log    2nd keyword
    END
    Log    Outside Loop 1
    Comment    For using List variable
    @{list}=    Create List    cat    dog
    FOR    ${animal}    IN    @{list}
        Log    ${animal}
        Log    2nd keyword
    END
    Log    Outside Loop 2

Tree Loop Variables
    &{dict}=    Create Dictionary
    FOR    ${index}    ${english}    ${finnish}    IN    1    cat    kissa    2    dog    koira    3    horse    hevonen
        Log    (${index}): ${english} in finish is ${finnish}
        Set To Dictionary    ${dict}    ${english}    ${finnish}
    END
    Log    ${dict}
    Log    ${dict}[cat]
    Log    ${dict}[dog]
    Log    ${dict}[horse]
    ${out}=    Pop From Dictionary    ${dict}    dog
    Log    ${out}
    Log    ${dict}

Only upper limit
    [Documentation]    Loops over values from 0 to 9
    FOR    ${index}    IN RANGE    10
        Log    ${index}
    END

Start and end
    [Documentation]    Loops over values from 1 to 10
    FOR    ${index}    IN RANGE    1    11
        Log    ${index}
    END

Also step given
    [Documentation]    Loops over values 5, 15, and 25
    FOR    ${index}    IN RANGE    5    26    10
        Log    ${index}
    END

Negative step
    [Documentation]    Loops over values 13, 3, and -7
    FOR    ${index}    IN RANGE    13    -13    -10
        Log    ${index}
    END

Arithmetic
    [Documentation]    Arithmetic with variable
    ${var}=    Set Variable    3
    FOR    ${index}    IN RANGE    ${var} + 1
        Log    ${index}
    END

Float parameters
    [Documentation]    Loops over values 3.14, 4.34, and 5.54
    FOR    ${index}    IN RANGE    3.14    6.09    1.2
        Log    ${index}
    END

Exiting For Loop
    ${text} =    Set Variable    ${EMPTY}
    FOR    ${var}    IN    one    two
        Comment    Run Keyword If    '${var}' == 'two'    Exit For Loop
        Exit For Loop If    '${var}' == 'two'
        ${text} =    Set Variable    ${text}${var}
    END
    Should Be Equal    ${text}    one

Continue For Loop
    ${text} =    Set Variable    ${EMPTY}
    FOR    ${var}    IN    one    two    three
        Continue For Loop If    '${var}' == 'two'
        ${text} =    Set Variable    ${text}${var}
    END
    Should Be Equal    ${text}    onethree

*** Keywords ***
My keyword
    [Arguments]    ${path}
    Directory Should Exist    ${path}

Open Login Page
    Open Browser    ${URL}   firefox

Input Username
    [Arguments]    ${name}
    Input Text    user-name    ${name}

Input Passwd
    [Arguments]    ${pass}
    Input Password    password    ${pass}

Submit Credentials
    Click Button    login-button

Welcome Page Should Be Open
    Page Should Contain    Products
    Page Should Contain Element    react-burger-menu-btn

Login Not Successful
    Page Should Contain    Epic sadface: Username and password do not match any user in this service

Several Args Keyword
    [Arguments]    ${arg1}    ${arg2}=Marta
    ${output}=    Set Variable    ${arg2}12345${arg1}
    [Return]    ${output}

Several Args As List Keyword
    [Arguments]    @{names_list}
    Log Many    @{names_list}
