*** Settings ***
Documentation        Manutenção de Fornecedor

Resource           ../pages/BasePage.robot

*** Keywords ***
Dado que eu tenha um novo cadastro de seguro
    [Arguments]    ${json_string}
    BasePage.Carregando arquivo de dados        cadastro/${json_string}

Quando eu submeto o meu cadastro a tela de Enter Vehicle Data
    helpers.Set Campo Select  id:make     Honda
    helpers.Set Campo Select  id:model    Motorcycle
    helpers.Set Campo Input   id:cylindercapacity        ${acao_json['cylindercapacity']} 
    helpers.Set Campo Input   id:engineperformance       ${acao_json['engineperformance']}  
    helpers.Set Campo Input Data Javascript     dateofmanufacture        ${acao_json['dateofmanufacture']}
    Execute Javascript      document.getElementById("insurance-form").setAttribute("value","field idealforms-field idealforms-field-text valid")
    helpers.Set Campo Select  id:numberofseats    1
    Execute Javascript      document.getElementById("righthanddriveno").click();
    helpers.Set Campo Select  id:numberofseatsmotorcycle    1 
    helpers.Set Campo Select  id:fuel    Gas
    helpers.Set Campo Input   id:payload        ${acao_json['payload']} 
    helpers.Set Campo Input   id:totalweight        ${acao_json['totalweight']}
    helpers.Set Campo Input   id:listprice        ${acao_json['listprice']}
    helpers.Set Campo Input   id:licenseplatenumber      ${acao_json['licenseplatenumber']}
    helpers.Set Campo Input   id:annualmileage        ${acao_json['annualmileage']}
    helpers.Upload file 
    ...     xpath://*[contains(@class, 'ideal-file-upload']     cadastros/arquivos/cadastro_0001.PNG
    helpers.Clicar no "nextenterinsurantdata"
    
E continua o cadastro na aba Enter Insurant Data
    helpers.Set Campo Input   id:firstname        ${acao_json['firstname']}
    helpers.Set Campo Input   id:lastname        ${acao_json['lastname']}
    helpers.Set Campo Input Data Javascript     birthdate        ${acao_json['birthdate']}
    Execute Javascript      document.getElementById("gendermale").click();
    helpers.Set Campo Input   id:streetaddress        ${acao_json['streetaddress']}
    helpers.Set Campo Select  id:country    Brazil
    helpers.Set Campo Input   id:zipcode        ${acao_json['zipcode']}
    helpers.Set Campo Select  id:occupation    Public Official
    Execute Javascript      document.getElementById("skydiving").click();
    helpers.Set Campo Input   id:website        ${acao_json['website']}
   
    helpers.Clicar no "nextenterproductdata"
    
E o cadastro continua na aba Enter Product Data
    helpers.Set Campo Input Data Javascript     startdate        ${acao_json['startdate']}
    helpers.Set Campo Select  id:insurancesum    20000000
    helpers.Set Campo Select  id:meritrating     Malus 10
    helpers.Set Campo Select  id:damageinsurance     Full Coverage
    Execute Javascript      document.getElementById("EuroProtection").click();
    helpers.Set Campo Select  id:courtesycar    Yes
    helpers.Clicar no "nextselectpriceoption"
    
    
Quando vou a proxima aba Select Price Option
    helpers.Clicar no Elemento   xpath://*[@id="priceTable"]/tfoot/tr/th[2]/label[3]
    helpers.Clicar no "nextselectpriceoption"
    
Então finalizo o cadastro na aba Send Quote
    helpers.Set Campo Input  id:email   ${acao_json['email']}
    helpers.Set Campo Input  id:phone   ${acao_json['phone']}
    helpers.Set Campo Input  id:username   ${acao_json['username']}
    helpers.Set Campo Input  id:password   ${acao_json['password']}
    helpers.Set Campo Input  id:confirmpassword   ${acao_json['confirmpassword']}
    helpers.Set Campo Input  id:Comments   ${acao_json['Comments']}
    helpers.Clicar no "sendemail"


    