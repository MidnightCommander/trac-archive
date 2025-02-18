# escape=`

FROM microsoft/windowsservercore
SHELL ["powershell"]

RUN $env:chocolateyUseWindowsCompression = 'false'; `
    iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

RUN cinst mc -y

CMD C:\Program` Files` `(x86`)\Midnight` Commander\mc.exe
