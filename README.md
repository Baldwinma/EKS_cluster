# eks_cluster

This is an eks cluster created using terraform

-The Terraform Configuration has different modules to help make this reusable in different environments such as DEV, PROD, STAGING

-For simplicity Authentication can be done from the command line using the 
    aws configure command 
    You would need AWS Access Key ID, AWS Secret Access Key, Default region name, & Default output format
    
TERRAFORM COMMANDS TO RUN 

# terraform init
# terraform validate
# terraform plan
# terraform apply

TO DO AFTER PROVISIONING

PULL DOWN KUBECONFIG FILE USING FOLLOWING COMMAND
# aws eks --region us-east-1 update-kubeconfig --name eks --profile default

To Ensure you have adequate connection
# kubectl get svc -n kube-system

Use this path to ensure spin up deployment of docker image
# kubectl apply -f <Path to k8s deployment file> -n kube-system

Get pods running in K8S
# kubectl get pods -n kube-system

Get services running in K8S
# kubectl get service -n kube-system

Access application
# curl <external ip of load balancer>