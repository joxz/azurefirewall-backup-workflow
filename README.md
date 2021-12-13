# AzureFirewall Backup Workflow

## Backup Task

Backup a template of all AzureFirewalls and policies shown in [https://aidanfinn.com/?p=21553](https://aidanfinn.com/?p=21553)

Backups are commited back to the git repository by github actions

:warning: Use a private repo or just modify the workflow to upload the files to a secure location :warning: (e.g. [Azure Blob Storage Upload](https://github.com/marketplace/actions/azure-blob-storage-upload))

The workflow is located in `.github/workflows/backup-fws.yml` and will loop through all subscriptions in the given tenant. Please use a service principle with the appropriate privileges for that.

## Credentials

See [https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md](https://github.com/Azure/actions-workflow-samples/blob/master/assets/create-secrets-for-GitHub-workflows.md)

## Teams Webhook

Set Teams Webhook URL as a Github secret called `MS_TEAMS_WEBHOOK_URL`

## Restore

```powershell
New-AzResourceGroupDeployment -name "FirewallRestoreJob" -ResourceGroupName "MyVnetRg" -TemplateFile ".\MyFirewallBackup.json"
```

## Powershell Script

Powershell script for local testing included (`azfw-backup.ps1`)
Uncomment first lines for local testing of the script

Set the following environment variables for credentials:

```
APP_ID=<GUID>
SECRET=<clientsecret>
TENANT_ID=<GUID>
```

## Schedule

Modify `.github/workflows/backup-fws.yml` to run the workflow every Mon-Fri at 7:00 UTC

```
on:
  schedule:
    - cron: "0 7 * * 1-5"
  workflow_dispatch:
```
