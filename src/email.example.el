(use-package minimail
  :ensure t
  :config
  (setq mail-user-agent 'minimail
        minimail-accounts
        '((personal
           :mail-address "@gmail.com"
           :incoming-url "imaps://imap.gmail.com"
           :outgoing-url "smtps://smtp.gmail.com"))
        '((work
           :mail-address "@gmail.com"
           :incoming-url "imaps://imap.gmail.com"
           :outgoing-url "smtps://smtp.gmail.com"))
        '((uni
           :mail-address "@.edu"
           :incoming-url ""
           :outgoing-url ""))))

