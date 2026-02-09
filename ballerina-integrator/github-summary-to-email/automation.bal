import ballerina/log;
import ballerinax/github;
import ballerina/time;
import ballerinax/googleapis.gmail;

time:Utc currentDate = time:utcNow();
int secondsInDay = 24 * 60 * 60;
int secondsInWeek = secondsInDay * 7;
int secondsInMonth = secondsInDay * 30;

public function main() returns error? {
    do {
        int secondsToSubtract = 0;

        match timeFrame {
            YESTERDAY => {
                secondsToSubtract = secondsInDay;
            }
            LAST_WEEK => {
                secondsToSubtract = secondsInWeek;
            }
            LAST_MONTH => {
                secondsToSubtract = secondsInMonth;
            }
        }

        time:Utc fromTime = time:utcAddSeconds(currentDate, secondsToSubtract * -1);

        log:printInfo("Fetching GitHub issues updated since " + check getFormattedTimeStamp(fromTime));

        string fromTimeString = getIso8601Date(time:utcToCivil(fromTime));

        string newIssuesQuery = string `repo:${githubConfig.user}/${githubConfig.repository} is:issue created:>${fromTimeString}`;
        github:IssueSearchResultItemResponse? newIssues = check githubClient->/search/issues(q = newIssuesQuery, perPage = 100);
        string closedIssuesQuery = string `repo:${githubConfig.user}/${githubConfig.repository} is:issue state:closed closed:>${fromTimeString}`;
        github:IssueSearchResultItemResponse? closedIssues = check githubClient->/search/issues(q = closedIssuesQuery, perPage = 100);
        string openIssuesQuery = string `repo:${githubConfig.user}/${githubConfig.repository} is:issue state:open`;
        github:IssueSearchResultItemResponse? openIssues = check githubClient->/search/issues(q = openIssuesQuery, perPage = 100);

        
        GitHubSummary summary = {
            openIssuesCount: openIssues != () ? openIssues.totalCount : 0,
            closedIssuesCount: closedIssues != () ? closedIssues.totalCount : 0,
            newIssuesCount: newIssues != () ? newIssues.totalCount : 0,
            openIssues: openIssues != () ? (openIssues.items.length() > maxIssuesToDisplay ? openIssues.items.slice(0, maxIssuesToDisplay) : openIssues.items) : [],
            closedIssues: closedIssues != () ? (closedIssues.items.length() > maxIssuesToDisplay ? closedIssues.items.slice(0, maxIssuesToDisplay) : closedIssues.items) : [],
            newIssues: newIssues != () ? (newIssues.items.length() > maxIssuesToDisplay ? newIssues.items.slice(0, maxIssuesToDisplay) : newIssues.items) : [],
            orgName: githubConfig.user,
            repositoryName: githubConfig.repository,
            time: currentDate
        };

        gmail:MessageRequest emailMessage = {
            to: googleConfig.toEmails,
            subject: string `Issue summary for ${githubConfig.user}/${githubConfig.repository} - ${check getFormattedTimeStamp(currentDate)}`,
            bodyInHtml: check getEmailBody(summary)
        };

        _ = check gmailClient->/users/me/messages/send.post(emailMessage);

        log:printInfo("GitHub summary email sent successfully.");

    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
