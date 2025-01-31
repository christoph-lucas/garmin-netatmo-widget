# Netatmo Weather Station Data

## Requested permissions

* Communication: load the data from Netatmo
* Backgrounding: load the data in the background, can be deactivated via settings
* PersistedContent: store both authentication data as well as station data


## Error handling

If you get the error message "Tokens 400: Invalid Grant", go to the menu and trigger a Reauthentication. This error probably means that the app tried to refresh the access token, yet the refresh token was not valid anymore. In that case, the only remedy is to reauthenticate.
