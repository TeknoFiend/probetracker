# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.View =
   distance_scale_x: 4000000
   distance_scale_y: 4000000
   size_scale: 1000
   sun_size_scale: 30000
   view_width: window.innerWidth
   view_height: window.innerHeight - $('.control_bar').height()
   sun_position:
      x: Math.ceil( window.innerWidth / 2 )
      y: Math.ceil( (window.innerHeight - $('.control_bar').height()) / 2 )
   sun_size:
      width: 9
      height: 9

App =
   Collections: {}

App.Collections.Planets = Backbone.Collection.extend
  model: Planet
  url: "/planets"


add_a_star = ->
   x = Math.floor( View.view_width * Math.random() )
   y = Math.floor( View.view_height * Math.random() )
   star_colors = ['1','2','3','4','5','6','7','8','9','a','b']
   base_color = star_colors[ Math.floor( star_colors.length * Math.random() ) ]
   star = $('<div class="star" style="background-color:#' + base_color + base_color + base_color + '; left:' + x + 'px; top:' + y + 'px;"></div>')
   $('.space').append(star)

window.StartUniverse = () ->

   ####  Reference dot for center  ####
   # dot = $('<div style="width:1px;height:1px;background-color:red;position:absolute;"></div>')
   # dot.css('left', View.sun_position.x)
   # dot.css('top',  View.sun_position.y)
   # $('.space').append( dot )
   ####################################

   count = 0;
   add_a_star() until (count++ == 75)

   console.log('sun')
   sun = $('<div class="sun in-space"></div>')
   sun.width( View.sun_size.width ).height( View.sun_size.height ).css( 'border-radius', Math.ceil( View.sun_size.width / 2 ) )
   sun.css('left', View.sun_position.x - sun.width()/2).css('top',  View.sun_position.y - sun.height()/2)
   $('.space').append(sun)

   SolarSystem.planets = new App.Collections.Planets()
   SolarSystem.planets.fetch
      success: (planets) ->
         planets.each (planet) ->
            orbit_radius_x = planet.simple_orbital_radius/View.distance_scale_x
            orbit_radius_y = planet.simple_orbital_radius/View.distance_scale_y
            orbit_path = $('<div class="orbit_path in-space"></div>')
            orbit_path.width( orbit_radius_x*2 )
            orbit_path.height( orbit_radius_y*2 )
            orbit_path.css( 'border-radius', planet.simple_orbital_radius / View.distance_scale_x )
            orbit_path.css( 'left', View.sun_position.x-orbit_radius_x )
            orbit_path.css( 'top',  View.sun_position.y-orbit_radius_y )
            $('.space').append( orbit_path )

            size = Math.floor(planet.equatorial_radius / View.size_scale)
            size = 2 if size < 2
            planet.view = $('<div class="in-space" style="width:' + size + 'px; height:' + size + 'px; border-radius:' + size/2 + 'px; background-color:' + planet.color + '"></div>')
            $('.space').append( planet.view )

         move_planets( SolarSystem.initial_date.year, SolarSystem.initial_date.day )
      error: ->
         new Error(message: "Error loading planets.")

window.move_planets = (year, day) ->
      SolarSystem.planets.each (planet) ->
         position = planet.position_on_date( new SolarDate( { year: year, day: day } ) )
         x = position[0] / View.distance_scale_x
         y = position[1] / View.distance_scale_y
         move_planet( $('.sun'), planet.view, x, y )

window.move_planet = (sun, planet, x, y ) ->
   sun_pos = { x: sun.offset().left+(sun.width()/2), y: sun.offset().top+(sun.height()/2) }
   planet_pos = { left: sun_pos.x + x - planet.width()/2+1, top: sun_pos.y + y - planet.height()/2+1 }
   planet.offset( planet_pos )

