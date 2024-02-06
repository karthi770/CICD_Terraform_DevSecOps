output "websiteendpoint" {
    value = aws_s3_bucket.mybucket.website_endpoint
  
}

output "public_ip" {
    value= aws_instance.website.public_ip
}