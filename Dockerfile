# ---------------------------
# 1. Build Stage
# ---------------------------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 複製解決方案檔和專案檔
COPY *.sln ./
COPY *.csproj ./

# 還原 NuGet 套件
RUN dotnet restore

# 複製所有專案檔案
COPY . ./

# 發布專案
RUN dotnet publish -c Release -o /app/publish

# ---------------------------
# 2. Runtime Stage
# ---------------------------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# 從 build stage 拷貝已發布的檔案
COPY --from=build /app/publish .

# 啟動 Blazor App
ENTRYPOINT ["dotnet", "BlazorApp1.dll"]
