configurable record {
    string token;
    string user;
    string repository;
} githubConfig = ?;

configurable record {
    string refreshToken;
    string clientId;
    string clientSecret;
    string refreshUrl = "https://oauth2.googleapis.com/token";
    string[] toEmails;
} googleConfig = ?;

configurable int maxIssuesToDisplay = 5;
configurable string timeZone = "Asia/Colombo";
configurable string? filterLabels = ();

enum TimeFrame {
    YESTERDAY = "Yesterday",
    LAST_WEEK = "Last Week",
    LAST_MONTH = "Last Month"
};

configurable TimeFrame timeFrame = LAST_WEEK;

