## What It Does

- Fetches newly created, open, and closed issues from a specified GitHub repository within a defined time frame (e.g., yesterday, last week, etc.)
- Sends a formatted summary of these issues to a specified email address using Gmail API

<details>

<summary>GitHub Setup Guide</summary>

1. A GitHub account with a repository to monitor
2. Personal Access Token (PAT) with `repo` scope to access repository data
3. Repository details:
    - Owner (GitHub username or organization name)
    - Repository name
    - Personal Access Token (classic)

[Learn how to create a Personal Access Token (classic) on GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)

</details>

<details>

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

</details>

<details> 

<summary>Additional Configurations</summary>

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

</details>