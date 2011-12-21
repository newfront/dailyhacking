#!/usr/bin/env ruby
require 'date'
=begin
You are given the following information, but you may prefer to do some research for yourself.
	•	1 Jan 1900 was a Monday.
	•	Thirty days has September, April, June and November. All the rest have thirty-one, Saving February alone, Which has twenty-eight, rain or shine. And on leap years, twenty-nine.
	•	A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?
=end

# start = january 1 1900 - Monday
# 30 days - September, April, June, November
# 31 days - January, March, May, July, August, October, December
# 28/ 29 - February / Leap Year
# leap year if year is evenly divisible by 4, unless it is a century and that is evenly divisible by 400

MONTHS = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]
DAYS_OF_WEEK = ["Sun","Mon","Tue","Wed","Thur","Fri","Sat"]
DAYS = [31,28,31,30,31,30,31,31,30,31,30,31]
LEAP_YEAR = 1

def is_leap_year(year)
  return Date.gregorian_leap?(year)
end

def calculate_days_months_year(start_year,end_year,start)
  @sundays = 0
  year = start_year
  start_day = start #monday
  @start = 1
  @max = DAYS_OF_WEEK.size-1
  while start_year <= end_year
    
    0.upto(MONTHS.size-1).each{|month|
      days = DAYS[month]
      days += 1 if (month) == 1 && is_leap_year(year)
      1.upto(days).each{|day|
        dow = DAYS_OF_WEEK[@start]
        d = Date.new(year,month+1,day)
        @sundays += 1 if d.day == 1 and d.cwday == 7
      }
    }
    start_year += 1
    year += 1
  end
  puts @sundays
end
unless ARGV[0].nil? and ARGV[1].nil?
  calculate_days_months_year(ARGV[0].to_i,ARGV[1].to_i,1)
else
  calculate_days_months_year(1901,2000,1)
end