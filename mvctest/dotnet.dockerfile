FROM mcr.microsoft.com/dotnet/core/sdk:2.2.104-alpine3.8 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2.2-alpine3.8
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "mvctest.dll"]
