# Example lambda function with terraform

## Requirements

- Terraform >=v0.12.24
- provider.aws >=v2.57.0

## Preparing your lambda function

```sh
# Clone the repo
git clone https://github.com/netoht/lambda-terraform.git
cd lambda-terraform/
```

Implement your lambda function in `lambda.py`.

```sh
# Packaging your lambda function
./lambda-package.sh
```

This action will create a zip inside `./tf/target/lambda.zip`

## About Terraform

The Terraform needs to save states about resources, then we need tell to him about that. The `backend.tf` file ask to save state in **s3** and `provider.tf` inform about cloud provider, in this case **AWS**.

The `backend-config/dev` configure the variables in which the environment it will usage to save states.

```ini
# AWS Region of the bucket
region="sa-east-1"
# The bucket name to save state
bucket="myproject-dev"
# The project key of the terraform state
key="tfstate/myproject-dev"
```

For each environment you need create a `variables-{ENV}.tfvar` like this `variables-dev.tfvar`:

```ini
env="dev"
aws_region="sa-east-1"
lambda_name="minimal_lambda_function"
lambda_handler="lambda.handler"
lambda_runtime="python3.6"
lambda_filename="target/lambda.zip"
tags={"Project": "test"}
```

Here was informed the environment and information about lambda function that should be used to create the resources and it will used inside `lambda.tf`. In the `lambda.tf` has the resources that will be created, the `aws_lambda_function` and the `aws_iam_role`.

## Executing Terraform

Terraform needs to initialize (`terraform init`) the state and apply (`terraform apply`) the changes. The `run-terraform.sh` script was created to help us.

```sh
$ cd tf/
# ./run-terraform.sh -e <Environment>
./run-terraform.sh -e dev

...
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

## Validating the new resources created

Execute the command below to test the lambda function:

```sh
aws lambda invoke --invocation-type RequestResponse --function-name minimal_lambda_function_dev --region sa-east-1 --log-type Tail --payload '{"key1":"value1", "key2":"value2", "key3":"value3"}' target/outputfile.txt | jq .LogResult | sed 's/"//g' | base64 --decode
```

You should see something like this:

```
START RequestId: e02625f4-c922-4be1-be9f-15d04897a3ac Version: $LATEST
Received my event: {
  "key1": "value1",
  "key2": "value2",
  "key3": "value3"
}
END RequestId: e02625f4-c922-4be1-be9f-15d04897a3ac
REPORT RequestId: e02625f4-c922-4be1-be9f-15d04897a3ac  Duration: 0.41 ms       Billed Duration: 100 ms Memory Size: 128 MB     Max Memory Used: 42 MB
```

## References

* [Resource: aws_lambda_function](https://www.terraform.io/docs/providers/aws/r/lambda_function.html)
* [How do I allow my Lambda execution role to access my Amazon S3 bucket?](https://aws.amazon.com/pt/premiumsupport/knowledge-center/lambda-execution-role-s3-bucket/)