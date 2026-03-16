(use-package minimail
  :ensure t
  :config (setq
    mail-user-agent 'minimail
    minimail-accounts '(
      (personal
        :mail-address "@gmail.com"
        :incoming-url "imaps://imap.gmail.com"
        :outgoing-url "smtps://smtp.gmail.com")
      (old
        :mail-address "@gmail.com"
        :incoming-url "imaps://imap.gmail.com"
        :outgoing-url "smtps://smtp.gmail.com")
      (online
        :mail-address "@gmail.com"
        :incoming-url "imaps://imap.gmail.com"
        :outgoing-url "smtps://smtp.gmail.com")
      (uni
        :mail-address "@.edu"
        :incoming-url "imaps://username@.edu"
        :outgoing-url "smtp://username@.edu"))))

