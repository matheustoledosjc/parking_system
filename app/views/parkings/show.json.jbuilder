json.array! @parkings do |record|
  json.extract! record, :id, :plate, :time
  json.paid record.paid?
  json.left record.left?
end