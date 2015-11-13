RSPEC_CMD = "mix test %s --color --tty"

@last_test = nil

def run_tests(test, force=false)
  test = @last_test unless File.exist?(test) or force or not @last_test
  if force || File.exist?(test)
    @last_test = test
    puts "-" * 80
    rspec_cmd = RSPEC_CMD % test
    puts rspec_cmd
    cmd = IO.popen("#{rspec_cmd} 2>&1")
    $stdout.write(cmd.getc) until cmd.eof?
  else
    puts "#{test} does not exist."
  end
end

def run_suite
  run_tests('test', :force)
end

watch('^test/.*_test\.exs') { |m| run_tests(m.to_s) }
watch('^web/(.*)\.ex'     ) { |m| run_tests("test/#{m[1]}_test.exs") }
watch('^lib/(.*)\.ex'     ) { |m| run_tests("test/lib/#{m[1]}_test.exs") }

Signal.trap('QUIT') { run_suite } # Ctrl-\
