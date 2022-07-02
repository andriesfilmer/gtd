require ["fileinto", "vacation", "variables"];

# Move spam to spam folder
if header :contains "X-Spam-Flag" "YES" {
  fileinto "INBOX.Spam";
  # Stop here so that we do not reply on spams
  stop;
}

if header :matches "Subject" "*" {
        set "subjwas" "${1}";
}
vacation
  # Reply at most once a day to a same sender
  :days 1
  :subject "Out of office reply: ${subjwas}"
"I'm out of office, please contact Joan Doe instead.
Best regards
John Doe";
