require "pony"

def mailer(mail_subject, recipient, file)
  Pony.options = {
    subject:     mail_subject,
    via:         :smtp,
    headers:     { "Content-Type" => "text/html" },
    body:        file,
    via_options: {
      address:              "smtp.gmail.com",
      port:                 "587",
      enable_starttls_auto: true,
      user_name:            ENV["EMAIL"],
      password:             ENV["EMAIL_PASS"],
      authentication:       :plain, # :plain, :login, :cram_md5, no auth by default
      domain:               "localhost.localdomain",
    },
  }
  Pony.mail(to: recipient)
end
