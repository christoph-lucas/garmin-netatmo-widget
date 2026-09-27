# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A Garmin Connect IQ widget (Monkey C) that displays weather data from Netatmo Weather Stations. All app code lives under `GarminNetatmoWidget/`. This is a hobby project maintained by an individual, not an official Netatmo app.

## Build, test, and run

There is no CLI build script (no Makefile/shell scripts) — this project is built via the Garmin "Monkey C" VS Code extension and the Connect IQ SDK. The user always works in VS Code with the Monkey C extension.

- Build/run in simulator: VS Code command palette → "Monkey C: Build Current Project" / "Monkey C: Run Current Project in Simulator" (F5).
- Edit manifest fields (app id, products, permissions, languages): use the corresponding "Monkey C: Edit ..." command palette actions rather than hand-editing `manifest.xml` — it is a generated file.
- Run unit tests: "Monkey C: Run Current Project in Simulator" with the Test target, or "Monkey C: Build for Unit Testing" then run in simulator. Tests are Monkey C files tagged `(:test)` (see `source/UtilsTest.mc`, `source/domain/StationIdTest.mc`, `source/domain/TimestampTest.mc`).
- Type checking is set to `Strict` (`GarminNetatmoWidget/.vscode/settings.json`) — code must pass strict type checking.

### Required local secret before building

`resources/jsonData/jsonResources.xml` (gitignored) must be created from `resources/jsonData/jsonResources.xml.example` and populated with a real Netatmo app `id`/`secret` from https://dev.netatmo.com/apps/, otherwise the app cannot authenticate.

## Annotations and build variants

Monkey C code uses excludeAnnotations to compile different variants of the same app (full app, Glance widget, background service). Every class/function usable outside the main foreground app must be explicitly annotated:

- `(:glance)` — usable from the Glance view (`getGlanceView`), which runs in a much more restricted environment.
- `(:background)` — usable from the background temporal-event service (`BackgroundDelegate.onTemporalEvent`).
- Many shared domain/netatmo classes are tagged `(:glance, :background)` because they're reused by all three entry points (full app, glance, background).
- `(:typecheck(disableBackgroundCheck))` / `(:typecheck(disableGlanceCheck))` suppress the type checker's cross-annotation calls where a function is only reachable from one context in practice (e.g. OAuth flows in `NetatmoAuthenticator.mc` are foreground-only and disable the background check).

When adding new code reachable from the glance view or background service, tag it accordingly — the compiler will otherwise reject the build for that variant.

## Architecture

Layered, dependency-injected design wired up once in `GarminNetatmoWidgetApp.initialize()`:

```
GarminNetatmoWidgetApp (entry point: full app / glance / background)
  -> WeatherStationService            (source/domain/WeatherStationService.mc)
       -> WeatherStationRepository    (interface, source/domain/WeatherStationRepository.mc)
            -> NetatmoRepository      (source/netatmo/NetatmoRepository.mc)
                 -> StationsDataCache               (source/netatmo/StationsDataCache.mc)
                 -> NetatmoConnectionsOrchastratorFactory / NetatmoConnectionsOrchastrator
                      -> NetatmoAuthenticator        (OAuth + token refresh)
                      -> NetatmoDataRetriever        (GetStationsData API call + response mapping)
```

- **Three entry points share one `WeatherStationService` instance**: `getInitialView()` (full app), `getGlanceView()` (glance), and `getServiceDelegate()`/`BackgroundDelegate` (background refresh). This is why the service/repo/orchestrator layers are annotated `(:glance, :background)` — they must run correctly in all three restricted contexts.
- **Callback-based async flow, no promises**: nearly everything communicates via two typedef callbacks passed down through every layer: `DataConsumer` (`Method(data as WeatherStationsData) as Void`) and `NotificationConsumer` (`Method(notification as Notification) as Void`, used for both status updates and errors — see `domain/Notification.mc`, `domain/Status.mc`, `domain/WeatherStationError.mc`). Views/delegates supply these consumers; deep layers never return values synchronously.
- **`NetatmoConnectionsOrchastrator`** is the async chain coordinator for a single load: check cache validity → check connectivity → authenticate (`NetatmoAuthenticator`) → fetch data (`NetatmoDataRetriever`) → cache the result. `loadStationDataInBackground` is a stricter variant that fails fast if not already authenticated (no interactive OAuth in the background).
- **`NetatmoAuthenticator`** implements the OAuth2 + refresh-token flow against Netatmo's API as a manual chain of endpoint objects (`AuthenticationEndpoint` → `TokensFromCodeEndpoint` / `RefreshAccessTokenEndpoint`), each taking a one-shot handler via `callAndThen(...)`. Tokens and their expiry are persisted via `Toybox.Application.Storage` (see `StorageKeys.mc`).
- **`StationsDataCache`** caches the last successful `WeatherStationsData` response in `Storage`, with a TTL computed from the oldest station measurement timestamp (`NETATMO_DEFAULT_UPDATE_INTERVAL_IN_SECONDS`, 10 min) — this avoids hitting the Netatmo API on every glance/background refresh.
- **Domain value objects** (`source/domain/*.mc`: `Temperature`, `Humidty`, `Pressure`, `Rain`, `Wind`, `CO2`, `Noise`, `Timestamp`, `StationId`, etc.) wrap raw API values (which may be `null` if a module is disconnected) and know how to serialize to/from `Dictionary` for `Storage` (`toDict`/`fromDict`), rather than raw values being passed around directly.
- **Views** (`source/view/*`) are organized by feature folder (`glance_view`, `loading_view`, `notification_view`, `stations_data_view`) each with a View + Delegate pair. `WeatherStationsViewFactory` builds a `ViewLoop` so the user can swipe between multiple stations/modules returned by the Netatmo account.
- **Config** (`domain/Config.mc`) is a plain read-only snapshot of the app's `Properties.xml` settings (which measurements to show, background refresh interval), built once at `initialize()` and passed down rather than re-read from `Properties` throughout the code.

## Error handling conventions

- `WeatherStationError` / `WebRequestError` (both `Notification` subtypes) represent failures and are pushed through the same `NotificationConsumer` channel as status updates — check `instanceof` at the consumer to distinguish (see `BackgroundDelegate.onNotificationReceived`).
- Service-layer methods (`WeatherStationService.loadStationData`/`loadStationDataInBackground`) wrap repository calls in `try/catch` and convert any exception into a `WeatherStationError` pushed to the `NotificationConsumer`, rather than letting exceptions propagate to views or the background delegate.
