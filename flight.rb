<<-FLIGHTS

SFO--------------------------------JFK
             DFW-------------------JFK
      SFO---------------DFW
                             DFW-------------------JFK
DFW--------------------------------JFK

      SFO----LAS        LAS-----------------------------JFK
12    4      6          8    9      12             4    5

FLIGHTS

require 'date'
require 'pp'

Flight = Struct.new(:depart, :land, :depart_at, :land_at) do
  def self.build(depart, land, depart_at, land_at)
    new(depart, land, DateTime.parse(depart_at), DateTime.parse(land_at))
  end
end

FLIGHTS = [
  Flight.build(:sfo, :jfk, '2016-07-28 12:00 AM', '2016-07-28 12:00 PM'),
  Flight.build(:dfw, :jfk, '2016-07-28  6:00 AM', '2016-07-28 12:00 PM'),
  Flight.build(:sfo, :dfw, '2016-07-28  4:00 AM', '2016-07-28  8:00 AM'),
  Flight.build(:dfw, :jfk, '2016-07-28  9:00 AM', '2016-07-28  4:00 PM'),
  Flight.build(:dfw, :jfk, '2016-07-28 12:00 AM', '2016-07-28 12:00 PM'),
  Flight.build(:sfo, :las, '2016-07-28  4:00 AM', '2016-07-28  6:00 AM'),
  Flight.build(:sfo, :las, '2016-07-28  8:00 AM', '2016-07-28  5:00 PM')
]

def get_arrival_paths(flights, depart, land, depart_at, path = [])
  departures = flights.select{|f| f.depart == depart && f.depart_at >= depart_at}
  arrivals, connections = departures.partition{|f| land == f.land}

  arrivals.map{|f| path + [f]} + connections.flat_map do |f|
    get_arrival_paths(flights, f.land, land, f.land_at, path + [f])
  end
end

def get_best_path(flights, depart, land, depart_at)
  paths = get_arrival_paths(flights, depart, land, depart_at)
  paths.sort_by{|path| path.last.land_at }.first
end

pp get_arrival_paths(FLIGHTS, :sfo, :jfk, DateTime.parse('2016-07-28 12:00 AM'))
pp get_best_path(FLIGHTS, :sfo, :jfk, DateTime.parse('2016-07-28 12:00 AM'))
