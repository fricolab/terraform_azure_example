# Terraform Azure Example

## How to use

Set variables for your environment and backend inside `config` folder. This project assume that you will use a remote state for your Terraform project. This bucket must exist before launching Terraform.

Credentials to Azure provider are suposed to be declared as Environment Variables:

```
$ export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
$ export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
$ export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
$ export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

Jenkins machine is suposed to have Managed Identity in order to login to Azure and also be able to retrieve some secret values from Azure Key Vault.
