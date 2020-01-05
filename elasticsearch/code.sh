
docker build -t elasticsearch-6-ecr:latest .
eval $(aws ecr get-login --region ap-southeast-1 --no-include-email | sed 's|https://||')
docker tag elasticsearch-6-ecr:latest 525589461975.dkr.ecr.ap-southeast-1.amazonaws.com/elasticsearch-demo
docker push 525589461975.dkr.ecr.ap-southeast-1.amazonaws.com/elasticsearch-demo