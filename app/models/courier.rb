class Postoffice < ActionMailer::Base
  def message(recipients, subject, message, inspect='')
    recipients  recipients
    subject     subject
    sent_on     Time.now
    body        :message => message, :inspect => inspect
    content_type 'text/html'
  end
end