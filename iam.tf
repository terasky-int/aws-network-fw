# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AWSLogDeliveryWrite",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "delivery.logs.amazonaws.com"
#             },
#             "Action": "s3:PutObject",
#             "Resource": "arn:aws:s3:::aws-vpc-flow-logs-<ACCOUNT-ID>/*",
#             "Condition": {
#                 "StringEquals": {
#                     "s3:x-amz-acl": "bucket-owner-full-control"
#                 }
#             }
#         },
#         {
#             "Sid": "AWSLogDeliveryAclCheck",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "delivery.logs.amazonaws.com"
#             },
#             "Action": "s3:GetBucketAcl",
#             "Resource": "arn:aws:s3:::aws-vpc-flow-logs-<ACCOUNT_ID>"
#         }
#     ]
# }