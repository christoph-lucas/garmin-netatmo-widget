import Toybox.Lang;
using Toybox.Application.Storage;
using Toybox.Authentication;
using Toybox.Communications;
using Toybox.Time;

// Links used:
// https://dev.netatmo.com/apidocumentation/oauth#authorization-code
// https://datatracker.ietf.org/doc/html/rfc6749#page-18
// https://developer.garmin.com/connect-iq/core-topics/authenticated-web-services/
// https://developer.garmin.com/connect-iq/api-docs/Toybox/Authentication.html#makeOAuthRequest-instance_function

(:glance)
const OAUTH_CODE = "netatmoOAuthCode";
(:glance)
const OAUTH_ERROR = "netatmoOAuthError";
(:glance)
const OAUTH_ERROR_DESC = "netatmoOAuthErrorDesc";
(:glance)
const OAUTH_STATE = "netatmoOAuthState";

typedef AccessTokenConsumer as Method(accessToken as String) as Void;
typedef AuthenticationCodeHandler as Method(authenticationCode as String) as Void;
typedef TokensHandler as Method(refresh_token as String, accessToken as String, expiresIn as Number) as Void;

(:glance, :background)
class NetatmoAuthenticator {

    private var _clientAuth as NetatmoClientAuth;
    private var _accessTokenConsumer as AccessTokenConsumer;
    private var _notificationConsumer as NotificationConsumer;

    public function initialize(netatmoClientAuth as NetatmoClientAuth, accessTokenConsumer as AccessTokenConsumer, notificationConsumer as NotificationConsumer) {
        self._clientAuth = netatmoClientAuth;
        self._accessTokenConsumer = accessTokenConsumer;
        self._notificationConsumer = notificationConsumer;
    }

    //! Requesting an Access Token triggers a series of async operations, where each operation might or might not be necessary.
    //! Unfortunately, I could not find a nice way to chain these operations in an intention revealing way.
    //! Step 1: Ensure Authentication: If refresh token is missing (sync check)
    //!      1a: Request Authentication Code (async)
    //!      1b: Convert Authentication Code into Refresh and Access Tokens (async)
    //!      1c: immediately return access token via consumer (sync), terminate chain
    //! Step 2: Ensure Access Token Valid: If Access Token invalid (missing or expired) (sync check)
    //!      2a: Refresh Access Token (async)
    //!      2b: immediately return access token via consumer (sync), terminate chain
    //! Step 3: Return stored Access Token via consumer (sync)
    public function requestAccessToken() as Void {
        self._ensureAuthentication(); // starts the chain
    }

    public function requestAccessTokenIfAuthenticated() as Void {
        var refreshToken = Storage.getValue(REFRESH_TOKEN) as String;
        if (notEmpty(refreshToken)) {
            self._ensureAccessTokenValidity();
        } else {
            self._notificationConsumer.invoke(new WeatherStationError("Not authorized, illegal state."));
        }
    }

    // STEP 1
    (:typecheck(disableBackgroundCheck))
    private function _ensureAuthentication() as Void {
        var refreshToken = Storage.getValue(REFRESH_TOKEN) as String;
        if (notEmpty(refreshToken)) {
            self._ensureAccessTokenValidity();
        } else {
            self._notificationConsumer.invoke(new Status("Authorizing,\ncheck phone."));
            new AuthenticationEndpoint(self._clientAuth, self._notificationConsumer).callAndThen(method(:_getTokensFrom));
        }
    }

    // STEP 1b
    (:typecheck(disableBackgroundCheck))
    public function _getTokensFrom(authenticationCode as String) as Void {
        self._notificationConsumer.invoke(new Status("Auth code received,\nget tokens."));
        new TokensFromCodeEndpoint(self._clientAuth, self._notificationConsumer)
            .callAndThen(authenticationCode, method(:_receiveTokens));
    }

    // STEP 2
    private function _ensureAccessTokenValidity() as Void {
        var accessTokenValidUntilRaw = Storage.getValue(ACCESS_TOKEN_VALID_UNTIL) as Number;
        if (new Timestamp(accessTokenValidUntilRaw).inFuture()) {
                var accessToken = Storage.getValue(ACCESS_TOKEN) as String;
                if (notEmpty(accessToken)) {
                    self._accessTokenConsumer.invoke(accessToken);
                    return;
                }
        }

        self._notificationConsumer.invoke(new Status("Refreshing\naccess token."));
        var refreshToken = Storage.getValue(REFRESH_TOKEN) as String;
        new RefreshAccessTokenEndpoint(self._clientAuth, self._notificationConsumer)
            .callAndThen(refreshToken, method(:_receiveTokens));
    }

    // STEP 1c and 2b
    public function _receiveTokens(refresh_token as String, accessToken as String, expiresIn as Number) as Void {
        self._notificationConsumer.invoke(new Status("Storing\naccess token."));
        self._storeRefreshToken(refresh_token);
        self._storeAccessToken(accessToken, expiresIn);
        self._accessTokenConsumer.invoke(accessToken);
    }

    private function _storeRefreshToken(refreshToken as String) as Void {
        Storage.setValue(REFRESH_TOKEN, refreshToken);
    }

    private function _storeAccessToken(accessToken as String, expiresIn as Number) as Void {
        Storage.setValue(ACCESS_TOKEN, accessToken);

        var validUntil = Timestamp.inSecondsFromNow(expiresIn - 60);  // Remove 1 min to be on the safe side
        Storage.setValue(ACCESS_TOKEN_VALID_UNTIL, validUntil.value());
    }
}

(:glance)
public class AuthenticationEndpoint {

    private var _clientAuth as NetatmoClientAuth;
    private var _handler as AuthenticationCodeHandler?;
    private var _errorHandler as NotificationConsumer;
    private var _state as String;

    public function initialize(clientAuth as NetatmoClientAuth, errorHandler as NotificationConsumer) {
        self._clientAuth = clientAuth;
        self._errorHandler = errorHandler;
        self._state = randomString(32);
    }

    public function callAndThen(authenticationCodeHandler as AuthenticationCodeHandler) as Void {
        if (self._handler != null) {throw new OperationNotAllowedException("Handler already defined.");}
        self._handler = authenticationCodeHandler;
        self._requestAuthenticationCode();
    }

    // STEP 1a
    private function _requestAuthenticationCode() as Void {
        // register a callback to capture results from OAuth requests
        Authentication.registerForOAuthMessages(method(:onOAuthMessage));

        var params = {
            "redirect_uri" => "connectiq://oauth",
            "client_id" => self._clientAuth.id(),
            "scope" => "read_station",
            "state" => self._state
        };

        // makeOAuthRequest triggers login prompt on mobile device.
        // "responseCode" and "responseError" are the parameters passed
        // to the resultUrl. Check the oauth provider's documentation
        // to determine the correct strings to use.
        Authentication.makeOAuthRequest(
            "https://api.netatmo.com/oauth2/authorize",
            params,
            // NB: I could not find out what the ResultURL is supposed to be (or what the difference to the redirect_uri is)
            // From the description above it seems to be the same and this value works
            "connectiq://oauth", 
            Authentication.OAUTH_RESULT_TYPE_URL,
            {"state" => $.OAUTH_STATE, "code" => $.OAUTH_CODE, "error" => $.OAUTH_ERROR, "error_description" => $.OAUTH_ERROR_DESC}
        );        
    }

    // implement the OAuth callback method
    // should be private, yet the I could not figure out how to provide a callback to a private method
    public function onOAuthMessage(message as Authentication.OAuthMessage) as Void {
        if (message.data != null) {
            var data = message.data as Dictionary<String, String>;
            var error = data[$.OAUTH_ERROR] as String;
            if (notEmpty(error)) {
                var error_desc = data[$.OAUTH_ERROR_DESC];
                self._errorHandler.invoke(new WebRequestError("Authorize", 0, error_desc, error));
                return;
            }
            var state = data[$.OAUTH_STATE];
            if (!(self._state.equals(state))) {
                var msg = "The returned state does not match the expected one.";
                self._errorHandler.invoke(new WebRequestError("Authorize", 0, msg, null));
                return;
            }

            var code = data[$.OAUTH_CODE] as String;
            if (self._handler != null) {
                (self._handler as AuthenticationCodeHandler).invoke(code);
            } else {
                self._errorHandler.invoke(new WeatherStationError("No AuthenticationCodeHandler defined."));
            }
        } else {
            self._errorHandler.invoke(new WebRequestError("Authorize", 0, "Data missing.", ""));
        }
    }

}

(:glance)
public class TokensFromCodeEndpoint {
    private var _clientAuth as NetatmoClientAuth;
    private var _handler as TokensHandler?;
    private var _errorHandler as NotificationConsumer;

    public function initialize(clientAuth as NetatmoClientAuth, errorHandler as NotificationConsumer) {
        self._clientAuth = clientAuth;
        self._errorHandler = errorHandler;
    }

    public function callAndThen(authenticationCode as String, tokensHandler as TokensHandler) as Void {
        if (self._handler != null) {throw new OperationNotAllowedException("Handler already defined.");}
        self._handler = tokensHandler;
        self._getTokensFrom(authenticationCode);
    }

    // STEP 1b
    private function _getTokensFrom(authenticationCode as String) as Void {
        // see https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications.html#makeWebRequest-instance_function
        var params = {
            "grant_type" => "authorization_code",
            "client_id" => self._clientAuth.id(),
            "client_secret" => self._clientAuth.secret(),
            "code" => authenticationCode,
            "redirect_uri" => "connectiq://oauth",
            "scope" => "read_station"
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON            
        };

        var responseCallback = method(:onReceiveTokens);

        Communications.makeWebRequest(
            "https://api.netatmo.com/oauth2/token", 
            params,
            options,
            responseCallback
        );
    }

    // STEP 1c
    public function onReceiveTokens(responseCode as Number, data as Dictionary or String or Null) as Void {
        var typedData = data as Dictionary<String, String>;
        if (responseCode == 200) {
            var refresh_token = typedData["refresh_token"] as String;
            var accessToken = typedData["access_token"] as String;
            var expires_in = typedData["expires_in"] as Number;
            if (self._handler != null) {
                (self._handler as TokensHandler).invoke(refresh_token, accessToken, expires_in);
            } else {
                self._errorHandler.invoke(new WeatherStationError("No TokensHandler defined."));
            }
        } else {
            var error = typedData["error"];
            var desc = typedData["error_description"];
            self._errorHandler.invoke(new WebRequestError("Tokens", responseCode, desc, error));
        }
    }
}

(:glance, :background)
public class RefreshAccessTokenEndpoint {
    private var _clientAuth as NetatmoClientAuth;
    private var _handler as TokensHandler?;
    private var _errorHandler as NotificationConsumer;

    public function initialize(clientAuth as NetatmoClientAuth, errorHandler as NotificationConsumer) {
        self._clientAuth = clientAuth;
        self._errorHandler = errorHandler;
    }

    public function callAndThen(refreshToken as String, tokenHandler as TokensHandler) as Void {
        if (self._handler != null) {throw new OperationNotAllowedException("Handler already defined.");}
        self._handler = tokenHandler;
        self._refreshAccessToken(refreshToken);
    }

    private function _refreshAccessToken(refreshToken as String) as Void {
        // see https://developer.garmin.com/connect-iq/api-docs/Toybox/Communications.html#makeWebRequest-instance_function
        var params = {
            "grant_type" => "refresh_token",
            "refresh_token" => refreshToken,
            "client_id" => self._clientAuth.id(),
            "client_secret" => self._clientAuth.secret(),
            "redirect_uri" => "connectiq://oauth",
            "scope" => "read_station"
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON            
        };

        var responseCallback = method(:onReceiveTokens);

        Communications.makeWebRequest(
            "https://api.netatmo.com/oauth2/token", 
            params,
            options,
            responseCallback
        );
    }

    public function onReceiveTokens(responseCode as Number, data as Dictionary or String or Null) as Void {
        var typedData = data as Dictionary<String, String>;
        if (responseCode == 200) {
            var refresh_token = typedData["refresh_token"] as String;
            var accessToken = typedData["access_token"] as String;
            var expires_in = typedData["expires_in"] as Number;
            if (self._handler != null) {
                (self._handler as TokensHandler).invoke(refresh_token, accessToken, expires_in);
            } else {
                self._errorHandler.invoke(new WeatherStationError("No TokensHandler defined."));
            }
        } else {
            var error = typedData["error"];
            self._errorHandler.invoke(new WebRequestError("Tokens", responseCode, null, error));
        }
    }
}