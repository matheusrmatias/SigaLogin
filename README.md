<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/bbc366e5-ad67-47e2-b407-bc541c53f051' alt='Login Screen'>

# Siga Login

Faça login no SIGA com um aplicativo desenvolvido em Flutter !!!

## Início

Esse app é uma forma alternativa, segura e amigável de acessar o SIGA (Sistema Integrado de Gestão Acadêmica), já que o mesmo não acessa nenhuma API externa e todos os dados coletados na plataforma ficam total e unicamente armazenados no aparelho do usuário.




## Indíce
- <a href="#inicio">Início</a>
- <a href="#funcionamento">Funcionamento</a>
- <a href="#telas">Telas</a>
    - <a href="#login">Login</a>
    - <a href="#home">Home</a>
    - <a href="#configurações">Configurações</a>
        - <a href="#siga">SIGA</a>
- <a href="#tema-escuro">Tema Escuro</a>
    - <a href="#login-dark">Login</a>
    - <a href="#home-dark">Home</a>


# Funcionamento

O motor disso tudo é o arquivo <a href="https://github.com/matheusrmatias/SigaLogin/blob/main/lib/src/services/student_account.dart">student_account.dart</a>, ele é responsável por criar uma instância do Webview para coletar os dados;

# Telas

O app oferece suporte ao DarkTheme, sendo assim o mesmo se adapta ao tema escolhido pelo usuário em seu sistema operacional;

## Login

<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/ae45c2d9-a82e-47a6-9f12-26fab4f91cd5' alt='Login Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/1a73252f-10bb-4770-b8d1-e0c05434e3fe' alt='Login Screen Loading' width=300>

## Home
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/6946f22e-3f8f-4209-990b-5e8bc271b815' alt='Home Note Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/a4287bd2-8896-420b-8014-eb6b9be8a4b2' alt='Home Historic Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/6cebfb99-f5e2-417b-8105-2e7a2c386321' alt='Home Historic Screen' width=300>

## Configurações
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/85ab465b-ae80-4d4e-b63c-d4e7c3765e61' alt='Home Historic Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/ef9f51a4-f6eb-46d5-8301-48cadf2cf0f1' alt='Home Historic Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/e632aae7-2025-46a3-a36a-32ad2bfc7229' alt='Home Historic Screen' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/34481565-e5bf-4322-b3ae-0b4fcd2030b7' alt='Home Historic Screen' width=300>

### SIGA
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/c221eb67-9de1-41c9-a10f-364ad2de1923' alt='Home Historic Screen' width=300>

## Tema Escuro

Comparativo entre os temas claro e escuro.

### Login Dark
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/ae45c2d9-a82e-47a6-9f12-26fab4f91cd5' alt='Login Light' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/a5e32dd0-f3f3-456d-ae06-3b37883774f9' alt='Login Dark' width=300>

### Home Dark
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/6946f22e-3f8f-4209-990b-5e8bc271b815' alt='Home Light' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/8dd77b78-eb3f-4e2d-9c95-910f45de3d3e' alt='Home Dark' width=300>

### Configurações Dark
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/85ab465b-ae80-4d4e-b63c-d4e7c3765e61' alt='Home Light' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/60e527a4-1238-4c24-9797-9428a5edbabd' alt='Home Dark' width=300>

# Possíveis Erros

Caso você insira seu CPF e/ou Senha incorretamente você será alertado com uma mensagem, outros possíveis erros podem estar associados ao não funcionamento do SIGA e a instabilidade ou indisponibilidade da rede.

<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/d1b9ff33-51a4-4e32-9836-8b78fd676105' alt='Home Light' width=300>
<img src='https://github.com/matheusrmatias/SigaLogin/assets/115509118/88b76e91-fb19-425a-945f-95eca218e5df' alt='Home Dark' width=300>

Caso você altere a senha, ao fazer o "refresh" o app voltará a tela de login;
