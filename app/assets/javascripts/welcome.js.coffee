# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


#DISTANCE_SCALE_X = 6000000
#DISTANCE_SCALE_Y = 8000000
#SIZE_SCALE = 2000

DISTANCE_SCALE_X =  750000
DISTANCE_SCALE_Y = 1000000
SIZE_SCALE = 1000


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
   days_per_year: 365.256363004
   initial_date: new SolarDate( { year: 1970, day: 1 } ),
   last_date: new SolarDate( { from_date: new Date() } )
   total_days: ->
      (@last_date.year - @initial_date.year) * @days_per_year
   planets: {}
   move_planets: (year, day) ->
      @planets.each (planet) ->
         position = planet.position_on_date( new SolarDate( { year: year, day: day } ) )
         x = position[0] / DISTANCE_SCALE_X
         y = position[1] / DISTANCE_SCALE_Y
         move_planet( $('.sun'), planet.view, x, y )


class BaseModel extends Backbone.Model
    # Create model attribute getter/setter property.
    @attribute = (attr) ->
        Object.defineProperty @prototype, attr,
            get: -> @get attr
            set: (value) ->
                attrs = {}
                attrs[attr] = value
                @set attrs


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
      size = Math.floor(@equatorial_radius / SIZE_SCALE)
      size = 2 if size < 2
      @view = $('<div class="in-space" style="width:' + size + 'px; height:' + size + 'px; border-radius:' + size/2 + 'px; background-color:' + @color + '"></div>');
      $('.space').append( @view );
      @initial_angle = @known_positions[ SolarSystem.initial_date.year ][ SolarSystem.initial_date.day ][0]
      @radians_per_day = 2*Math.PI / @orbital_period
      @simple_orbital_radius = (parseInt( @aphelion.replace(/,/g,'') ) + parseInt( @perihelion.replace(/,/g,'') )) / 2

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


window.SolarSystem.planets = new App.Collections.Planets()
window.SolarSystem.planets.fetch
   success: (planets) ->
      SolarSystem.move_planets( SolarSystem.initial_date.year, SolarSystem.initial_date.day )
   error: ->
      new Error(message: "Error loading planets.")

window.move_planet = (sun, planet, x, y ) ->
   sun_pos = { left: sun.offset().left+(sun.width()/2), top: sun.offset().top+(sun.height()/2) }
   planet_pos = { left: sun_pos.left+x-(planet.width()/2), top: sun_pos.top+y-(planet.height()/2) }
   planet.offset( planet_pos )

