defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_orbital_periods_in_seconds 31_557_600

  @orbital_periods_in_seconds %{
    :earth => @earth_orbital_periods_in_seconds,
    :mercury => @earth_orbital_periods_in_seconds * 0.2408467,
    :venus => @earth_orbital_periods_in_seconds * 0.61519726,
    :mars => @earth_orbital_periods_in_seconds * 1.8808158,
    :jupiter => @earth_orbital_periods_in_seconds * 11.862615,
    :saturn => @earth_orbital_periods_in_seconds * 29.447498,
    :uranus => @earth_orbital_periods_in_seconds * 84.016846,
    :neptune => @earth_orbital_periods_in_seconds * 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds), do: seconds / @orbital_periods_in_seconds[planet]
end
