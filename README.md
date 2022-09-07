# AWS-CMS
Autoscalable CMS on AWS with load balancing.

This deployment is for a WordPress server, in a secure, performant, scalable, and cost effective way, running on an Autoscaling group, behind an aplication load balancer, which is behind a network load balancer.

WordPress is open-source software, which means anyone can study its code and write apps (plugins) and templates (themes) for it.

I use bitnami Wordpress server, which comes with the new Gutenberg editor and over 45,000 themes and plugins. The image is certified by Bitnami as secure, up-to-date, and packaged using industry best practices, and approved by Automattic, the experts behind WordPress.

![Diagram](https://github.com/jamcarbon/AWS-CMS/blob/c273f109deeed2e8f1c0fbf990ec23df7b1d800b/diagram.png)

Resources used: 
Application Load Balancer, Network Load Balancer, Autoscaling Group, Elastic IP, Internet Gateway, VPC, Public and Private subnets, RDS


Deployment steps

1. Configure AWS (on your local pc)

        sudo apt install awscli

        aws configure

2. Clone the repository 

        sudo apt install git
    
        git clone https://github.com/jamcarbon/AWS-CMS

        cd GitHubRunners_AWS

        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

3. Install terraform 

        sudo apt-get update && sudo apt-get install terraform

        cd terraform

4. Start Terraform

        terraform init

        You can validate the terraform files by running

                terraform validate

        You can check the terraform plan by running

                terraform plan

5. Deploy all the infrasctructure

        terraform apply

        #(If you want to destroy all the infrastucture created:)

                terraform apply -destroy


On production, to reduce instance price, its recommended to use spot instance, and if necesary to autoscale, use on-demand.
Uncomment these lines:
https://github.com/jamcarbon/AWS-CMS/blob/46120086fc4db38620240472b73870dc2a32581f/5.main.tf#L57-L62