#!/usr/bin/env ruby

#require 'rbconfig'
#if RbConfig::CONFIG['host_os'] =~ /linux/
#  File.open('/dev/tty', 'a') do |f|
#    f.print "\ec"
#  end
#end

(1..100).each do |i|
  if (i % 3).zero? && (i % 5).zero?
    puts 'FizzBuzz'
  elsif (i % 3).zero?
    puts 'Fizz'
  elsif (i % 5).zero?
    puts 'Buzz'
  else
    puts i
  end
end
