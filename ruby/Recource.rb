# Recource.rb
class Recource
	attr_accessor :units_num #[加算器，乗算器]
	attr_accessor :units
	ADD = 0
	MUL = 1
	def initialize
		units_num = Array.new()
		File.foreach("resource.txt") do |line|
			line.split(",").each do |token| 
				units_num << token.to_i
			end
		end
		@units = Array.new()
		unit_type = ADD
		units_num.each do |each_unit_num|
			case unit_type
			when ADD
				for idx in 0..each_unit_num-1
					@units << "+" + idx.to_s
				end
				unit_type = MUL
			else
				for idx in 0..each_unit_num-1
					@units << "*" + idx.to_s
				end
			end
		end
	end
end