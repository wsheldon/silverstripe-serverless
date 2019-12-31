## Overview

This is my proof of concept running SilverStripe 4 on AWS Serverless stack using [Bref](https://bref.sh).  

## Requirements ##

* AWS Account
* Create and set AWS Access Key/Secret in ~/.aws/credentials
* Choose domain, i.e. wilsonsheldon.name
* Purchase/Import SSL cert in AWS Certificate Manager
* Setup RDS MySQL DB.  I choose free tier, db.t2.micro.  For now, you'll need to go into the security group and open port 3306 up to the world.  RDS lives inside your default VPC, whereas Lambda does not, by default.  I have a TODO to tighten this up.
* Ensure PHP / Composer installed locally
* [Serverless](https://serverless.com)
* [NPM](https://www.npmjs.com/get-npm)

## Installation ##

Step 1. Clone or download Code
```sh
git clone https://github.com/wsheldon/silverstripe-serverless.git
cd silverstripe-serverless
composer install
```

Step 2.  Choose domain name and set service and domain in serverless.yml, i.e.
```sh
service: wilsonsheldon

custom:
  domain: 'wilsonsheldon.name'
```

Step 3.  Set SSL cert ARN on/around line 81 in serverless.yml, i.e
```sh
AcmCertificateArn: 'arn:aws:acm:us-east-1:YYYY:certificate/XXX'
```

Step 4. Configure AWS Parameter Store.  Note, session key is any sufficiently indeterminable string according the docs.  For paramater, prefix I used the Serverless service name 'wilsonsheldon' for consistency.
```sh
aws ssm put-parameter --region us-east-1 --name '/SERVERLESS SERVICE NAME/ss_session_key'  --type String --value '##########';
aws ssm put-parameter --region us-east-1 --name '/SERVERLESS SERVICE NAME/ss_database_name'  --type String --value '##########';
aws ssm put-parameter --region us-east-1 --name '/SERVERLESS SERVICE NAME/ss_database_password'  --type String --value '##########';
aws ssm put-parameter --region us-east-1 --name '/SERVERLESS SERVICE NAME/ss_database_server'  --type String --value '##########';
aws ssm put-parameter --region us-east-1 --name '/SERVERLESS SERVICE NAME/ss_database_username'  --type String --value '##########';
```

Step 5. Serverless Deploy.  Note, this will create the S3 bucket named same as your domain.  The first time you run this it will take 10-15 minutes while CDN is enabled.  
```sh
sls deploy
```

Step 6.  Hopefully Step 5 succeeded can now sync assets
```sh
composer vendor-expose copy
aws s3 sync public/_resources s3://YOUR DOMAIN NAME/_resources
```

Step 7.  Because Lambda has no local storage but the CMS needs the TinyMCE config, we need to manually copy to S3.  The way I did this was to login to admin, see what the hash of the file was (even though it was throwing 404), take my local version, change the base URL and upload to S3, i.e mine was
```sh
assets/_tinymce/tinymce-cms-01d3d5719a.js
```

## Notes ##
Note, the only change I made to SS default code was in public/index.php on line 7
```sh
define('ASSETS_PATH', '/tmp');
```

I have a TODO to see if there's a better way.

Also note, future deployments will use Git branch to set API Gateway stage, so dev/prod or develop/master, etc.

## TODO / Roadmap ##

* Research better way to define ASSETS_PATH
* Research better way to get TinyMCE JS assets to S3
* Setup SS Static Publishing and serve HTML directly from CloudFront.  This will improve performance and reduce number of Lambda executions.  In meantime, could set CloudFront to cache public pages for X minutes.
* Finish CI/CD with CodePipeline/CodeBuild.  AWS CodeBuld PHP 7.3 runtime is currently missing PHP 'intl' extension so Composer won't run.
* Explore running Lambda in VPC for greater security.

## Links ##

 * [SilverStripe](https://www.silverstripe.org)
 * [SilverStripe Hybrid Sessions](https://github.com/silverstripe/silverstripe-hybridsessions)
 * [Bref](https://bref.sh)
