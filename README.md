# the-ways-of-aws-infra-as-code
I got excited about the new [AWS Function URLs](https://aws.amazon.com/blogs/aws/announcing-aws-lambda-function-urls-built-in-https-endpoints-for-single-function-microservices/), so here's three different ways to provision one. And because I like [Clojure](https://clojure.org/) a lot, you also get to see [nbb](https://github.com/babashka/nbb) in action, which is the very easiest way I know of to get Clojure code running on the Internet.

## Pure AWS CLI
In this example, we're using commands from the AWS cli to create all the resources. This is the "low frills" way to do this. It's a node lambda, so building is `npm install` followed by `zip -r app.zip .`

The commands we use are in the `provision.sh` shell script. We use four commands for this:

1. `aws iam create-role`
2. `aws iam attach-role-policy`
3. `aws lambda create-function`
4. `aws create-function-url-config`

There are a couple of tests to see whether a resource exists already before creating it. This allows the script to be re-run without any issues. If the resources exist already, it's a no-op.

When the code changes, you need a different command, `aws lambda update-function-code`

The full steps to deploying the function:

```
cd aws-cli
npm install
npm run build
npm run provision
```

## Serverless Framework
I think [serverless framework](https://serverless.com) has a lot going for it (except for a very generic name). Since it's a npm package, you get it as a dev dependency when you run `npm install`. Here are the steps:

```
cd serverless
npm install
sls deploy
```

## Terraform
[Terraform](https://terraform.io) is a de facto standard for provisioning resources of all kinds, across all clouds. You can also deploy AWS Lambdas with it. Note that for this example, we assume you have terraform installed already, since it's _not_ an npm package. Steps:

```
cd terraform/app
npm install
cd ..
terraform init
terraform plan
terraform apply
```

