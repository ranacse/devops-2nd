# DevOps CI/CD Pipeline Setup - Checklist

## Step 8: Pipeline Configuration ✓

### 8.1 GitHub Repository সেটআপ
- [ ] `index.html` ফাইল GitHub-এ আছে
- [ ] `Dockerfile` GitHub root directory-তে আছে
- [ ] `nginx.conf` GitHub root directory-তে আছে
- [ ] `azure-pipelines.yml` GitHub root directory-তে আছে

### 8.2 Azure DevOps Pipeline সেটআপ
- [ ] Azure DevOps Project এ logged in আছেন
- [ ] New Pipeline create করেছেন
- [ ] GitHub repository connect করেছেন
- [ ] `azure-pipelines.yml` file select করেছেন
- [ ] Pipeline name decide করেছেন
- [ ] Service Connections তৈরি করেছেন:
  - [ ] ACR Service Connection created
  - [ ] Connection name: `your-acr-service-connection`
  - [ ] কী variables update করেছেন:
    - `dockerRegistryServiceConnection` 
    - `containerRegistry` (youracr.azurecr.io)
    - `imageRepository`

### 8.3 Pipeline Test করুন
- [ ] Pipeline successfully run হয়েছে
- [ ] Docker image build হয়েছে
- [ ] Image ACR-এ push হয়েছেছে
- [ ] ACR Portal এ image visible আছে

---

## Step 9: Kubernetes Deployment ✓

### 9.1 Manifest Files Setup
- [ ] `manifests/` folder GitHub-এ তৈরি করেছেন
- [ ] `deployment.yaml` manifests folder-এ রাখেছেন
- [ ] YAML file correctly formatted আছে

### 9.2 AKS Configuration
- [ ] kubectl installed আছে আপনার machine-এ
- [ ] AKS cluster connect করেছেন:
  ```bash
  az aks get-credentials --resource-group <RG_NAME> --name <AKS_NAME>
  ```
- [ ] kubectl commands work করছে:
  ```bash
  kubectl get nodes
  ```

### 9.3 ACR Secret Create করেছেন
- [ ] ACR credentials পেয়েছেন Azure Portal থেকে
- [ ] Secret created in Kubernetes:
  ```bash
  kubectl create secret docker-registry acr-secret ...
  ```
- [ ] Secret verify করেছেন:
  ```bash
  kubectl get secrets
  ```

### 9.4 Azure DevOps Service Connections
- [ ] AKS Service Connection created:
  - [ ] Name: `your-aks-service-connection`
  - [ ] Cluster properly configured
- [ ] azure-pipelines.yml update করেছেন correct names দিয়ে:
  - `kubernetesServiceConnection: 'your-aks-service-connection'`

### 9.5 Deployment Testing
- [ ] Pipeline successfully deployed
- [ ] Pod status check করেছেন:
  ```bash
  kubectl get pods
  ```
- [ ] Service created হয়েছে:
  ```bash
  kubectl get svc
  ```
- [ ] LoadBalancer external IP পেয়েছেন (3-5 minutes পর)
- [ ] Browser থেকে app accessible আছে

---

## Important Variables (আপডেট করুন):

```yaml
# azure-pipelines.yml এ এই values replace করুন:

dockerRegistryServiceConnection: 'YOUR_ACR_SERVICE_CONNECTION_NAME'
imageRepository: 'saif-html-app'  # পরিবর্তন করতে পারেন
containerRegistry: 'youracr.azurecr.io'  # আপনার ACR name
```

```yaml
# deployment.yaml এ এই values update করুন:

image: youracr.azurecr.io/saif-html-app:latest
# youracr = আপনার actual ACR name
```

---

## Troubleshooting Commands:

```bash
# Pipeline logs দেখুন (Azure DevOps UI থেকে)
# Azure DevOps → Pipelines → build logs

# Kubernetes status check করুন
kubectl get pods -n default
kubectl describe pod <POD_NAME> -n default
kubectl logs <POD_NAME> -n default

# Service IP দেখুন
kubectl get svc saif-html-app-service

# Image pull করছে কিনা চেক করুন
kubectl describe pod <POD_NAME> | grep -i image
```

---

## Success Indicators:

✅ সব কিছু ঠিক থাকলে:
1. Pipeline automatically trigger হবে GitHub push-এ
2. Docker image build এবং push হবে
3. AKS-এ pods automatically deploy হবে
4. External IP পাবেন LoadBalancer থেকে
5. Browser-এ "i am saif" message দেখতে পাবেন

---

## নোটস:
- প্রথম deployment 5-10 মিনিট নিতে পারে
- LoadBalancer external IP assign হতে 3-5 মিনিট সময় লাগে
- কোনো error হলে logs check করুন Azure DevOps এবং kubectl থেকে
