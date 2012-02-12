class Planet # < ActiveRecord::Base

  def self.all
    @@planets
  end

  @@planets = [
               {
                 id: 1, name: "Mercury", color: "#777",
                 aphelion: "69,816,900", perihelion: "46,001,200", semimajor_axis: "57,909,100",
                 equatorial_radius: 2439.7, orbital_period: 87.969,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },
               {
                 id: 2, name: "Venus", color: "#DDDD33",
                 aphelion: "108,942,109", perihelion: "107,476,259", semimajor_axis: "108,208,930",
                 equatorial_radius: 6051.8, orbital_period: 224.700,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },
               {
                 id: 3, name: "Earth", color: "blue",
                 aphelion: "152,098,232", perihelion: "147,098,290", semimajor_axis: "149,598,261",
                 equatorial_radius: 6378, orbital_period: 365.256363004,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },
               {
                 id: 4, name: "Mars", color: "red",
                 aphelion: "249,209,300", perihelion: "206,669,000", semimajor_axis: "227,939,100",
                 equatorial_radius: 3396.2, orbital_period: 686.971,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },

               {
                 id: 5, name: "Jupiter", color: "#F77",
                 aphelion: "816,520,800", perihelion: "740,573,600", semimajor_axis: "778,547,200",
                 equatorial_radius: 71492, orbital_period: 4332.59,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },
               {
                 id: 6, name: "Saturn", color: "#DDDD33",
                 aphelion: "1,513,325,783", perihelion: "1,353,572,956", semimajor_axis: "1,433,449,370",
                 equatorial_radius: 60268, orbital_period: 10759.22,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },
               {
                 id: 7, name: "Uranus", color: "#88a",
                 aphelion: "3,004,419,704", perihelion: "2,748,938,461", semimajor_axis: "2,876,679,082",
                 equatorial_radius: 25559, orbital_period: 30799.095,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               },
               {
                 id: 8, name: "Neptune", color: "#668",
                 aphelion: "4,553,946,490", perihelion: "4,452,940,833", semimajor_axis: "4,503,443,661",
                 equatorial_radius: 24764, orbital_period: 60190,
                 known_positions: { '1970' => { '1' => [0,1.0] } }
               }
              ]
end
