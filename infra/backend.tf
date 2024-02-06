terraform {
    backend "s3" {
        bucket = "devsec-zomato"
        key = "my-terrform-environment/main"
        region = "us-east-1"
        dynamodb_table = "terraform_dynamo_db"
    }
}

