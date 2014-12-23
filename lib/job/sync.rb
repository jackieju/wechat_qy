require "sl.rb"

def sync(name)
    p "sync #{name}"
    # $slcookie = sl_login
    Invoice.list(name, false)
end