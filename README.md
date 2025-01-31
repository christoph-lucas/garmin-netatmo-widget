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

If you get the error message "Tokens 400: Invalid Grant", go to the menu and trigger a Reauthentication. This error probably means that the app tried to refresh the access token, yet the refresh token was not valid anymore. In that case, the only remedy is to reauthenticate.
