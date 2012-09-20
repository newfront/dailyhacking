#!/usr/bin/ruby

module NumberFormat

# hex lookup table
@hex_table = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

# binary lookup table
@bin_table = ["0000","0001","0010","0011","0100","0101","0110","0111","1000","1001","1010","1011","1100","1101","1110","1111"]

def NumberFormat.hex_or_bin_conversion(hex_array, direction="to_bin")
  
  raise "Error. First parameter must be filled in" unless !hex_array.nil?
  
  unless hex_array.is_a? Array
    hex_array = hex_array.lines.to_a
  end
  
  tmp = ''
  # if the hex array is flattened, unflatten as hex pairs
  if hex_array.length == 1
    bin = []
    hex_array.to_s.scan(/../).map do |match| 
      bin << match
    end
    hex_array = bin
  end
  
  begin
    hex_array.each do |hex|
      begin
        for @i in 0..(@hex_table.size-1) do
          if hex[0,1].to_s.upcase == @hex_table[@i]
            tmp << @bin_table[@i]
            break
          end
        end
      rescue
        puts"first hex to bin chunk conversion failed"
      end

      begin
        for @k in 0..(@hex_table.size-1) do
          if hex[1,1].to_s.upcase == @hex_table[@k]
            tmp << @bin_table[@k]
            break
          end
        end
      rescue
        puts"second hex to bin chunk conversion failed"
      end
    end
    return tmp
  rescue
    puts "failed to convert hex to binary"
  end
end

end