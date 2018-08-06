# interns infra

Creates multiple IAM users w/ Cloud9 development environments for interns, workshops, etc.

## Create

```
terraform plan
terraform apply
```

## Destroy

```terraform destroy```

## Passwords

terraform encrypts passwords with gpg or keystore by default. Output decrypted passwords with the following command:

```
terraform output passwords |  while read line ; do echo $line | base64 -D | keybase pgp decrypt; echo ; done
```

## Notes

Beware of EC2 limits (max number of instances) and Cloud9 limits (max environments).
