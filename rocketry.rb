module Rocketry
  module_function

  # Tsiolkovsky function for delta V
  def delta_v(wet_mass:, dry_mass:, specific_impulse:)
    specific_impulse * Math.log10(wet_mass / dry_mass)
  end
end
