# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.move_planet = (sun, planet, orbits, distance ) ->
  orbital_angle = orbits * 2 * Math.PI
  x = Math.cos( orbital_angle ) * distance
  y = Math.sin( orbital_angle ) * distance
  sun_pos = { left: sun.offset().left+(sun.width()/2), top: sun.offset().top+(sun.height()/2) }
  planet.offset( { left: sun_pos.left+x-(planet.width()/2), top: sun_pos.top+y-(planet.height()/2) } )
