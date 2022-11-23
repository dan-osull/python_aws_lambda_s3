AWS Lambda / S3 / Terraform image processing infrastructure
==

Working proof-of-concept:

- add image file to S3 input bucket -> 
- automatically trigger Lambda function -> 
- process image (invert colors example) ->
- save to S3 output bucket

Deploy with:

    cd terraform
    terraform apply

Current limitations
--

1.  Python packages are simply saved to `terraform/src/package`:

        pip install --target ./package pillow
    
2.  `terraform/src/lambda.py` contains hardcoded `TARGET_S3_BUCKET`