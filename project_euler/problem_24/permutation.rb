seq = [0,1,2,3]

def permutate (target, list)

	# target will be injected into all instances of list
	len = list.length
	position = 0
	results = [target]

	while position < len do

		nresults = []
		current = list[position] # 1

		for @i in 0..results.length-1 do

			target = results[@i] # [0]
			puts target.to_s
			tmp = []

			if !target.is_a? Array
				nresults << [target, current]
				nresults << [current, target]
			else
				sposition = 0
				clen = target.length

				while sposition < clen
					
					tmp = []
					for @j in 0..target.length-1 do
						tmp << current if @j == sposition
						tmp << target[@j]
					end
					
					nresults << tmp
					sposition += 1
				end

				nresults << target + [current]

			end
		end
		puts nresults.to_s
		results = nresults
		position += 1
	end

	return results
end

permutation = permutate(0, [1,2,3])

puts permutation.count

#puts permutation