#!/usr/bin/env ruby

require_relative "../config/environment"
require "tty-prompt"
require_relative "lib/cli_interface"

begin
  CLIInterface.new.run if __FILE__ == $PROGRAM_NAME
rescue TTY::Reader::InputInterrupt, Interrupt
  puts "\n\n👋 Goodbye! Happy studying!"
  exit(0)
end
