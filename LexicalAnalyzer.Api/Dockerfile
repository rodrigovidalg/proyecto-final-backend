# Etapa 1: Compilación (Build)
# Usamos la imagen oficial del SDK de .NET 8 para compilar nuestro proyecto.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos los archivos .csproj y restauramos las dependencias primero.
# Esto aprovecha el caché de Docker y acelera futuras compilaciones.
COPY ["LexicalAnalyzer.Api.csproj", "."]
RUN dotnet restore "./LexicalAnalyzer.Api.csproj"

# Copiamos el resto del código fuente.
COPY . .
WORKDIR "/src/."

# Compilamos el proyecto en modo "Release" y lo dejamos en la carpeta /app/build.
RUN dotnet build "LexicalAnalyzer.Api.csproj" -c Release -o /app/build

# Etapa 2: Publicación (Publish)
# Ahora, tomamos el resultado de la compilación y lo optimizamos para producción.
FROM build AS publish
RUN dotnet publish "LexicalAnalyzer.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa 3: Imagen Final (Final)
# Creamos la imagen final usando una base mucho más ligera, solo con lo necesario para ejecutar la API.
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Exponemos el puerto 8080, que es el estándar para contenedores web.
EXPOSE 8080

# El comando que se ejecutará cuando el contenedor inicie.
ENTRYPOINT ["dotnet", "LexicalAnalyzer.Api.dll"]