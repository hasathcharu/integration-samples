import ballerina/time;
import ballerinax/github;

function getFormattedTimeStamp(time:Utc time) returns string|error {
    time:Zone? zone = time:getZone(timeZone);
    if zone is time:Zone {
        time:Civil currentTime = zone.utcToCivil(time);
        return string
            `${currentTime.year.toString()}-${currentTime.month.toString().padZero(2)}-${currentTime.day.toString().padZero(2)} ${currentTime.hour.toString().padZero(2)}:${currentTime.minute.toString().padZero(2)}`;
    }
    return error("Invalid time zone");
}

function getIso8601Date(time:Civil time) returns string {
    return string
        `${time.year.toString()}-${time.month.toString().padZero(2)}-${time.day.toString().padZero(2)}`;
}

function getEmailBody(GitHubSummary issueSummary) returns string|error {
    return string `
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta name="x-apple-disable-message-reformatting">
        <title>GitHub Issue Summary</title>
        <style type="text/css">
            /* Client-specific resets */
            table, td { border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
            img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic; }
            body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif; -webkit-text-size-adjust: 100%; }
            
            /* Mobile Styles */
            @media screen and (max-width: 600px) {
                .email-container { width: 100% !important; margin: auto !important; }
                .stack-column, .stack-column-center { display: block !important; width: 100% !important; max-width: 100% !important; direction: ltr !important; }
                .stack-column-center { text-align: center !important; }
                .center-on-mobile { text-align: center !important; }
                .mobile-pad { padding-left: 20px !important; padding-right: 20px !important; }
                .hide-on-mobile { display: none !important; }
            }
        </style>
    </head>
    <body width="100%" style="margin: 0; padding: 0 !important; mso-line-height-rule: exactly; background-color: #f6f8fa;">
        <center style="width: 100%; background-color: #f6f8fa;">
        
            <div style="display: none; font-size: 1px; line-height: 1px; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden; mso-hide: all; font-family: sans-serif;">
                GitHub Issue Summary for ${issueSummary.orgName} / ${issueSummary.repositoryName}: ${issueSummary.openIssuesCount} Open, ${issueSummary.newIssuesCount} New, ${issueSummary.closedIssuesCount} Closed
            </div>

            <table align="center" role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" style="margin: auto;" class="email-container">
                
                <tr><td height="40" style="font-size: 0; line-height: 0;">&nbsp;</td></tr>

                <tr>
                    <td style="background-color: #24292e; padding: 30px; border-radius: 6px 6px 0 0; text-align: left;">
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td style="font-family: sans-serif; font-size: 20px; font-weight: 600; color: #ffffff; line-height: 24px;">
                                    <span style="color: #a3aab1;">${issueSummary.orgName} /</span> ${issueSummary.repositoryName}
                                    <div style="font-size: 14px; color: #d1d5da; font-weight: 400; margin-top: 5px;">Summary for ${timeFrame} • ${check getFormattedTimeStamp(issueSummary.time)}</div>
                                    ${filterLabels is string ? string `<div style="font-size: 14px; color: #d1d5da; font-weight: 400; margin-top: 5px;">Filtered by labels: ${filterLabels ?: ""}</div>` : ""}
                                </td>
                                <td width="60" align="right" valign="middle">
                                    <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" width="48" height="48" alt="GitHub" style="display: block; border: 0; border-radius: 50%;">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td style="background-color: #ffffff; padding: 20px 0; border-bottom: 1px solid #e1e4e8; border-left: 1px solid #e1e4e8; border-right: 1px solid #e1e4e8;">
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td width="33%" align="center" valign="top" style="font-family: sans-serif;">
                                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td align="center" style="font-size: 24px; font-weight: bold; color: #24292e;">${issueSummary.openIssuesCount}</td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="font-size: 11px; color: #586069; text-transform: uppercase; letter-spacing: 0.5px; padding-top: 5px;">Open</td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="33%" align="center" valign="top" style="font-family: sans-serif; border-left: 1px solid #eeeeee; border-right: 1px solid #eeeeee;">
                                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td align="center" style="font-size: 24px; font-weight: bold; color: #2ea44f;">${issueSummary.newIssuesCount > 0 ? "+" : ""}${issueSummary.newIssuesCount}</td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="font-size: 11px; color: #586069; text-transform: uppercase; letter-spacing: 0.5px; padding-top: 5px;">New</td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="33%" align="center" valign="top" style="font-family: sans-serif;">
                                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                        <tr>
                                            <td align="center" style="font-size: 24px; font-weight: bold; color: #cb2431;">${issueSummary.closedIssuesCount > 0 ? "-" : ""}${issueSummary.closedIssuesCount}</td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="font-size: 11px; color: #586069; text-transform: uppercase; letter-spacing: 0.5px; padding-top: 5px;">Closed</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                ${check getHtmlFormattedIssues(issueSummary.newIssues, "New")}
                ${getAllIssuesLink("New", ())}
                ${check getHtmlFormattedIssues(issueSummary.closedIssues, "Closed")}
                ${getAllIssuesLink("Closed", "?q=is%3Aissue%20state%3Aclosed")}

                <tr>
                    <td style="padding: 30px; text-align: center; font-family: sans-serif; font-size: 12px; color: #6a737d; line-height: 18px;">
                        <p style="margin: 0;">You are receiving this because you subscribed to updates for <strong>${issueSummary.orgName}/${issueSummary.repositoryName}</strong>.</p>
                    </td>
                </tr>
                
                <tr><td height="40" style="font-size: 0; line-height: 0;">&nbsp;</td></tr>

            </table>
            
            </center>
    </body>
    </html>
    `;
}

function getHtmlFormattedIssues(github:IssueSearchResultItem[] issues, string section) returns string|error {
    string formattedIssues = "";
    if issues.length() == 0 {
        return formattedIssues;
    }
    formattedIssues += string `
        <tr>
            <td style="background-color: #ffffff; padding: 20px 30px 10px 30px; border-left: 1px solid #e1e4e8; border-right: 1px solid #e1e4e8; font-family: sans-serif; font-size: 16px; font-weight: 600; color: #24292e;">
                ${section} Issues
            </td>
        </tr>
        <tr>
            <td style="background-color: #ffffff; padding: 0 30px; border-left: 1px solid #e1e4e8; border-right: 1px solid #e1e4e8;" class="mobile-pad">
    `;
    foreach github:IssueSearchResultItem issue in issues {
        string issueUpdatedTime = check getFormattedTimeStamp(check time:utcFromString(issue.updatedAt));
        formattedIssues += string `
            <a href="${issue.htmlUrl}" style="text-decoration: none;">
                <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="border-bottom: 1px solid #e1e4e8;">
                    <tr>
                        <td valign="top" width="24" style="padding: 24px 10px 24px 0;">
                            <span style="color: ${issue.state == "open" ? "#2ea44f" : "#d73a49"}; font-size: 20px;">◎</span>
                        </td>
                        <td valign="middle" style="padding: 24px 0; font-family: sans-serif;">
                            <a href="#" style="text-decoration: none; color: #24292e; font-size: 16px; font-weight: 600; line-height: 20px;">${issue.title}</a>
                            <div style="font-size: 12px; color: #586069; margin-top: 4px; line-height: 18px;">
                                #${issue.number} by <span style="color: #24292e;">${issue.user?.login ?: ""}</span> • ${issueUpdatedTime}
                            </div>
                            ${getHtmlFormattedLabels(issue)}
                        </td>
                    </tr>
                </table>
            </a>
        `;
    }
    formattedIssues += string `
            </td>
        </tr>
    `;
    return formattedIssues;
}

function getAllIssuesLink(string section, string? query) returns string {
    return string `
        <tr>
            <td style="background-color: #ffffff; padding: 30px; border-left: 1px solid #e1e4e8; border-right: 1px solid #e1e4e8; border-bottom: 1px solid #e1e4e8; border-radius: 0 0 6px 6px;">
                <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                        <td align="center">
                            <div>
                                <a href="https://github.com/${githubConfig.user}/${githubConfig.repository}/issues${query ?: ""}" style="background-color:transparent;color:#586069;display:inline-block;font-family:sans-serif;font-size:13px;font-weight:500;line-height:32px;text-align:center;text-decoration:none;border:1px solid #e1e4e8;padding:0 16px;-webkit-text-size-adjust:none;border-radius:6px;">View All ${section} Issues</a>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
         </tr>
    `;
}


function getHtmlFormattedLabels(github:IssueSearchResultItem issue) returns string {
    string formattedLabels = "";
    int numMaxLabelsToShow = 5;
    github:IssueSearchResultItemLabels[] labels = issue.labels;
    if issue.labels.length() == 0 {
        return formattedLabels;
    }
    if issue.labels.length() > numMaxLabelsToShow {
        labels = issue.labels.slice(0, numMaxLabelsToShow);
    }
    formattedLabels += string `<table role="presentation" cellspacing="0" cellpadding="0" border="0" style="margin-top: 6px;">
                            <tr>`;
    foreach github:IssueSearchResultItemLabels label in labels {
        string backgroundColor = "#6a6a6a";
        string labelName = "";
        if label is record {int id?; string node_id?; string url?; string name?; string? description?; string? color?; boolean default?;} {
            backgroundColor = label?.color ?: backgroundColor;
            labelName = label.name ?: labelName;
        }
        formattedLabels += string `<td style="background-color: #${backgroundColor}; color: ${getContrastTextColor(backgroundColor)}; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 12px; font-family: sans-serif;">${labelName}</td>`;
        formattedLabels += string `<td width="5"></td>`;
    }
    if issue.labels.length() > numMaxLabelsToShow {
        formattedLabels += string `<td style="background-color: #e1e4e8; color: #24292e; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 12px; font-family: sans-serif;">+${issue.labels.length() - numMaxLabelsToShow}</td>`;
    }
    formattedLabels += string `</tr></table>`;
    return formattedLabels;
}

function getContrastTextColor(string hexColor) returns string {
    int|error r = int:fromHexString(hexColor.substring(0, 2));
    int|error g = int:fromHexString(hexColor.substring(2, 4));
    int|error b = int:fromHexString(hexColor.substring(4, 6));

    if r is error || g is error || b is error {
        return "#000000"; // default to black if color parsing fails
    }

    float brightness = (r * 299 + g * 587 + b * 114) / 1000;

    if brightness > 125.0 {
        return "#000000"; // dark text for light backgrounds
    } else {
        return "#ffffff"; // light text for dark backgrounds
    }
}
