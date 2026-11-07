import Toybox.Lang;

(:glance, :background)
public enum GlanceField {
    GLANCE_FIELD_TEMPERATURE = 0,
    GLANCE_FIELD_CO2 = 1,
    GLANCE_FIELD_HUMIDITY = 2,
    GLANCE_FIELD_PRESSURE = 3,
    GLANCE_FIELD_NOISE = 4,
    GLANCE_FIELD_RAIN = 5,
    GLANCE_FIELD_WIND = 6,
}


// Returns the short string of the given field, or null if the station does not measure it.
(:glance)
function glanceFieldShortString(data as WeatherStationData, field as Number) as String? {
    switch (field) {
        case GLANCE_FIELD_TEMPERATURE:
            return data.temperature().isPresent() ? data.temperature().toShortString() : null;
        case GLANCE_FIELD_CO2:
            return data.co2().isPresent() ? data.co2().toShortString() : null;
        case GLANCE_FIELD_HUMIDITY:
            return data.humidity().isPresent() ? data.humidity().toShortString() : null;
        case GLANCE_FIELD_PRESSURE:
            return data.pressure().isPresent() ? data.pressure().toShortString() : null;
        case GLANCE_FIELD_NOISE:
            return data.noise().isPresent() ? data.noise().toShortString() : null;
        case GLANCE_FIELD_RAIN:
            return data.rain().isPresent() ? data.rain().toShortString() : null;
        case GLANCE_FIELD_WIND:
            return data.wind().isPresent() ? data.wind().toShortString() : null;
    }
    return null;
}

// Shows the preferred field if the station has it, otherwise the first available field
// that is not already shown in another slot (`exclude`). Returns null if nothing is available.
(:glance)
function glanceFieldWithFallback(data as WeatherStationData, preferred as Number, exclude as Number?) as [Number, String]? {
    var value = preferred == exclude ? null : glanceFieldShortString(data, preferred);
    if (value != null) {
        return [preferred, value];
    }
    var order = [GLANCE_FIELD_TEMPERATURE, GLANCE_FIELD_CO2, GLANCE_FIELD_HUMIDITY, GLANCE_FIELD_PRESSURE,
        GLANCE_FIELD_NOISE, GLANCE_FIELD_RAIN, GLANCE_FIELD_WIND] as Array<Number>;
    for (var i = 0; i < order.size(); i++) {
        var field = order[i];
        if (field == exclude) { continue; }
        value = glanceFieldShortString(data, field);
        if (value != null) {
            return [field, value];
        }
    }
    return null;
}
