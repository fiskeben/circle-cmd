require './tabulator'

data = [
  {
    build_num: 123,
    subject: "Some pretty long commit message that should have been shorter but we can't all be perfect",
    committer_name: 'Bruce Wayne',
    status: 'failed'
  },
  {
    build_num: 124,
    subject: 'Fixed previous commit',
    committer_name: 'Alfred',
    status: 'success'
  }
]

t = Tabulator.new(data)
    .with_headers(['Build num', 'Subject', 'By', 'Status'])
    .with_column_names([:build_num, :subject, :committer_name, :status])

puts "\n#{t}"
