# 🚀 Multi-Cloud GitOps Pipeline: From Infrastructure to Deployment

**A comprehensive DevOps project automating the deployment of a Flask application using Terraform, Ansible, Jenkins, Docker, and ArgoCD.**

## 📋 Architecture Overview

The project automates the entire lifecycle of an application, starting from infrastructure provisioning on AWS to continuous deployment on Kubernetes using GitOps principles.
![ARCHITECTURE](https://github.com/user-attachments/assets/ac720dc3-be10-440e-bbba-cde7c7b1d14e)


---

## 🛠 Step-by-Step Implementation

### **Phase 1: Application Development & Containerization**

1. **Source Code:** Cloned the Flask application source code to the local development environment. 
    ## Screenshot:
    >
    > <img width="1026" height="316" alt="clone the repo" src="https://github.com/user-attachments/assets/b3703a48-acb5-4a4f-aa17-c00504ff2f36" />

2. **Dockerization:** Created a `Dockerfile` to package the application.
  * The application is configured to run on port **5000**.
    ## Screenshot:
    >
    > <img width="468" height="334" alt="Dockerfile" src="https://github.com/user-attachments/assets/d1d89ad2-9a0c-4948-8ad1-965ed70ced58" />


---

### **Phase 2: Infrastructure as Code (Terraform)**

1. **AWS Provisioning:** Wrote Terraform scripts (`.tf` files) to provision the cloud infrastructure.
2. **Resources Created:**
    * **EC2 Instance:** To host the Jenkins master and the Kubernetes cluster.
      ## Screenshot:
      >
      > <img width="1221" height="665" alt="EC2 server for Jenkins" src="https://github.com/user-attachments/assets/d272960e-3169-4716-a199-de54165baabc" />

    
    * **Security Groups:** Configured to allow traffic for SSH (22), Jenkins (8080), ArgoCD (30001), and the Web App (30008).
      ## Screenshot:
      >
      > <img width="1645" height="669" alt="sg inboubd rules" src="https://github.com/user-attachments/assets/1193c7dd-0ce9-4caf-ba2c-e3765312ce37" />

3. **Execution:**
   1. Ran `terraform init` to initialize modules and backend s3 bucket on AWS.
      ## Screenshot:
      >
      > <img width="796" height="561" alt="terraform init" src="https://github.com/user-attachments/assets/9393c216-a9a8-4226-8b01-2684c1ece3b7" />

   2. Ran `terraform apply` to spin up the entire AWS environment automatically .
      ## Screenshot:
      >
      > <img width="927" height="595" alt="terraform apply" src="https://github.com/user-attachments/assets/e51af188-eff8-4aa0-9991-dc6c836695cd" />
      >
      > <img width="1911" height="448" alt="backend bucket" src="https://github.com/user-attachments/assets/5b055b1d-6e58-4ce1-b049-dc093e2518ab" />

---

### **Phase 3: Configuration Management (Ansible)**

Once the servers were ready, Ansible was used to configure them without manual intervention.

  **Ansible Roles:** Developed roles to install all necessary dependencies:
  1. Docker Engine: To run containers.
      ## Screenshot:
        >
        > <img width="944" height="540" alt="common   docker roles in server" src="https://github.com/user-attachments/assets/de81eb56-573a-4761-8133-2527ca7be9bf" />
        
  2. Jenkins: To handle the CI pipeline.
      ## Screenshot:
        >
        > <img width="1221" height="721" alt="jenkins on port 8080 without initial password" src="https://github.com/user-attachments/assets/860ff634-7a5c-48e5-aa54-850678c18c3a" />
  3. Kubernetes (Minikube): To manage the container orchestration.
      ## Screenshot:
        >
        > <img width="1149" height="526" alt="jenkins kubernetes roles in ec2" src="https://github.com/user-attachments/assets/3379124a-09c1-4e31-807c-81fe9be438fd" />
        >
        > <img width="1151" height="344" alt="k8s_deploy on server" src="https://github.com/user-attachments/assets/b0d086c1-8856-4d1b-86c4-fd98fb280523" />
  4. ArgoCD: Installed in the argocd namespace.
     ## Screenshot:
        >
        > <img width="1193" height="397" alt="svc in argo" src="https://github.com/user-attachments/assets/aea4237e-6aa2-4777-aa9d-d2305befd3f3" />

---

### **Phase 4: Jenkins Advanced Configuration**

To ensure code reusability and security, the Jenkins environment was configured with professional standards:

1. **Jenkins Shared Library:**
    * **Modularization:** Created a **Shared Library** to store reusable Groovy scripts and common pipeline logic.
    * **Global Configuration:** Defined the library in Jenkins Global Settings, allowing multiple pipelines to call standardized functions for building, testing, and deploying.
    * **Version Control:** The library itself is maintained in a separate Git repository, ensuring versioning of the CI/CD processes.
      ## Screenshot:
      >
      > <img width="1835" height="831" alt="shared-lib on jenkins1" src="https://github.com/user-attachments/assets/4e9d1ec3-c2c4-448d-9b98-357cb84bd96d" />
      >
      > <img width="1576" height="749" alt="shared-lib on jenkins2" src="https://github.com/user-attachments/assets/b116fcbe-aafa-473e-b14c-f567a30ff95f" />

2. **Credentials Management:**
    * **Secure Storage:** Configured **Jenkins Credentials Manager** to securely store sensitive information.
    * **Stored Secrets:**
    * **Docker Hub Credentials:** For authenticating the `docker push` operations.
    * **GitHub Personal Access Tokens (PAT):** To allow Jenkins to update the Kubernetes manifests repository.
      ## Screenshot:
      >
      > <img width="1877" height="339" alt="pipeline credintials" src="https://github.com/user-attachments/assets/618de234-34fc-48c8-a18c-dfe296a44d5a" />

3. **Jenkins Pipeline Stages & Continuous Integration**

  * The Jenkins pipeline was designed using a **Declarative Pipeline** approach, leveraging the **Shared Library** for modularity. Each stage was verified for successful execution:

     1. **Checkout:** Automatically pulls the source code from the GitHub repository upon every commit.
     2. **Docker Build:** Builds the Docker image for the Flask application using the `Dockerfile`.
     3. **Docker Scan:** Scaning the image by Docker
        ## Screenshot:
        >
        > <img width="1885" height="866" alt="scan the image" src="https://github.com/user-attachments/assets/e11bcf61-be26-4daa-bfc3-39a5d4f32447" />
    
     4. **Docker Push:** Tags the image with the unique Build ID and pushes it to **Docker Hub** using secure credentials.
        ## Screenshot:
        >
        > <img width="941" height="633" alt="docker hub image" src="https://github.com/user-attachments/assets/8f3106f4-3a1d-4b3f-adf7-efd48c4fea9b" />
    
    5. **Manifest Update:** Uses a script to update the `deployment.yaml` in the Kubernetes Git repository with the newly generated image tag.
        ## Screenshot:
        >
        > <img width="1166" height="844" alt="image in deployment file changed" src="https://github.com/user-attachments/assets/afa1e0f6-57b3-410c-ba57-336a7265cd41" />
        >
        > <img width="1259" height="617" alt="commit of change image" src="https://github.com/user-attachments/assets/58581618-1dc1-4e18-a59c-27c369d57cfd" />
        
  ## Final Pipeline Success
  ## Screenshot:
  >
  > <img width="1344" height="447" alt="pipeline success" src="https://github.com/user-attachments/assets/38922c64-4ed5-4246-98f7-e7ca61e7f8d4" />
---

### **Phase 5: Continuous Delivery (ArgoCD & GitOps)**

1. **Cluster Connection:** Connected ArgoCD to the Kubernetes manifests repository.
    ## Screenshot:
    >
    > <img width="1215" height="689" alt="application on argocd" src="https://github.com/user-attachments/assets/75f51353-634b-4d73-97d0-f7abb1fa3fa2" />

2. **GitOps Sync:**  ArgoCD monitors the repository for changes.
    * Automatically synchronizes the cluster state with the GitHub manifests.
    * Ensures the live environment matches the defined configuration (Self-healing).
    
        ## Screenshot:
        >
        > <img width="1214" height="682" alt="deploy srv ns on argocd" src="https://github.com/user-attachments/assets/fdf431d2-fd1b-4b20-b493-64ac97ceb372" />
        >
        > <img width="1194" height="712" alt="rs pods" src="https://github.com/user-attachments/assets/8e4e7026-4d91-4813-af4d-e613dd2bfa59" />

---

## 🌐 Final Application Access

The application is successfully deployed in the `ivolve` namespace and is accessible externally.

* **ArgoCD UI:** `https://98.87.155.208:30001` and using port-forwarding on 8443 `kubectl port-forward svc/argocd-server -n argocd 8443:443 --address 0.0.0.0`
    ## Screenshot:
    >
    > <img width="1203" height="708" alt="argocd opend" src="https://github.com/user-attachments/assets/bafca39e-0729-49bd-a293-dcefe7dec2a4" />

* **Flask Web App:** `http://98.87.155.208:30008` and using port-forwarding on port 7070 `kubectl port-forward svc/my-app-service -n ivolve 7070:5000 --address 0.0.0.0`
    ## Screenshot:
    >
    > <img width="1210" height="731" alt="application done" src="https://github.com/user-attachments/assets/85a1fdce-9e09-4633-9299-e56c0416a263" />
