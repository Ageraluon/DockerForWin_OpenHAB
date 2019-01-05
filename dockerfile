FROM microsoft/windowsservercore:latest
SHELL ["powershell"]

#Install chocolatey
RUN Set-ExecutionPolicy Bypass; iwr https://chocolatey.org/install.ps1 -UseBasicParsing  | iex
#Install Zulu, a Java OpenSource version, recommended by the OpenHAB website
RUN choco install zulu8 -y
ENV JAVA_HOME "C:\\Program Files\\Zulu\\zulu-8"
#Install openhab without java
RUN choco install openhab --ignore-dependencies -y

#Chocolatey installs OpenHAB in this folder:
WORKDIR C:\\ProgramData\\chocolatey\\lib\\openhab\\tools

#Port under which OpenHAB publishes its webpage
EXPOSE 8080

#Since Docker For Windows can only mount empty folders, move original contents to new temporary folders
RUN Move-Item -Path C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\addons -Destination C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\addons-org; \
    Move-Item -Path C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\conf -Destination C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\conf-org; \
    Move-Item -Path C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\userdata -Destination C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\userdata-org

#These folders can later be mounted from outside the container
VOLUME C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\addons
VOLUME C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\conf
VOLUME C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\userdata

#The start script, checks if original folder content needs to be moved into mounts, the starts OpenHAB
ADD entrypoint.ps1 .

#preferred way, does not work, since openhab shuts down immediately after start
#ENTRYPOINT ["powershell.exe","-command","C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\entrypoint.ps1"]
#other attempt, does not work, same result
#CMD ["powershell.exe","-executionPolicy","bypass","-noexit","-file","C:\\ProgramData\\chocolatey\\lib\\openhab\\tools\\entrypoint.ps1"]
# Temporary workaround, OpenHAB must be started manually :(
CMD ["powershell.exe","-command","while","($true)","{Start-Sleep","-Seconds","3600","}"]