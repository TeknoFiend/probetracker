# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


class BaseModel extends Backbone.Model
    # Create model attribute getter/setter property.
    @attribute = (attr) ->
        Object.defineProperty @prototype, attr,
            get: -> @get attr
            set: (value) ->
                attrs = {}
                attrs[attr] = value
                @set attrs



window.View =
   distance_scale_x: 4000000
   distance_scale_y: 4000000
   size_scale: 1000
   sun_size_scale: 30000
   space_width: window.innerWidth
   space_height: window.innerHeight - $('.control_bar').height()
   sun_position:
      x: Math.ceil( window.innerWidth / 2 )
      y: Math.ceil( (window.innerHeight - $('.control_bar').height()) / 2 )

class SolarDate
   constructor: (args) ->
      if args.from_date?
         @year = args.from_date.getFullYear()
         # TODO: This function has an error of more than a day, needs to be fixed
         @day = args.from_date.getMonth() * 30 + args.from_date.getDate()
      else
         @year = args.year
         @day = args.day

   days_since: (earlier_date) ->
      (this.day-earlier_date.day) + (this.year - earlier_date.year) * SolarSystem.days_per_year


window.SolarSystem =
   sun: { equatorial_radius: 695500 }
   days_per_year: 365.256363004
   initial_date: new SolarDate( { year: 1970, day: 1 } ),
   last_date: new SolarDate( { from_date: new Date() } )
   total_days: ->
      today = new Date()
      # TODO: This function has an error of more than a day, needs to be fixed
      (@last_date.year - @initial_date.year) * @days_per_year + (today.getMonth() * 30 + today.getDate())
   planets: {}
   move_planets: (year, day) ->
      @planets.each (planet) ->
         position = planet.position_on_date( new SolarDate( { year: year, day: day } ) )
         x = position[0] / View.distance_scale_x
         y = position[1] / View.distance_scale_y
         move_planet( $('.sun'), planet.view, x, y )


class Planet extends BaseModel
   @attribute 'name'
   @attribute 'color'
   @attribute 'aphelion'
   @attribute 'perihelion'
   @attribute 'semimajor_axis'
   @attribute 'orbital_period'
   @attribute 'equatorial_radius'
   @attribute 'known_positions'

   initialize: ->
      @initial_angle = @known_positions[ SolarSystem.initial_date.year ][ SolarSystem.initial_date.day ][0]
      @radians_per_day = -2*Math.PI / @orbital_period
      @simple_orbital_radius = (parseInt( @aphelion.replace(/,/g,'') ) + parseInt( @perihelion.replace(/,/g,'') )) / 2

      console.log( @name )
      orbit_radius_x = @simple_orbital_radius/View.distance_scale_x
      orbit_radius_y = @simple_orbital_radius/View.distance_scale_y
      orbit_path = $('<div class="orbit_path in-space"></div>')
      orbit_path.width( orbit_radius_x*2 )
      orbit_path.height( orbit_radius_y*2 )
      orbit_path.css( 'border-radius', @simple_orbital_radius / View.distance_scale_x )
      orbit_path.css( 'left', View.sun_position.x-orbit_radius_x )
      orbit_path.css( 'top',  View.sun_position.y-orbit_radius_y )
      $('.space').append( orbit_path )

      size = Math.floor(@equatorial_radius / View.size_scale)
      size = 2 if size < 2
      @view = $('<div class="in-space" style="width:' + size + 'px; height:' + size + 'px; border-radius:' + size/2 + 'px; background-color:' + @color + '"></div>')
      $('.space').append( @view )

   url: ->
      base = "planets"
      return base  if @isNew()
      base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

   angle_on_date: (date) ->
      return date.days_since( SolarSystem.initial_date ) * @radians_per_day + @initial_angle

   position_on_date: (date) ->
      angle = @angle_on_date( date )
      x = Math.cos( angle ) * @simple_orbital_radius
      y = Math.sin( angle ) * @simple_orbital_radius
      return [x,y]


App =
   Collections: {}

App.Collections.Planets = Backbone.Collection.extend
  model: Planet
  url: "/planets"


window.StartUniverse = () ->

   ####  Reference dot for center  ####
   # dot = $('<div style="width:1px;height:1px;background-color:red;position:absolute;"></div>')
   # dot.css('left', View.sun_position.x)
   # dot.css('top',  View.sun_position.y)
   # $('.space').append( dot )
   ####################################

   console.log('sun')
   $('.sun').css('left', View.sun_position.x - $('.sun').width()/2)
   $('.sun').css('top',  View.sun_position.y - $('.sun').height()/2)

   SolarSystem.planets = new App.Collections.Planets()
   SolarSystem.planets.fetch
      success: (planets) ->
         SolarSystem.move_planets( SolarSystem.initial_date.year, SolarSystem.initial_date.day )
      error: ->
         new Error(message: "Error loading planets.")

window.move_planet = (sun, planet, x, y ) ->
   sun_pos = { x: sun.offset().left+(sun.width()/2), y: sun.offset().top+(sun.height()/2) }
   planet_pos = { left: sun_pos.x + x - planet.width()/2+1, top: sun_pos.y + y - planet.height()/2+1 }
   planet.offset( planet_pos )

