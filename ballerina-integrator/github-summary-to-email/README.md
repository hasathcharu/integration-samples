# Salesforce to Google Sheets Integration

## Description

This integration fetches the latest issues from a specified GitHub repository and sends a summary of those issues via email using GMail.

### What It Does

- Fetches newly created, open, and closed issues from a specified GitHub repository within a defined time frame (e.g., yesterday, last week, etc.)
- Sends a formatted summary of these issues to a specified email address using Gmail API

## Prerequisites

Before running this integration, you need:

### GitHub Setup

1. A GitHub account with a repository to monitor
2. Personal Access Token (PAT) with `repo` scope to access repository data
3. Repository details:
    - Owner (GitHub username or organization name)
    - Repository name
    - Personal Access Token (classic)

[Learn how to create a Personal Access Token (classic) on GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

### GMail Setup

<summary>GMail Setup Guide</summary>

1. A Google Cloud project with GMail API v1 enabled
2. OAuth2 credentials:
  - Client ID
  - Client Secret
  - Refresh Token
  - Refresh URL
3. Scopes Required
  - `https://www.googleapis.com/auth/gmail.send`

This integration uses refresh token flow for auth. [Learn how to Develop on Google Workspace](https://developers.google.com/workspace/guides/get-started).

## Configuration

The following configurations are required to connect to GitHub and GMail.

### GitHub Configurations

- `token` - Your GitHub Personal Access Token (classic)
- `owner` - The owner of the GitHub repository (username or organization)
- `repository` - The name of the GitHub repository

### GMail Configurations

- `refreshToken` - Your Google OAuth2 refresh token
- `clientId` - Your Google OAuth2 client ID
- `clientSecret` - Your Google OAuth2 client secret
- `refreshUrl` - The URL to refresh the access token (default `https://oauth2.googleapis.com/token`)
- `toEmails` - Array of email addresses to send the summary to

### Additional Configurations
1. `timeZone`
    - Time zone to be used for showing time-related information in the email. Example: `America/New_York`.
2. `timeFrame`:
    - Time frame to filter issues. Possible values:
        - `YESTERDAY`
        - `LAST_WEEK` (default)
        - `LAST_MONTH`
3. `filterLabels`
    - Comma-separated list of labels to filter issues. Only issues with at least one of these labels will be included in the summary. Example: `bug,enhancement`.
4. `maxIssuesToDisplay`
    - Maximum number of issues to display in the email summary for each category (new, open, closed). Default is 5.

## Deploying on **Devant**

1. Sign in to your Devant account.
2. Create a new Integration and follow instructions in [Devant Documentation](https://wso2.com/devant/docs/references/import-a-repository/) to import this repository.
3. Select the **Technology** as `WSO2 Integrator: BI`.
4. Choose the **Integration** Type as `Automation` and click **Create**.
5. Once the build is successful, click **Configure to Continue** and set up the required environment variables for GitHub and GMail credentials.
6. Click **Schedule** to schedule the automation.
7. In the **BY INTERVAL** tab, select **Week** from the dropdown.
8. Set the desired day and time for the integration to run weekly and click **Update**.
9. Once tested, you may promote the integration to production. Make sure to set the relevant environment variables in the production environment as well.