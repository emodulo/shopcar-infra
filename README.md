# shopcar-infra

O repositório `shopcar-infra` é responsável pelos manifestos Kubernetes e automações necessárias para o deploy dos microserviços da plataforma ShopCar, incluindo `ms-order`, `ms-customer`, `ms-vehicle` e seus respectivos bancos de dados.

## O que este repositório contém?

- Arquivos YAML de **Deployment**, **Service**, **Ingress**, **ConfigMap**, **Secrets**, **HPA**
- Scripts para instalação via PowerShell (docker e Kubernetes local)
- Roteamento via Ingress Controller (ALB ou NGINX)
- Configuração para aplicar métricas no cluster Kubernetes
- Suporte a GitHub Actions para deploy automático

## Estrutura do Projeto

```
shopcar-infra/
├── docker-compose/
├── kubernetes/
│   └── ingress/
│   └── metrics/
├── shopcar-via-docker.ps1/
├── shopcar-via-kubernetes.ps1/
├── shopcar-bruno-folder.zip/
```

## Instalação

### Modo Local (via Docker Compose)

```powershell
powershell -ExecutionPolicy Bypass -File shopcar-via-docker.ps1
```

Este script sobe os microserviços e bancos de dados localmente com Docker Compose.

### Modo Kubernetes (Minikube ou EKS)

```powershell
powershell -ExecutionPolicy Bypass -File shopcar-via-kubernetes.ps1
```

Este script aplica os manifests no cluster Kubernetes.

## Componentes Criados

- **Deployments** com probes e réplicas
- **Services** com tipo ClusterIP para comunicação interna
- **HPA** com threshold de 75% para CPU e memória
- **Ingress** com roteamento para `/api/v1` dos microserviços
- **PVC e Volumes** para persistência do MongoDB
- **Secrets** e **ConfigMaps** para parametrização das aplicações

## Segurança

- Segredos sensíveis como senhas de banco são gerenciados via `Secret`
- As configurações não sensíveis (portas, nomes, hosts) são gerenciadas via `ConfigMap`
- A autenticação das APIs é feita via **AWS Cognito**

## GitHub Actions

Este repositório é utilizado nos pipelines dos microserviços para:

- Aplicar os manifests no EKS
- Automatizar o deploy após o push na branch `main` dos serviços

---

## Contribuidores

- Kreverson Silva – Arquiteto de Software e DevOps