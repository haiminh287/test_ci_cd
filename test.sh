# Bước 1: Khởi tạo Terraform
terraform init

# Bước 2: Kiểm tra tài nguyên sẽ tạo
terraform plan

# Bước 3: Tạo cụm EKS
terraform apply -auto-approve



Sau khi apply thành công, bạn sẽ có:

EKS cluster đang chạy

Node groups sẵn sàng

VPC/Subnet được cấu hình


aws eks --region us-east-1 update-kubeconfig --name demo-eks-cluster
kubectl get nodes








AWS_REGION="ap-southeast-1"
AWS_ACCOUNT_ID="123456789012"
REPO_NAME="flask-app"
ECR_REPO_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME"

# Tạo repo (nếu chưa có)
aws ecr describe-repositories --repository-names $REPO_NAME >/dev/null 2>&1 || \
aws ecr create-repository --repository-name $REPO_NAME

# Đăng nhập
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL

# Build image
docker build -t $REPO_NAME:latest ./app

# Tag image
docker tag $REPO_NAME:latest $ECR_REPO_URL:latest

# Push image
docker push $ECR_REPO_URL:latest





cd k8s

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Kiểm tra:
kubectl get pods
kubectl get svc



aws eks update-kubeconfig \
  --name $(terraform output -raw cluster_name) \
  --region us-east-1


