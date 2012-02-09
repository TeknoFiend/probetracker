require 'date'

class Trajectory < Struct.new( :date, :radial_distance, :eclip_lat, :eclip_long,
                               :helio_lat, :helio_long, :helio_inertial_long )
  def self.all
    $trajectories
  end
end

#class Trajectory < ActiveRecord::Base
#end

$trajectories = []

File.open(File.dirname(__FILE__) + '/vy1trj_ssc_1d.asc') do |file|
  file.each_line do |line|
    record = line.split(' ')
    date = Date.ordinal( record[0].to_i, record[1].to_i )

    $trajectories.push Trajectory.new( date, record[2], record[3], record[4], record[5], record[6] )
  end
end
