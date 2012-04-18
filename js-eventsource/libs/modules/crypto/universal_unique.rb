#!/usr/bin/env ruby

=begin
  generate universally unique id
  version 4 (random)
  xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  where x is any hexidecimal digit
  where y is 8,9,A or B
=end
require 'digest/md5'

module Crypto
  module Universal
    
    class Unique
      
      attr_accessor :unique
      
      # generate unique salt
      def initialize(salt=nil,params={})
        @salt = salt.nil? ? generate_salt : salt
        generate_randoms
        self.unique = generate_unique
      end
      
      # generate random alpha numerics
      def generate_randoms
        @alphas = ("a".."z").collect{|alpha| alpha }
        @numerics = (1..9).collect{|num| num }
      end
      
      def generate_random_alpha_numeric
        tmp = rand(2)
        if tmp == 0
          @val = @alphas[rand(@alphas.size)]
        else
          @val = @numerics[rand(@numerics.size)]
        end
        #puts @val.to_s
        return  @val
      end
      
      def generate_unique
        #x is hexidecimal
        yvals = [8,9,"A","B"]
        # ........ - .... - 4... - yvals(rand(yvals.length))...-............
        chunks = 1.upto(8).collect{|i| generate_random_alpha_numeric.to_s }.join("")
        chunks << "-"
        chunks << 1.upto(4).collect{|i| generate_random_alpha_numeric.to_s }.join("")
        chunks << "-4"
        chunks << 1.upto(3).collect{|i| generate_random_alpha_numeric.to_s }.join("")
        chunks << "-#{yvals[rand(yvals.size)]}"
        chunks << 1.upto(3).collect{|i| generate_random_alpha_numeric.to_s }.join("")
        chunks << "-"
        chunks << 1.upto(12).collect{|i| generate_random_alpha_numeric.to_s }.join("")
        self.unique = chunks
      end
      
      def generate_salt
        return Digest::MD5.hexdigest(rand(9999).to_s)
      end
      
    end
    
  end
end