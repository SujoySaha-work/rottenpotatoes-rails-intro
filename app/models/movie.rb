class Movie < ActiveRecord::Base
    def self.all_ratings
        %w(G PG PG-13 NC-17 R)
        #added NC-17 as it was present in add new movie
    end
end

