#!/usr/local/ruby19/bin/ruby

# Collaborative Filtering
# = Create a hash table of movie critics and ratings
# * Based off of the Python Code from "Collective Intelligence" by Toby Segaran (O'Reilly)


class SimDistance

    @data_set = {}
    
    # Initialize your dataset
    def initialize(data_set)
        # require a Hash
        @data_set = data_set if data_set.is_a? Hash
    end
    
    # take a peek at what you are working with
    def view_data_set
        if @data_set.is_a? Hash
            puts "Dataset: #{@data_set.inspect}"
        end
    end
    
    def sim_distance(prefs,person1,person2)
        # Get the list of shared_items

        # populate your shared items in a hash
        si={}

        # @critics["Lacey Haines"].each {|x| puts "Items: #{x.inspect}"}
        # Let's loop through person1 and test against each item in person2, find the distance between the two
        prefs[person1].each do |item_a_key,item_a_value| 
            prefs[person2].each do |item_b_key,item_b_value| 
                if item_a_key == item_b_key
                    # Same Movie, keep name of movie as key, and value of 1
                    si[item_a_key] = 1
                end
            end
        end
        
        # If no similar prefs, return
        return if si.count == 0
        
        # Create a Math sum Proc
        sum = lambda{|target,value| target ? target+value : value}
        #si.each {|key,value| puts "Numbers: #{prefs[person1][key]} | #{prefs[person2][key]}" if value }
        
        # Show Sum of two prefs
        
        # x1**2 - x2**2
        sum_of_squares = 0
        si.each {|key,value| sum_of_squares += (prefs[person1][key] - prefs[person2][key])**2 if value }
        
        return 1/(1+Math.sqrt(sum_of_squares))
        
    end
        
end

class SimPearson < SimDistance
    
    def sim_pearson(prefs,p1,p2)
    
        si = {}
        
        prefs[p1].each do |item_a_key,item_a_value| 
            prefs[p2].each do |item_b_key,item_b_value| 
                if item_a_key == item_b_key
                    # Same Movie, keep name of movie as key, and value of 1
                    si[item_a_key] = 1
                end
            end
        end
        
        # Find the length of the Shared Items
        n = si.count
        
        # If no ratings in common, return 0
        
        return 0 if n == 0
        
        sum1 = 0
        sum2 = 0
        sum1Sq = 0
        sum2Sq = 0
        pSum = 0
        
        si.each {|key,val| sum1 += prefs[p1][key]}
        si.each {|key,val| sum2 += prefs[p2][key]}
        
        si.each {|key,val| sum1Sq += prefs[p1][key]**2}
        si.each {|key,val| sum2Sq += prefs[p2][key]**2}
        
        si.each {|key,val| pSum += prefs[p1][key]*prefs[p2][key]}
        
        #puts "sum1: #{sum1}  sum2: #{sum2} p1: #{sum1Sq} p2: #{sum2Sq} pSum: #{pSum}"
        
        # Calculate Pearson score
        
        num = pSum-(sum1*sum2/n)
        
        den = Math.sqrt((sum1Sq - (sum1**2)/n)*(sum2Sq-(sum2**2)/n))
        
        return 0 if den == 0
        
        r = num/den
        
        return r
    
    end
end


@critics = {
    'Scott Haines'=>{'Snakes on a Plane'=>2.0,'Just my Luck'=>2.5,'Lord of the Rings'=>5.0},
    'Lacey Haines'=>{'Snakes on a Plane'=>3.0,'Just my Luck'=>4.5,'Lord of the Rings'=>2.0},
    'Joe Smith'=>{'Snakes on a Plane'=>4.0,'Just my Luck'=>2.5,'Lord of the Rings'=>3.0},
    'Harold Cohen'=>{'Snakes on a Plane'=>1.0,'Just my Luck'=>1.5,'Lord of the Rings'=>5.0}
}

# How do we get to the data? Read the Hash
#puts @critics['Scott Haines']['Snakes on a Plane']

# Finding Similar Users
# * Similar Users are closest to each other when compared in across a preferences axis (x,y)
# * Use the Math Module in Ruby to compute the distance to each preference
# * Think Geometry two points in space (x2-x1,y2-y1) distance
# Math.hypot(5.0-3.0,1.0-2.0)


#critics = SimDistance.new(@critics)
#critics.view_data_set

critics = SimPearson.new(@critics)
#critics.view_data_set
similarity = critics.sim_pearson(@critics,"Lacey Haines","Scott Haines")
#similarity = critics.sim_distance(@critics,"Lacey Haines","Scott Haines")
puts "Similarity? : #{similarity}"