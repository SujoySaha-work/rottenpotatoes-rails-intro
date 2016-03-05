class Movie < ActiveRecord::Base
    def self.all_ratings
        new1 = Array.new 
        self.select("rating").uniq.each{|a1| new1.push(a1.rating)}
        new1.sort.uniq
    end
end

