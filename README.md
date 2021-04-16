# Introduction

This github repository provide an example of an Azure Function that subscribe to events from Azure Storage and insert the event details in a SQL Database.

<img src='https://github.com/hugogirard/eventGridDemo/blob/main/diagram/architecture.png?raw=true' />

The sample create 3 storage container and one filter in the Event Grid Subscription.  The subscriber will listen only for the file deployed in customer and jobs container.

# Deploy sample

## Create Github Secrets

First, fork the repository.

Next create those Github secrets.

| Name | Value |
|------|-------|
|ADMIN_PASSWORD|The password for the SQL Database|
|ADMIN_USERNAME|The username for the SQL Database|
|PA_TOKEN|Github Personal Access Token, need the repo -> public_repo access.|
 SP_AZURE_CREDENTIALS| Your Service Principal Credential for Azure.  https://github.com/marketplace/actions/azure-login#configure-deployment-credentials|
 |SUBSCRIPTION_ID| The ID of the subscription where the resources will be deployed

 ## Run the first Github action

Now go to the Actions menu, select Deploy infrastructure as code and click the run workflow green button.

<img src='https://github.com/hugogirard/eventGridDemo/blob/main/diagram/runflow1.png?raw=true' />

This action will create all necessary Azure resources and needed secrets for the next Github Action.

## Run the second Github Action

Now repeat the previous step but run the **Deploy Logger Function**.

Once is done you can test the Event Grid.

## Execute the SQL Script

You have a SQL script called **createTable.sql**, connect to your SQL Database and run the script, this will create the table log needed for the Azure Function.

# Test the Event Grid

Upload a file in customer or jobs container, once is done do this SQL query -> ` SELECT * FROM LOG `

You should see the details of the uploaded file.  If you try to upload a file in the tmp folder you won't see any record in the table **log**