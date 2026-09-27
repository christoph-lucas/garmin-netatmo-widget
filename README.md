# Netatmo Weather Station Data

A simple widget that displays the data from Netatmo Weather Stations.

If you find a bug or have an idea for a new feature, please consider creating a corresponding issues. I would love to hear about it.

Disclaimer: This is NOT an official app from Netatmo. It is provided by myself as a private person doing this in my spare time without any warranty.

Icon thanks to Iconfinder / Adri Ansyah.

## Requested permissions

* Communication: load the data from Netatmo
* Backgrounding: load the data in the background, can be deactivated via settings
* PersistedContent: store both authentication data as well as station data


## Error handling

### Invalid Grant

If you get the error message "Tokens 400: Invalid Grant", go to the menu and trigger a Reauthentication. This error probably means that the app tried to refresh the access token, yet the refresh token was not valid anymore. In that case, the only remedy is to reauthenticate.

### View loop must be non zero value

If the view loop is empty ("zero value"), either there is no station data for your account, or the parsing of the station data fails. You can retrieve the station data yourself by performing the following steps (at some point you will have to authenticate with Netatmo):

1. Go to https://dev.netatmo.com/apidocumentation/weather#getstationsdata 
2. Click „Try It Out“
3. Click „Execute /GetStationsData“
4. Under Server Response -> Response body: check if the response looks good, it should start with `"{ body: { devices:[…“)`

I would expect the response to be empty, or that it does not look like the "Response Examples". In either case the app will not work.
