class Post < ActiveRecord::Base
	belongs_to :user
	has_ancestry
	searchable do
    text :title
    text :summary
    integer :entry_id
  end

  STOP_WORDS = %w( a and after again blog by can't change do first from for get had have how i if in is it my need not on one only product site to top want why won't wordpress )
end
