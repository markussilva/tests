*** Settings ***
Documentation        BasePage
...                  Representa a inicialização do Selenium e demais cursos como ganchos e helpers.

# bibliote do motor do selenium
Library               SeleniumLibrary
# biblioteca geral
Library               OperatingSystem
# biblioteca de conexao com o banco
Library               DatabaseLibrary
# biblioteca de captura de video
Library               ScreenCapLibrary

*** Variables ***
${LOGIN URL}        ${BASE_URL}
${DELAY}            0
${CHROME_OPTIONS}   options=add_experimental_option('excludeSwitches',['enable-logging'])
${LOGGED}           ${EMPTY}

*** Keywords ***
## helpers
Open Chrome
    Open Browser                    ${LOGIN URL}      chrome    #options=add_experimental_options('excludeSwitches',['enable-logging'])

Open Chrome Headless
    Open Browser                    ${LOGIN URL}      headlesschrome    #options=add_experimental_options('excludeSwitches',['enable-logging'])

Open Session
    Run Keyword If    "${browser}" == "chrome"
    ...    Open Chrome

    Run Keyword If    "${browser}" == "headless"
    ...    Open Chrome Headless
    
    # Maximize Browser Window
    Set Window Size                 1680    1200                    #1440    900
    Set Browser Implicit Wait       60 seconds
    Set Selenium Implicit Wait      60 seconds
    Set Selenium Speed              .1 seconds
    Set Selenium Timeout            60 seconds

Close Session   
    Run Keyword If    "${LOGGED}" == "logado"
    ...    Log to console    nÃO FECHA
    ...    ELSE   Close Browser

Finalizando Teste
    Capture Page Screenshot

Login Session
    [Arguments]     ${usuer}       ${pass}    ${modulo}

    Run Keyword If    "${LOGGED}" == "logado"
    ...    Estou na página de login?
    ...    ELSE    Abrir Navegador     ${usuer}      ${pass}
    
    E devo acesar o módulo 
    ...    ${modulo}
 
E devo acesar o módulo 
    [Arguments]     ${expected_modulo}

    sleep    1s
    helpers.Clicar no Elemento     
    ...    xpath://*[text()="${expected_modulo}"]
    
Estou na página de login?
    [Documentation]    Função para identificar se a sessão caiu,
    ...                caso tenha caído ele irá logar novamente

    ${passed}=    Run Keyword And Return Status    Title Should Be    LOGIN - SSO
    
    Run Keyword If    ${passed}    Logar Novamente   ${LOGGED}    ${EMPTY} 
    ...    ELSE    helpers.Ir até a página "app.wwpbaseobjects.home"   

Logar Novamente
    [Documentation]        Caso a sessão caia vamos fazer um novo login.

    [Arguments]     ${usuer}       ${pass} 

    Set Global Variable    
    ...    ${LOGGED}    ${EMPTY}

    Login With       
    ...    ${USUARIO_GLOBAL}   ${SENHA_GLOBAL}

    Set Global Variable    
    ...    ${LOGGED}    logado    

Abrir Navegador
    [Arguments]     ${usuer}       ${pass}

    Open Session
    Login With      ${usuer}      ${pass}

    Set Global Variable    
    ...    ${LOGGED}    logado

Conecta no Banco Oracle
    # Connect To Database     ${ORACLE DATABASE DRIVER} ${ORACLE DATABASE URL} ${ORACLE DATABASE USER} ${ORACLE DATABASE PASSWORD}
    connect to database using custom params     cx_Oracle       ${DB_CONNECT_STRING}

Disconnect From DB
    #Disconnect from DB
    disconnect from database

E devo ver a mensagem de sucesso
    Wait Until Element Is Visible       css:.alert-success
    Element Text Should Be              css:.alert-success     Registro salvo com sucesso.
    Mouse Over                          css:.alert-success
    Set Focus To Element                css:.alert-success

E devo ver a mensagem de excluído com sucesso
    Wait Until Element Is Visible       css:.alert-success
    Element Text Should Be              css:.alert-success     Registro excluído com sucesso.
    Mouse Over                          css:.alert-success
    Set Focus To Element                css:.alert-success


Checando numero de mensagem sucesso
    [Arguments]     ${seletor}
    
    Wait Until Element Is Visible       css:.alert-success
    @{elements}=    Get WebElements     css:.alert-success
    #checando se esta aparecendo somente uma mensagem de suscesso
    Log Many    @{elements}
    ${count}=    Get Element Count     ${seletor}
    Should Be True      '${count}'=='1'

Carregando arquivo de dados
    [Arguments]     ${json_file}

    ${acao_json}=   helpers.Retorna arquivo em Json     ${json_file}
    Set Test Variable      ${acao_json}
    Sleep   0.5s

E acesso a funcionalidade  
    [Arguments]     ${tela_de_acesso}

    Sleep       0.5s
    Go To       ${BASE_URL}/servlet/${tela_de_acesso}    

E devo clicar no botão inserir
    helpers.Clicar no Botão Inserir

E devo clicar no botão confirmar
    helpers.Clicar no Botão Confirmar

Quando clico no botão confirmar
    helpers.Clicar no Botão Confirmar

Então devo ver a mensagem de successo
    helpers.Get Mensagem de Sucesso
    ...    Registro salvo com sucesso!

Então devo ver a mensagem
    [Arguments]    ${expected_message}
    helpers.Get Mensagem de Sucesso
    ...    ${expected_message}

E vou para o topo da página, visualizo a mensagem e fecho a mensagem
    Scroll topo da pagina EMNF
    Run Keyword And Ignore Error    Mouse Over                          class:alert-success
    Run Keyword And Ignore Error    helpers.Clicar no Elemento          css:span[title="Close"]

E devo ver a mensagem de erro
    [Arguments]     ${expected_message}

    Wait Until Element Is Visible       css:.alert-danger
    @{elements}=    Get WebElements     css:.alert-danger

    ${mensagem_retorno}=    Checando se a mensagem esta na lista    ${expected_message}     @{elements}
    Should Be True   '${expected_message}'=='${mensagem_retorno}'
   
Checando se a mensagem esta na lista
    [Arguments]     ${expected_message}      @{elements} 

    FOR    ${element}   IN      @{elements}    
        ${text}=    Get Text    ${element} 
        Run Keyword If      '${text}'=='${expected_message}'    Return From Keyword     ${text}
    END
    Return From Keyword     ${EMPTY}

Limpar filtros de pesquisa
    Click Element       id:DDO_MANAGEFILTERSContainer_btnGroupDrop
    Click Link          css:ul[aria-labelledby="DDO_MANAGEFILTERSContainer_btnGroupDrop"] > li > a
    sleep    1s 

Retorna valor numerico
    [Arguments]    ${NUMCOMODATO}
    Set List Value      ${NUMCOMODATO}    2    -3       