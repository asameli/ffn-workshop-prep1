# Workshop preparation
To deploy the Terraform script with authentication, you can use the Azure CLI to authenticate with Azure before running Terraform commands. Here's how you can do it:

1. Install the Azure CLI by following the instructions provided by Microsoft: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

2. Open a command prompt or terminal and sign in to Azure using the Azure CLI:

   ```shell
   az login
   ```

   This command will open a browser window where you can sign in with your Azure account credentials.

3. After successful authentication, you can run the Terraform commands. Open a command prompt or terminal in the directory where your Terraform script is located.

4. Initialize the Terraform configuration by running the following command:

   ```shell
   terraform init
   ```

5. Next, you can review the planned changes by running:

   ```shell
   terraform plan
   ```

   This will show you the resources that will be created, updated, or deleted based on your Terraform script.

6. Finally, apply the changes by running:

   ```shell
   terraform apply
   ```

   Terraform will prompt you to confirm the deployment. Enter `yes` to proceed with the deployment.

   Once the deployment is complete, Terraform will output the password for the created virtual machine. You can use this password to SSH into the VM.

Remember to clean up the resources when you no longer need them by running `terraform destroy` in the same directory where you ran `terraform apply`. This will remove all the resources created by Terraform.
