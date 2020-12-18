*** Settings ***
Documentation     Helpes.

*** Keywords ***
Então devo ver a mensagem de sucesso
    [Arguments]     ${expected_message}=Registro inserido com sucesso.

    Run Keyword And Ignore Error    helpers.Get Mensagem de Sucesso   ${expected_message}
    Sleep     0.5s
    # clicando no fechar da mensagem
    Run Keyword And Ignore Error    Mouse Over                          class:alert-success
    Run Keyword And Ignore Error    helpers.Clicar no Elemento          css:span[title="Close"]

E Devo ver a mensagem de alerta 
    [Arguments]        ${MSG_ALERTA}
    Page Should Contain             ${MSG_ALERTA}

E acesso a tela de consulta
    [Arguments]        ${LINK_URL}
    Ir até a página "${LINK_URL}"

Então devo ver a mensagem de alerta
    [Arguments]        ${MSG_ALERTA}
    E Devo ver a mensagem de alerta 