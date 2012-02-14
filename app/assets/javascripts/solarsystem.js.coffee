
class BaseModel extends Backbone.Model
    # Create model attribute getter/setter property.
    @attribute = (attr) ->
        Object.defineProperty @prototype, attr,
            get: -> @get attr
            set: (value) ->
                attrs = {}
                attrs[attr] = value
                @set attrs


class window.SolarDate
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

class window.Planet extends BaseModel
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
