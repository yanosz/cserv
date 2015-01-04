json.array!(@supernodes) do |supernode|
  json.extract! supernode, :id
  json.url supernode_url(supernode, format: :json)
end
