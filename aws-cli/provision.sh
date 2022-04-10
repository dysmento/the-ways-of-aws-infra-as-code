#!/bin/bash
ROLE_NAME=demo-lambda-execution-role
FUNCTION_NAME=cli-lambda-demo

aws iam get-role --role-name $ROLE_NAME &> /dev/null
if  [[ $? -eq 0 ]]
then
    echo "Role exists."
else
aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://lambda-assume-role-policy.json
aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaRole
fi

aws lambda get-function --function-name $FUNCTION_NAME &> /dev/null
if [[ $? -eq 0 ]]
then
    echo "Function exists."
else
aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --role arn:aws:iam::708248210880:role/demo-lambda-execution-role \
    --zip fileb://app.zip \
    --runtime nodejs14.x \
    --handler index.handler

aws lambda create-function-url-config \
    --function-name $FUNCTION_NAME \
    --auth-type NONE
fi
