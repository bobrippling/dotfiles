syn match SlackMessage /^\v\d+-\d+-\d+ \d+:\d+:\d+: \S+: /
syn match SlackThread /^\v\d+-\d+-\d+ \d+:\d+:\d+: thread [^,]+, [^:]+:/
syn match SlackEdit  /^\v\d+-\d+-\d+ \d+:\d+:\d+: \S+ (---|\+\+\+) /
syn match SlackReact /^\v\d+-\d+-\d+ \d+:\d+:\d+: \S+ from \S+ \@ \S+'s message .*/

hi SlackMessage ctermfg=yellow
hi SlackThread ctermfg=darkblue
hi SlackEdit ctermfg=grey
hi link SlackReact Ignore
