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

# Inicia o Minikube e habilita addons
minikube start
Start-Sleep -Seconds 10

minikube addons enable ingress

Start-Sleep -Seconds 5
minikube addons enable metrics-server

Start-Sleep -Seconds 5

# Aplica métricas
kubectl apply -f shopcar-infra\kubernetes\metrics\

# Aplica MongoDB
kubectl apply -f shopcar-database\kubernetes\mongodb\pv.yaml
kubectl apply -f shopcar-database\kubernetes\mongodb\pvc.yaml
kubectl apply -f shopcar-database\kubernetes\mongodb\

# Aplica PostgreSQL
kubectl apply -f shopcar-database\kubernetes\postgres\pv.yaml
kubectl apply -f shopcar-database\kubernetes\postgres\pvc.yaml
kubectl apply -f shopcar-database\kubernetes\postgres\

# Aplica microserviços
kubectl apply -f .\ms-customer\kubernetes\
kubectl apply -f .\ms-order\kubernetes\
kubectl apply -f .\ms-vehicle\kubernetes\

# Aplica ingress
kubectl apply -f shopcar-infra\kubernetes\ingress\ingress-local.yaml

Write-Host "`n✅ Ambiente Kubernetes configurado com sucesso."
