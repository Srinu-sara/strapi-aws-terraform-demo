# Strapi CMS Deployment on AWS (Terraform)

This project creates a cloud server on AWS and installs the Strapi Headless CMS.

## Project Details
* **Cloud:** AWS (Amazon Web Services)
* **Server Type:** EC2 (Ubuntu 22.04)
* **Tools Used:** Terraform (Infrastructure as Code)
* **App:** Strapi (Node.js)

## How to Deploy

### Step 1: Create Infrastructure
Open your terminal and run these commands to build the server:

terraform init
terraform apply

### Step 2: Install Strapi
Log in to the server using the SSH key:

ssh -i "strapi-key.pem" ubuntu@YOUR_IP_ADDRESS

Once logged in, run these commands one by one to install the software:

1. Install Node.js 20:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential

2. Install PM2 (Keeps the app running):
sudo npm install pm2 -g

3. Create the Strapi App:
npx create-strapi-app@latest my-strapi --quickstart

4. Start the App:
cd my-strapi
npm run build
pm2 start npm --name "strapi" -- run start
pm2 save

## Access the App
Open your browser and go to:
http://YOUR_IP_ADDRESS:1337

## Clean Up (Save Money)
To delete the server when finished:
terraform destroy
