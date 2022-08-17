json.array! @parkings do |record|
  json.extract! record, :id, :time, :paid, :left
end