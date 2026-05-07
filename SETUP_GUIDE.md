# DevOps CI/CD Pipeline সেটআপ গাইড - Step 8 & 9

## আপনার GitHub Repository Structure হবে:
```
my-devops-project/
├── index.html              # আপনার HTML ফাইল
├── Dockerfile              # Docker image তৈরির জন্য
├── nginx.conf              # Nginx configuration
├── azure-pipelines.yml     # CI/CD Pipeline definition
└── manifests/
    └── deployment.yaml     # Kubernetes deployment
```

---

## **STEP 8: Pipeline Configuration in Azure DevOps**

### 8.1 Azure DevOps-এ Pipeline তৈরি করুন:

1. **Azure DevOps Portal এ যান:**
   - URL: https://dev.azure.com
   - আপনার প্রজেক্টে লগইন করুন

2. **Pipelines মেনুতে যান:**
   - Left sidebar থেকে "Pipelines" ক্লিক করুন
   - "Create Pipeline" বাটন ক্লিক করুন

3. **GitHub Connect করুন:**
   - "Where is your code?" এ "GitHub" সিলেক্ট করুন
   - GitHub-এর সাথে authenticate করুন
   - আপনার রিপোজিটরি সিলেক্ট করুন

4. **Pipeline Configuration:**
   - "Existing Azure Pipelines YAML file" সিলেক্ট করুন
   - Path: `/azure-pipelines.yml` সিলেক্ট করুন
   - "Continue" ক্লিক করুন

---

## **STEP 9: Deployment Configuration**

### 9.1 Kubernetes Manifest ফাইল GitHub-এ রাখুন:

আপনার GitHub repository-তে একটি `manifests/` folder তৈরি করুন এবং `deployment.yaml` রাখুন।

### 9.2 AKS এ Secret তৈরি করুন (ACR access এর জন্য):

```bash
# Terminal/PowerShell-এ এই কমান্ড চালান:

# ACR login details (Azure Portal থেকে পান)
ACR_NAME="youracr"
ACR_USERNAME="<username>"
ACR_PASSWORD="<password>"
ACR_LOGIN_SERVER="${ACR_NAME}.azurecr.io"

# Kubernetes secret তৈরি করুন
kubectl create secret docker-registry acr-secret \
  --docker-server=$ACR_LOGIN_SERVER \
  --docker-username=$ACR_USERNAME \
  --docker-password=$ACR_PASSWORD \
  --docker-email=any@email.com
```

### 9.3 Azure DevOps Pipeline এ Service Connection তৈরি করুন:

**For Azure Container Registry (ACR):**
1. Project Settings → Service Connections
2. "New service connection" → "Docker Registry"
3. Registry type: "Azure Container Registry"
4. Azure Subscription সিলেক্ট করুন
5. Container Registry সিলেক্ট করুন
6. Service connection name: `your-acr-service-connection`

**For AKS (Kubernetes):**
1. "New service connection" → "Kubernetes"
2. Authentication method: "Azure Subscription"
3. Azure Subscription এবং AKS cluster সিলেক্ট করুন
4. Service connection name: `your-aks-service-connection`

---

## **STEP 8 & 9 এর মূল পয়েন্টগুলো:**

### Pipeline (Step 8) কী করে:
1. GitHub-এ code push হলেই automatically trigger হয়
2. Dockerfile দিয়ে Docker image build করে
3. Image কে Azure Container Registry (ACR) এ push করে

### Deployment (Step 9) কী করে:
1. AKS cluster এ deployment deploy করে
2. 2টি replicas চালায় (High Availability এর জন্য)
3. LoadBalancer service এর মাধ্যমে public IP তে অ্যাপ expose করে

---

## **Testing & Verification:**

### Pipeline Status দেখুন:
```
Azure DevOps → Pipelines → ক্লিক করে সব build history দেখুন
```

### AKS এ Deployment verify করুন:
```bash
# Pod status দেখুন
kubectl get pods -n default

# Service status দেখুন
kubectl get svc saif-html-app-service

# Pod logs দেখুন
kubectl logs -n default deployment/saif-html-app
```

### Public IP থেকে অ্যাপ এক্সেস করুন:
```bash
# LoadBalancer এর external IP পান
kubectl get svc saif-html-app-service

# ব্রাউজারে সেই IP address দিয়ে এক্সেস করুন
# Example: http://40.112.xxx.xxx
```

---

## **সাধারণ সমস্যা ও সমাধান:**

### সমস্যা 1: "imagePullBackOff" error
**সমাধান:** ACR secret properly configure করুন
```bash
kubectl get secrets
kubectl describe secret acr-secret
```

### সমস্যা 2: Pipeline build ফেইল হচ্ছে
**সমাধান:** 
- Service connection এর credentials ঠিক আছে কিনা চেক করুন
- Docker image size খুব বড় না হয়েছে চেক করুন

### সমস্যা 3: Service এর external IP কোনো না পাচ্ছেন
**সমাধান:** LoadBalancer provision হতে ৩-৫ মিনিট সময় লাগে

---

## **পরবর্তী ধাপ (Optional):**
- ✅ Auto-scaling setup করুন
- ✅ Monitoring এবং logging setup করুন
- ✅ Custom domain সেটআপ করুন
- ✅ SSL/TLS certificate যোগ করুন

---

**Happy Deploying! 🚀**
