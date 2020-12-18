*** Settings ***
Documentation        Fornecedores
...                   Objeto: app.compras.wmfornecedor

Resource           ../../../resources/actions.robot
Suite Setup         Open Session 
Suite Teardown      Close Session

Test Teardown       Finalizando Teste

*** Test Cases ***
Cenário 01: Novo Fornecedor
    [Tags]      smoke
    Dado que eu tenha um novo cadastro de seguro
    ...    TC01_cadastro.json
    Quando eu submeto o meu cadastro a tela de Enter Vehicle Data
    E continua o cadastro na aba Enter Insurant Data
    E o cadastro continua na aba Enter Product Data
    Quando vou a proxima aba Select Price Option
    Então finalizo o cadastro na aba Send Quote
    Então devo ver a mensagem de sucesso
    ...    Sending e-mail success!  

  