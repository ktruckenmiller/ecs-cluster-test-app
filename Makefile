develop: build
	docker run -it --rm \
	-v ${PWD}:${PWD} \
	-w ${PWD} \
	-p 8070:3000 \
	myip sh
build:
	docker build -t myip .

run: build
	docker run -it --rm \
	-v ${PWD}:${PWD} \
	-w ${PWD} \
	-p 8070:3000 \
	myip

deploy:
	docker run -it --rm \
	-e IAM_ROLE \
	-e CLUSTER=production-kloudcover \
	-e SERVICE_NAME=my-ip \
	-e PRIORITY=17 \
	-e VERSION=ff5c7d16af77f83e2c92771c48f320da5d401561 \
	-e COUNT=1 \
	-v ${PWD}:/work \
	-w /work \
	ktruckenmiller/ansible \
	ansible-playbook -i ansible_connection=localhost deploy.yml -vvv


put-pipeline:
	docker run -it --rm \
	-v ~/.aws/credentials:/root/.aws/credentials:ro \
	-v ${PWD}:/work \
	-w /work \
	ktruckenmiller/ansible \
	ansible-playbook -i ansible_connection=localhost deploy-pipeline.yml

put-pipeline-friend:
	docker run -it --rm \
	-e IAM_ROLE \
	-e AWS_DEFAULT_REGION=us-east-2 \
	-v ${PWD}:/work \
	-w /work \
	ktruckenmiller/ansible \
	ansible-playbook -i ansible_connection=localhost deploy-pipeline.yml
