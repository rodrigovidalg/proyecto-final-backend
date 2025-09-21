# Etapa 1: Compilación (Build)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia todos los archivos del repositorio al contenedor
COPY . .

# Ahora, establece el directorio de trabajo DENTRO de la carpeta del proyecto
WORKDIR /src/LexicalAnalyzer.Api

# Ejecuta los comandos de restauración, compilación y publicación
RUN dotnet restore "LexicalAnalyzer.Api.csproj"
RUN dotnet build "LexicalAnalyzer.Api.csproj" -c Release -o /app/build
RUN dotnet publish "LexicalAnalyzer.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa 2: Imagen Final (Final)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "LexicalAnalyzer.Api.dll"]