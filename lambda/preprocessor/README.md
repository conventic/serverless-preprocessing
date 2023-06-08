
# Use docker image in AWS Lambda

[lambda gettingstarted-images](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-images.html#configuration-images-create)

## Push image to ECR

### Authenticate the Docker CLI to your Amazon ECR registry

```shell
aws ecr get-login-password \
    --region eu-central-1 | docker login --username AWS --password-stdin https://<ACCOUNT_ID>.dkr.ecr.eu-central-1.amazonaws.com
```

### Create a repository in Amazon ECR using the create-repository command

```shell
aws ecr create-repository \
    --repository-name preprocessor \
    --image-tag-mutability MUTABLE \
    --region eu-central-1
```

### Build docker image for linux

Build image for linux

```shell
docker build . -t preprocessor --platform=linux/amd64
```

### Tag image

```shell
docker tag preprocessor:latest <ACCOUNT_ID>.dkr.ecr.eu-central-1.amazonaws.com/preprocessor:latest
```

### Push image

```shell
docker push <ACCOUNT_ID>.dkr.ecr.eu-central-1.amazonaws.com/preprocessor:latest
```

## Push image to Docker

See [https://docs.docker.com](https://docs.docker.com/engine/reference/commandline/login/)  
Use access token as password from [https://hub.docker.com/settings/security](https://hub.docker.com/settings/security)

```shell
docker build . -t clemenspeters/preprocessor --platform=linux/amd64
docker tag preprocessor clemenspeters/preprocessor:latest
```

```shell
docker login
```

```shell
docker push <hub-user>/<repo-name>:<tag>
docker push clemenspeters/preprocessor:latest
```
