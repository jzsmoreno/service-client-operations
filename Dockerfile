# To enable ssh & remote debugging on app service change the base image to the one below
# I am running Debian 11 here so:
FROM mcr.microsoft.com/azure-functions/python:4-nightly-python3.11
WORKDIR /home/site/wwwroot
    
ARG AzureWebJobsStorage
    
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
        AzureWebJobsStorage=${AzureWebJobsStorage}
    
# Install necessary tools, add Microsoft's public key, and Microsoft's ODBC SQL Server driver
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    gnupg \
    git \
    g++ \
    unixodbc-dev \
    unixodbc
    
# Install MS and ODBC driver
RUN curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
        apt-get update && \
        ACCEPT_EULA=Y apt-get install -y msodbcsql17
    
EXPOSE 80
    
COPY . .
    
RUN pip install --no-cache-dir -r ./requirements.txt