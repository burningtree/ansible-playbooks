# disable welcome message
set fish_greeting ""

# remove useless shell process name from terminal window
function fish_title
  pwd
end
