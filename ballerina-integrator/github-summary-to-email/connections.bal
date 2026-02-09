import ballerinax/github;
import ballerinax/googleapis.gmail;


final github:Client githubClient = check new ({
    auth: {
        token: githubConfig.token
    }
});

final gmail:Client gmailClient = check new ({
    auth: {
        refreshToken: googleConfig.refreshToken,
        clientId: googleConfig.clientId,
        clientSecret: googleConfig.clientSecret,
        refreshUrl: googleConfig.refreshUrl
    }
});
