# interns infra

Creates multiple IAM users w/ Cloud9 development environments for interns, workshops, etc.

## Config

terraform.tfvars

```HCL
account = MY_AWS_ACCOUNT_ID
num_accounts = NUMBER_OF_ACCOUNTS
pgp = KEYBASE_OR_GPG_KEY
```

## Create

```
terraform plan
terraform apply
```

## Destroy

```
terraform destroy
```


## Passwords

terraform encrypts passwords with gpg or keystore by default.

set `gpg` variable

Output decrypted passwords with the following command:

### if using keybase
```
terraform output passwords |  while read line ; do echo $line | base64 -D | keybase pgp decrypt; echo ; done
```
### if using gpg
```
terraform output passwords |  while read line ; do echo $line | base64 -D | gpg -d -q; echo ; done
```

## Notes

Beware of EC2 limits (max number of instances) and Cloud9 limits (max environments).
