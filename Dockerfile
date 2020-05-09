#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-nanoserver-1909 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-nanoserver-1909 AS build
WORKDIR /src
COPY ["code_core_api.csproj", "./"]
RUN dotnet restore "./code_core_api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "code_core_api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "code_core_api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "code_core_api.dll"]
