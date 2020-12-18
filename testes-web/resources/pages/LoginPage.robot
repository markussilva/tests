*** Settings ***
Documentation        LoginPage
...                  Representa a página de login com todos os seus elementos
...                  E também suas funcionalidades

*** Variables ***
${LOGIN_FORM}     id:MAINFORM
${INPUT_USUARIO}  id:vUSERNAME
${INPUT_SENHA}    id:vUSERPASSWORD
${LOGIN_BUTTON}   id:BTNENTER

*** Keywords ***
Login With
    [Arguments]    ${login}     ${password}

    helpers.Set Campo Input  ${INPUT_USUARIO}   ${login}
    helpers.Set Campo Input  ${INPUT_SENHA}     ${password}
    helpers.Clicar no "${LOGIN_BUTTON}"

