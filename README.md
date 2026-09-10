# Stopwatch

A stopwatch application built with Flutter, featuring digital and analog clock displays, lap tracking with split comparisons, and state persistence.

## Screenshots

| Digital Display | Lap Tracking | Paused State |
| :---: | :---: | :---: |
| <img src="docs/screenshots/01_digital_running.png" width="260" alt="Digital Stopwatch Running" /> | <img src="docs/screenshots/03_laps_highlighted.png" width="260" alt="Recorded Laps Highlighted" /> | <img src="docs/screenshots/04_paused_state.png" width="260" alt="Paused State" /> |

| Analog Dial (Paused) | Analog Dial (Running) | Live Lap Split |
| :---: | :---: | :---: |
| <img src="docs/screenshots/05_analog_paused.png" width="260" alt="Analog Clock Paused" /> | <img src="docs/screenshots/06_analog_running.png" width="260" alt="Analog Clock Running" /> | <img src="docs/screenshots/02_first_lap.png" width="260" alt="First Lap Live" /> |

## Features

- **Timekeeping**: Monotonic timing based on Dart's `Stopwatch` class with 30 ms UI tick rate and tabular figure typography.
- **Dual Display**: Switch between digital (`MM:SS.ss`) and analog dial via swipe or page indicator.
- **Lap Tracking**: Records lap splits and cumulative elapsed time. When two or more laps are recorded, the fastest and slowest laps are highlighted.
- **State Persistence**: Saves current elapsed time and recorded laps to local storage (`SharedPreferences`) on app exit or backgrounding, restoring them in a paused state on restart.

## Architecture

The application follows an MVVM architecture with unidirectional data flow:

```mermaid
graph TD
    subgraph Presentation ["Presentation"]
        Screen["StopwatchScreen"]
        Digital["DigitalDisplay"]
        Analog["AnalogDisplay"]
        Controls["StopwatchControls"]
        Indicator["ClockPageIndicator"]
        LapList["LapListView"]
        LapItem["LapRow"]

        Screen --> Digital
        Screen --> Analog
        Screen --> Controls
        Screen --> Indicator
        Screen --> LapList
        LapList --> LapItem
    end

    subgraph Logic ["Logic"]
        VM["StopwatchViewModel"]
        LapModel["Lap"]
        
        VM --> LapModel
    end

    subgraph Data ["Data"]
        Persistence["StopwatchPersistenceService"]
        SharedPrefs[("SharedPreferences")]
        
        Persistence --> SharedPrefs
    end

    subgraph Core ["Core"]
        Theme["AppTheme"]
        Scroll["AppScrollBehavior"]
        Formatting["DurationFormatting"]
    end

    Screen -- Listens to --> VM
    Controls -- User actions --> VM
    VM -- Saves state --> Persistence
    Digital -. Formats via .-> Formatting
    LapItem -. Formats via .-> Formatting
    VM -. Formats via .-> Formatting
    Screen -. Theme .-> Theme
    Screen -. Drag gestures .-> Scroll
```

## Project Structure

```text
lib/
├── core/
│   ├── extensions/
│   │   └── duration_extensions.dart
│   └── theme/
│       ├── app_scroll_behavior.dart
│       └── app_theme.dart
├── data/
│   └── services/
│       └── stopwatch_persistence_service.dart
├── main.dart
└── ui/
    └── features/
        └── stopwatch/
            ├── models/
            │   └── lap.dart
            ├── view_models/
            │   └── stopwatch_view_model.dart
            └── views/
                ├── stopwatch_screen.dart
                └── widgets/
                    ├── analog_display.dart
                    ├── clock_page_indicator.dart
                    ├── digital_display.dart
                    ├── lap_list_view.dart
                    ├── lap_row.dart
                    └── stopwatch_controls.dart
```

## Testing

Run unit and widget tests:

```bash
flutter test
```

Run static analysis:

```bash
dart analyze
```

## Getting Started

### Prerequisites

- Flutter SDK (3.x or higher)

### Run Application

```bash
# Desktop (Linux / macOS / Windows)
flutter run -d linux

# Web
flutter run -d chrome

# Web server (accessible across local network)
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```
