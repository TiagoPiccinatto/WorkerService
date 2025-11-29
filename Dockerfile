# Imagem base para executar
FROM mcr.microsoft.com/dotnet/runtime:10.0 AS base
WORKDIR /app

# Imagem para build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copia o csproj e restaura dependências
COPY ./GithubWorker.csproj .
RUN dotnet restore GithubWorker.csproj

# Copia todo o código
COPY . .

# Publica o projeto
RUN dotnet publish GithubWorker.csproj -c Release -o /app/publish --no-self-contained

# Imagem final
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "GithubWorker.dll"]
