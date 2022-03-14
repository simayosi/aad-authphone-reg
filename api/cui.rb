#!/usr/bin/env ruby
# frozen_string_literal: true

require './app'

unless ARGV.length > 1
  warn <<~USAGE
    Usage:
      command_line.rb check UPN
      command_line.rb commit {add|update} UPN phone_number phone_type
  USAGE
end

case ARGV[0]
when 'check'
  p AuthPhoneMethods.check(ARGV[1])
when 'commit'
  p AuthPhoneMethods.commit(ARGV[1], ARGV[2], ARGV[3], ARGV[4])
end
