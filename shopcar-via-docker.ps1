# Cria pasta principal
New-Item -ItemType Directory -Force -Path shopcar

# Função para clonar ou atualizar repositórios
function CloneOrPull($repo, $folder) {
  if (Test-Path $folder) {
    Write-Host "`n🌀 Atualizando $repo..."
    Set-Location $folder
    git pull
    Set-Location ../..
  } else {
    git clone "git@github.com:emodulo/$repo.git" $folder
  }
}

# Clona ou atualiza os repositórios
CloneOrPull "shopcar-infra"     "shopcar/shopcar-infra"
CloneOrPull "shopcar-database"  "shopcar/shopcar-database"
CloneOrPull "ms-customer"       "shopcar/ms-customer"
CloneOrPull "ms-vehicle"        "shopcar/ms-vehicle"
CloneOrPull "ms-order"          "shopcar/ms-order"

# Entra no diretório raiz do projeto
Set-Location shopcar

# Instala o Bruno
Write-Host "`nInstalando o Bruno..."
winget install bruno.bruno -e --accept-source-agreements --accept-package-agreements

# Extrai o zip com as collections do Bruno
Write-Host "`nExtraindo coleção do Bruno..."
Expand-Archive -Force "shopcar-infra\shopcar-bruno-folder.zip" -DestinationPath "shopcar-infra\shopcar-bruno-folder"


# Abrir Swagger UI
Write-Host "`n✅ Containers serão iniciados. Abrindo Swagger UI dos microserviços..."

Start-Process "http://localhost:8081/swagger-ui/index.html"
Start-Process "http://localhost:8082/swagger-ui/index.html"
Start-Process "http://localhost:8083/swagger-ui/index.html"

# Sobe os containers
Set-Location shopcar-infra\docker-compose
docker compose up --build


Write-Host "`n✅ Abrir o Bruno e importar a collection em: shopcar/shopcar-infra/shopcar-bruno-folder"
