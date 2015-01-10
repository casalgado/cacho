class Die

	def initialize
		@faces  = [1, 2, 3, 4, 5, 6]
	end

	def roll
		@faces[rand(@faces.length)]
	end
end