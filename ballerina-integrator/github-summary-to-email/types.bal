import ballerinax/github;
import ballerina/time;
type GitHubSummary record {
    string orgName;
    string repositoryName;
    int openIssuesCount;
    int closedIssuesCount;
    int newIssuesCount;
    github:IssueSearchResultItem[] openIssues;
    github:IssueSearchResultItem[] closedIssues;
    github:IssueSearchResultItem[] newIssues;
    time:Utc time;
};

type GitHubLabel record {
    int id?;
    string node_id?; 
    string url?; 
    string name?;
    string? description?; 
    string? color?; 
    boolean default?;
};
