*** Settings ***
Documentation     Helpers.

*** Variables ***
${BT_INSERIR}     id:BTNINSERT
${BT_CONFIRMAR}   id:BTNTRN_ENTER
${EXCLUIR_GRID}     xpath://*[@id="GridContainerRow_0001"]/td[1]/div/div/ul/li[4]/a
${EDITAR_GRID}      xpath://*[@id="GridContainerRow_0001"]/td[1]/div/div/ul/li[3]/a
# ${CURDIR}        
*** Keywords ***
## Is
Is Registro cadastrado by name
    [Documentation]        Verifica se o item foi cadastrado, relaizado um wher no nome do atributo
    [Arguments]    ${SCHEMA_TABELA_NAME}    ${TABLE_ATRIBUTO}    ${VALOR}
    
    BasePage.Conecta no Banco Oracle
    Row Count Is Equal To X     select ${TABLE_ATRIBUTO} from ${SCHEMA_TABELA_NAME} where upper(${TABLE_ATRIBUTO})=upper('${VALOR}')     1
    BasePage.Disconnect From DB

## DEL
Deletar registro da "${TABELA}" com o campo "${CAMPO}" que contém o valor "${VALOR}"
    BasePage.Conecta no Banco Oracle
    Execute SQL String    DELETE FROM ${TABELA} WHERE UPPER(${CAMPO})=UPPER('${VALOR}')
    BasePage.Disconnect From DB

Del registro by name
    [Arguments]    ${SCHEMA_TABELA_NAME}    ${TABLE_ATRIBUTO}    ${VALOR}

    BasePage.Conecta no Banco Oracle
    Execute SQL String    DELETE FROM ${SCHEMA_TABELA_NAME} WHERE UPPER(${TABLE_ATRIBUTO})=UPPER('${VALOR}')
    BasePage.Disconnect From DB

Del registro by id
    [Arguments]    ${SCHEMA_TABELA_NAME}    ${TABLE_ATRIBUTO}    ${VALOR}

    BasePage.Conecta no Banco Oracle
    Execute SQL String    DELETE FROM ${SCHEMA_TABELA_NAME} WHERE ${TABLE_ATRIBUTO}=${VALOR}
    BasePage.Disconnect From DB

##  GET
Retorna arquivo em Json
    [Documentation]     Função responsável por transformar uma string json em um objeto.

    [Arguments]     ${json_file}

    ${string_file}=        Get File    ${EXECDIR}/resources/fixtures/${json_file}
    ${jsob_object}=       Evaluate    json.loads($string_file)     json

    [Return]    ${jsob_object}

Get Arquivo Json
    [Arguments]     ${json_file}

    ${string_file}=         Get File    ${EXECDIR}/resources/fixtures/${json_file}
    ${jsob_object}=         Evaluate    json.loads($string_file)     json

    [Return]    ${jsob_object}

Get Mensagem de Sucesso 
    [Documentation]     Função responsável por válidar se a mensagem de sucesso
    ...                 está sendo retornada no campo correto, com a classe correta (.alert-success)
    ...                 caso não tenha passado nenhuma mensagem a mensagem padrão será
    ...                 Registro inserido com sucesso.

    [Arguments]     ${expected_message}=Registro inserido com sucesso.
    
    Set Focus To Element                css:.alert-success
    Wait Until Element Is Visible       css:.alert-success    60s

    helpers.Get Quantidade de Mensagem de Sucesso

    Element Text Should Be              css:.alert-success     ${expected_message}
    # Mouse Over                          css:.alert-success
    # helpers.Clicar no Elemento          css:span[title="Close"]
    
Get Quantidade de Mensagem de Sucesso   
    [Documentation]     Função utilizada para verificar se existe mais de uma mensagem de sucesso na tela
    ...                 Como controle para evitar erros caso ocorra de aparecer mais de uma mensagem

    Wait Until Element Is Visible       css:.alert-success    60s
    @{elements}=    Get WebElements     css:.alert-success
    ${count}=       Get Length  ${elements}
    Run Keyword If      ${count}>1    Fatal Error     msg=Ops, esta sendo aprensentado mais de uma mensagem de sucesso.

Get Mensagem de Erro 
    [Arguments]     ${seletor}      ${expected_message}

    Wait Until Element Is Visible       ${seletor}    60s
    @{elements}=    Get WebElements     ${seletor}

    FOR    ${element}   IN      @{elements}    
        ${text}=    Get Text    ${element} 
        Exit For Loop If    '${text}'=='${expected_message}'
    END
    Run Keyword If   '${text}'!='${expected_message}'   Fatal Error     msg=Mensagem, ${expected_message}, não encontrada.
##  SET
Set Campo Input
    [Documentation]     Função reponsável por colocar valor no campo desejado

    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}

    sleep  0.5s 
    Wait Until Page Contains Element    ${CAMPO_INPUT}
    Wait Until Element Is Visible       ${CAMPO_INPUT} 
    Set Focus To Element                ${CAMPO_INPUT} 
    Input Text      ${CAMPO_INPUT}      ${CAMPO_VALOR}      
    # para disparar os campos com isvalid
    Press Keys      ${CAMPO_INPUT}      TAB

Set Campo Input Data Javascript
    [Documentation]     Função reponsável por colocar valor no campo desejado via javascript
    ...                 e por um erro que estava dando no genexus, foi colocado para atribuir
    ...                 valor no atributo data-gx-oldvalue, utilizado para campos que possuem
    ...                 o date picker

    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}

    Wait Until Page Contains Element    ${CAMPO_INPUT}    60s
    Wait Until Element Is Visible       ${CAMPO_INPUT}    60s
    Set Focus To Element                ${CAMPO_INPUT}

    Execute Javascript      document.getElementById("${CAMPO_INPUT}").value="${CAMPO_VALOR}";
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").setAttribute("data-gxoldvalue","${CAMPO_VALOR}");
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").setAttribute("data-gxvalid","0");
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").setAttribute("gxctrlchanged","1");

    # para disparar os campos com isvalid
    Press Keys      ${CAMPO_INPUT}      TAB

Set Campo Input Data Javascript WC
    [Documentation]     Função reponsável por colocar valor no campo desejado via javascript
    ...                 e por um erro que estava dando no genexus, foi colocado para atribuir
    ...                 valor no atributo data-gx-oldvalue, utilizado para campos que possuem
    ...                 o date picker

    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}

    Wait Until Page Contains Element    xpath://input[contains(@id,'${CAMPO_INPUT}')]
    Wait Until Element Is Visible       xpath://input[contains(@id,'${CAMPO_INPUT}')]
    Set Focus To Element                xpath://input[contains(@id,'${CAMPO_INPUT}')]

    Execute Javascript      document.querySelector('[id$="${CAMPO_INPUT}"]').value="${CAMPO_VALOR}"
    Execute Javascript      document.querySelector('[id$="${CAMPO_INPUT}"]').setAttribute("data-gxoldvalue","${CAMPO_VALOR}");

    Press Keys      xpath://input[contains(@id,'${CAMPO_INPUT}')]      TAB


Set Campo Input Javascript
    [Documentation]     Função reponsável por colocar valor no campo desejado via javascript
    ...                 pois os campos do tipo password e campos de transaction necessitavam
    ...                 de um input de valor mais hard


    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}
  
    Wait Until Page Contains Element    ${CAMPO_INPUT}
    Wait Until Element Is Visible       ${CAMPO_INPUT}     60s
    Set Focus To Element                ${CAMPO_INPUT} 
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").value="${CAMPO_VALOR}";    
    # para disparar os campos com isvalid
    Press Keys      ${CAMPO_INPUT}      TAB


Set Campo Input Javascript Brute Force
    [Documentation]     Função reponsável por colocar valor no campo desejado via javascript
    ...                 pois os campos do tipo password e campos de transaction necessitavam
    ...                 de um input de valor mais hard


    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}
  
    Wait Until Page Contains Element    ${CAMPO_INPUT}
    Wait Until Element Is Visible       ${CAMPO_INPUT}     60s
    Set Focus To Element                ${CAMPO_INPUT} 
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").value="${CAMPO_VALOR}"; 
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").setAttribute("data-gxoldvalue","${CAMPO_VALOR}");
    Execute Javascript      document.getElementById("${CAMPO_INPUT}").setAttribute("gxctrlchanged","1");   
    # para disparar os campos com isvalid
    Press Keys      ${CAMPO_INPUT}      TAB

Set Campo Select
    [Documentation]     Função reponsável por selecionar um item de uma combobox

    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}
    Wait Until Element Is Visible   ${CAMPO_INPUT}    60s
    Select From List By Value       ${CAMPO_INPUT}     ${CAMPO_VALOR}

Set Campo Checkbox Selecionado
    [Documentation]     Função reponsável por preencher valor em um campo checkbox

    [Arguments]     ${CAMPO_INPUT}
    Wait Until Keyword Succeeds         1 min   2s  Wait Until Element Is Visible       ${CAMPO_INPUT}  
    Wait Until Keyword Succeeds         1 min   2s  Select Checkbox                     ${CAMPO_INPUT}  
## ACTIONS CLICK
Clicar no Botão Confirmar
    [Documentation]     Função utilziada para clicar no botão confirmar, nas WT ou TM

    Wait Until Element Is Visible   
    ...    css:input[title="Confirmar"]    60s   
    Wait Until Element Is Enabled   
    ...    css:input[title="Confirmar"]    60s
 
    Wait Until Keyword Succeeds        60s   1s    Click Element    css:input[title="Confirmar"]
    Sleep     2s 


Clicar no Botão Inserir
    [Documentation]     Função utilziada para clicar no botão confirmar, nas WM ou WW(Selection)

    BasePage.Limpar filtros de pesquisa
    Wait Until Element Is Visible   ${BT_INSERIR}   
    Wait Until Element Is Enabled   ${BT_INSERIR} 
    Sleep     5s  
    Click Element                   ${BT_INSERIR} 
    # Execute Javascript      document.getElementById("BTNINSERT").click();

Clicar no "${BUTTON}"
    [Documentation]     Função utilizada para clicar em um botão passando somente o seletor
    ...                 foi criada essa função para que não necessite mais de ficar passando as 3 keyword
    ...                 fazendo assim com que o codigo fique mais limpo
    
    Wait Until Element Is Visible       ${BUTTON}    60s
    Wait Until Element Is Enabled       ${BUTTON}    60s
    Wait Until Keyword Succeeds        30s   1s    Click Button                        ${BUTTON}


Clicar no Elemento 
    [Arguments]        ${ELEMENTO}
    [Documentation]     Função utilizada para clicar em um link

    Set Focus To Element      
    ...    ${ELEMENTO}

    Wait Until Keyword Succeeds        
    ...    60s   1s    Click Element    ${ELEMENTO}
    

Clicar no Link "${LINK}"
    [Documentation]     Função utilizada para clicar em um link

    Wait Until Keyword Succeeds        
    ...    30s   1s  Click Link     ${LINK}

Clicar no prompt by id
    [Arguments]     ${selector_prompt}

    Wait Until Element Is Visible      id:${selector_prompt}    60s
    Wait Until Element Is Enabled      id:${selector_prompt}    60s
    Wait Until Keyword Succeeds        30s   1s  Click Image     id:${selector_prompt}
    
Clicar na imagem by xpath
    [Arguments]     ${selector_xpath}

    Wait Until Keyword Succeeds        30s   1s  Wait Until Element Is Visible      xpath:${selector_xpath}          # //*[@id="vSELECT_0001"]
    Wait Until Keyword Succeeds        30s   1s  Wait Until Element Is Enabled      xpath:${selector_xpath}
    Wait Until Keyword Succeeds        30s   1s  Click Image     xpath:${selector_xpath}

Clicar no prompt by class
    [Arguments]     ${selector_prompt}

    Wait Until Keyword Succeeds        30s   1s  Click Image     class:${selector_prompt}

## ACTIONS REDIRECT
Ir até a página "${PAGINA}"
    [Documentation]     Função utilizada para redirecionar para outra página do sistema
    Go To       ${BASE_URL}/servlet/${PAGINA} 
    Sleep       0.5s
      

## ACTIONS GENERICOS
## VALIDAÇÕES
Checagem de valor na grid
    [Arguments]    ${selecot}    ${valor}

    Wait Until Keyword Succeeds        60s   1s  Table Row Should Contain     ${selecot}    1    ${valor}

(Des)Marcar checkbox
    [Arguments]     ${seletor}    ${valor}     

    Run Keyword If   '${valor}'=='false'    Unselect Checkbox    id:${seletor}     
    ...              ELSE       Select Checkbox     id:${seletor} 

(Des)Marcar Todos 
    [Arguments]     ${valor} 
        
    # Sleep     2s
    Run Keyword If   '${valor}'=='false'    Unselect Checkbox    css:input[type="checkbox"]   
    ...              ELSE       Select Checkbox     css:input[type="checkbox"]
    
Checando campo display
    [Arguments]    ${selecot}    ${valor}
    
    Wait Until Element Is Visible     css:#span_${selecot}.ReadonlyAttributeFL    60s
    Element Should Contain   

Validar o padrão do botão selecionar
    [Arguments]    ${Tipo}    ${Tela}    ${Nome}
    [Documentation]    Caso de teste usado para confirmar o padrão do botão de selecionar
    Run Keyword And Ignore Error    
    ...    wait until page contains element    xpath://${Tipo} [@class='${acao_json['${Tela}']}'][@title='${Nome}']

Checando título da página
    [Arguments]    ${pagina_titulo} 
    Run Keyword And Ignore Error    
    ...    Wait Until Keyword Succeeds        60s   1s  Title Should Be    ${pagina_titulo} 

Clicar no botao
    [Arguments]    ${seletor}
Wait Until Keyword Succeeds        30s   1s  Wait Until Element Is Visible    ${seletor}
    Wait Until Keyword Succeeds        30s   1s  Execute Javascript      document.getElementById("${seletor}").click();

Clicar no botao WC
    [Arguments]  ${seletor}  ${index}
    Wait Until Keyword Succeeds        30s   1s  Wait Until Element Is Visible   xpath=(//*[contains(@id,'${seletor}')])[${index}+1]
    Wait Until Keyword Succeeds        30s   1s  Execute Javascript      document.querySelectorAll('[id$="${seletor}"]')[${index}].click();
    # Press Keys     xpath://input[contains(@id,'${seletor}')]      TAB

Clicar no botao WebComponent 
    [Arguments]  ${seletor}  ${index}
    Wait Until Keyword Succeeds        30s   1s  Execute Javascript      document.querySelectorAll('[id$="${seletor}"]')[${index}].click();

Scroll topo da pagina
    Execute JavaScript    window.scrollTo(200,0)

Scroll footer da pagina
    Execute JavaScript    window.scrollTo(2000,2000)

Scroll da pagina a esquerda
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight) 
   
Upload file
    [Arguments]    ${UploadFiletest}    ${AddFile}
    Wait Until Page Contains Element   ${UploadFiletest}   60s
    Scroll Element Into View     ${UploadFiletest}
    Choose File     ${UploadFiletest}     ${EXECDIR}/resources/fixtures/${AddFile}

Set Campo Input In webcomponent
    [Documentation]     Função reponsável por colocar valor no campo desejado
    ...                 Preenchendo valor para o campo desejado
    [Arguments]     ${CAMPO_INPUT}      ${CAMPO_VALOR}
    # sleep  0.5s 
    Wait Until Page Contains Element    xpath://input[contains(@id,'${CAMPO_INPUT}')]    60s
    Wait Until Element Is Visible       xpath://input[contains(@id,'${CAMPO_INPUT}')]    60s
    Set Focus To Element                xpath://input[contains(@id,'${CAMPO_INPUT}')]

    Input Text      xpath://input[contains(@id,'${CAMPO_INPUT}')]      ${CAMPO_VALOR}      
    # para disparar os campos com isvalid
    Press Keys      xpath://input[contains(@id,'${CAMPO_INPUT}')]      TAB

Fechar mensagem de tela
    Run Keyword And Ignore Error    Mouse Over                          class:alert-success
    Run Keyword And Ignore Error    helpers.Clicar no Elemento          css:span[title="Close"]

    