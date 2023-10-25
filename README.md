<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/a9d0d5a6-942b-4ad5-9924-12bd710e9c72' alt='Login Screen'>

# "Já tá no Siga?"

Faça login no SIGA com um aplicativo desenvolvido em Flutter !!!


## Indíce
- <a href="#início">🏁 Início</a>
- <a href="#download">⬇️ Download</a>
- <a href="#funcionamento">📱 Funcionamento</a>
- <a href="#telas">📺 Telas</a>
    - <a href="#login">Login</a>
    - <a href="#home">Home</a>
    - <a href="#configurações">Configurações</a>
        - <a href="#carteirinha-de-estudante">Carteirinha de Estudante</a>



## Início

Esse app é uma forma alternativa, segura e amigável de acessar o SIGA (Sistema Integrado de Gestão Acadêmica), já que o mesmo não acessa nenhuma API externa e todos os dados coletados na plataforma ficam total e unicamente armazenados no aparelho do usuário.

## Download
Até o momento o app não foi disponibilizado nas lojas digitais, porém é possível baixar o arquivo ".apk" e realizar a instalação.
<a href="https://github.com/matheusrmatias/SigaLogin/releases/download/v1.3.3/Ja.Ta.No.Siga.1.3.3.apk">
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/ff78b639-e577-4fdf-b62c-c8c7c8ddc8ba' width=275 alt="Botão de Download">
</a>


## Funcionamento

O motor disso tudo é o arquivo <a href="https://github.com/matheusrmatias/SigaLogin/blob/main/lib/src/services/student_account.dart">student_account.dart</a>, ele é responsável por criar uma instância do Webview para coletar os dados;

## Telas

O app oferece suporte ao DarkTheme, sendo assim o mesmo se adapta ao tema escolhido pelo usuário em seu sistema operacional;

#### Login

<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/19281019-79b6-4de1-a13d-10eab8e6d815' alt='Login Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/65dd9bd3-e54a-4088-ad05-ea6758f14bbe' alt='Login Screen Loading' width=300>

### Home
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/97631b21-4d70-4af0-a75c-ebe0ea171a1c' alt='Home Note Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/6ca316d2-8db5-4a9b-b57a-7cdb2eac7236' alt='Home Historic Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/2e491f04-1400-451a-b3d0-01f1a4c77c6e' alt='Home Schedule Screen' width=300>

#### Configurações
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/51482b43-6a5e-4eb7-b776-82c449a24650' alt='Home Historic Screen' width=300>

##### Carteirinha de Estudante
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/fecc53c1-7048-4d44-b5ce-30e62138ba7c' alt='Student Card' width=300>

## Possíveis Erros

Caso você insira seu CPF e/ou Senha incorretamente você será alertado com uma mensagem, outros possíveis erros podem estar associados ao não funcionamento do SIGA e a instabilidade ou indisponibilidade da rede.

Caso você altere a senha, ao fazer o "refresh" o app voltará a tela de login;
