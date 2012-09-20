#!/usr/bin/ruby

# grab list of headers, throw in some fake headers for inconsistency
# erroneous headers have been sprinkled in... 
headers = ["80fb0fffffffffffffffffff","807b09f90b05f854cb7d8a90","807b09fa0b05f854cb7d8a90","80fb09fb0b05f854cb7d8a90","80fb09fc0b061474cb7d8a90","80fb09fd0b062d10cb7d8a90","80fb09fe0b0645accb7d8a90","80fb09ff0b065e48cb7d8a90","80fb0a000b068f80cb7d8a90","80fb0fffffffffffffffffff","80fb0a010b06a81ccb7d8a90","80fb0a020b06c0b8cb7d8a90","80fb0a030b06d954cb7d8a90","80fb0a040b06f1f0cb7d8a90","80fb0a050b070a8ccb7d8a90","80fb0a060b072328cb7d8a90","80fb0a070b073bc4cb7d8a90","80fb0a080b075460cb7d8a90","80fb0a090b076cfccb7d8a90","80fb0a0a0b078598cb7d8a90","80fb0a0b0b079e34cb7d8a90","80fb0a0c0b07b6d0cb7d8a90","80fb0a0d0b07cf6ccb7d8a90","80fb0a0e0b07e808cb7d8a90","80fb0a0f0b8000a4cb7d8a90","80fb0a100b081940cb7d8a90","80fb0a110b0831dccb7d8a90","80fb0a120b086314cb7d8a90","80fb0a130b087bb0cb7d8a90","80fb0a140b08944ccb7d8a90","80fb0a150b08c584cb7d8a90","80fb0a160b08de20cb7d8a90","80fb0a170b08f6bccb7d8a90","80fb0a180b090f58cb7d8a90","80fb0fffffffffffffffffff"]

pattern = /^80(f|7)b0([a-f0-9]{19})/i

# loop through headers, grab everything that matches criteria
# (there will be some misc noise in most files that sneaks in... use @sync_source_id intervals to check for the correct sync_source_id in the set)

# sync_source_id usage. 
# {"sync_id":count}
# ex: {"cb7d8a90"=>32, "ffffffff"=>3}, we know that cb7d8a90 is the pattern that must be in each true rtp header since its value is higher
@sync_source_id = {}

# loop through headers, grab rtp headers and stuff into @rtp_headers Array, also grab last 4 bytes, and push into @sync_source_id Hash
for @j in 0..(headers.size-1) do
  (@rtp_headers ||= []) << headers[@j] if headers[@j].match(pattern)
  # now check the last 5 values match, and add to array
  tmp = headers[@j][headers[@j].size-8,headers[@j].size]
  if @sync_source_id.has_key? tmp
    tmp_count = @sync_source_id.fetch(tmp)+1
    @sync_source_id.store(tmp,tmp_count)
  else
    @sync_source_id.store(tmp,1)
  end
end

puts @sync_source_id.inspect

# spit out @sync_source_id.values into @main_sync_source
# sort array desc order
@main_sync_source = @sync_source_id.values.sort {|x,y| y <=> x }

# find key for value in original @sync_source_id hash
@sync_source_id.each {|key,value| 
  if value == @main_sync_source[0]
    @real_sync_source_id = key
    break
  end
}
puts @real_sync_source_id.to_s

# delete from headers array where last 4 bytes are not equal to the @real_sync_source_id
for @i in 0..(headers.size-1) do
  (@real_rtp_headers ||= []) << headers[@i] unless headers[@i][headers[@i].size-8,headers[@i].size] != @real_sync_source_id
end

@real_rtp_headers.each {|rtp_header| puts "rtp_header: #{rtp_header}"}