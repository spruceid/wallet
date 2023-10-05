//╔═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//║ Logger
//║    A unified logging system.
//╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

library log;

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━┓
//┃                                                                                                                  ┃ Imports ┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━┛

import 'dart:convert';                   // for jsonEncode()
import 'package:fpdart/fpdart.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━┓
//┃                                                                                                                  ┃ Globals ┃
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━┛

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ Instance: log
//┃    This is a globally visible instance of SpruceLogger; this is done primarily to allow for minimal boilerplate code when
//┃ writing logs.  It's perhaps not lovely, but the obvious alternatives aren't particularly elegant either.
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

final SpruceLogger log = SpruceLogger();

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ Enum: LogLevel
//┃    Defines the different logging levels available.  Later values in the enum are higher verbosity.
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum LogLevel { off, error, warn, info }

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ Enum: LoggerInitState
//┃    Defines the state of logger initialization; in particular, whether it is configured yet.
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum LoggerInitState { uninitialized, preparing, ready }

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ Class: SpruceLogSubsystem
//┃    A data class for storing information about a logging subsystem.
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class SpruceLogSubsystem
{
  String   tag;           // The value that goes in the [TAG] field in log statements.
  LogLevel fileVerbosity; // Verbosity when logging messages from this subsystem to a file.
  LogLevel netVerbosity;  // Verbosity when logging messages from this subsystem directly to the server.
  bool     timestamp;     // Whether this log subsystem displays timestamps.
  bool     location;      // Whether this log subsystem displays code locations.

  SpruceLogSubsystem(this.tag, this.fileVerbosity, this.netVerbosity, this.timestamp, this.location);
}

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ Class: SpruceLog
//┃    A data class for storing logs.
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class SpruceLog {
  Symbol subsystem;
  LogLevel logLevel;
  String timestamp;
  String location;
  String message;

  SpruceLog(this.subsystem, this.logLevel, this.timestamp, this.location,
      this.message);
}

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ Class: SpruceLogger
//┃    The class holding the various logging methods, plus metadata about log subsystems.
//┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class SpruceLogger
{
  static final SpruceLogger _instance       = SpruceLogger._();
  static const               linebreak      = 512;  // Max cols before linebreak.
  static const               autoflush      =  32;  // Automatically flush whenever we accumulate this many logs.
  LoggerInitState            _initState     = LoggerInitState.uninitialized;
  String                     _logServiceURL = '';
  bool                       _uploadingLogs = false;
  var                        subsystems     = <Symbol, SpruceLogSubsystem>{};    // Subsystem assoc array.
  List<SpruceLog>            logAccum       = [];                                // Log accumulator.
  SpruceLogSubsystem         defsys         = SpruceLogSubsystem('???',          // Fallback log subsystem.
                                                                 LogLevel.info,  // File verbosity.
                                                                 LogLevel.info, // Net verbosity.
                                                                 true,           // Timestamps.
                                                                 true);          // Locations.
  LogLevel                   fileVerbosity  = LogLevel.info;                     // Global file verbosity.
  LogLevel                   netVerbosity   = LogLevel.info;                     // Global net verbosity.
  bool                       disablePii     = false;                             // Should be true for release.
  String                     correlationId  = '';

  factory SpruceLogger() {
    return _instance;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Constructor
  //┃    The constructor for the SpruceLogger class.
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  SpruceLogger._() {
    // TODO: Make sure we have firebase stuff fetched so we know verbosities.
    // What do we do before those calls come in?  Queue?

    // NOTE: The tag values don't need to be three letters; they can be any arbitrary printable string.  They will be
    // prefixed on all logs, though, so short and unique is best.

    subsystems[#action     ] = SpruceLogSubsystem('ACT', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#attestation] = SpruceLogSubsystem('ATT', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#ble        ] = SpruceLogSubsystem('BLE', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#config     ] = SpruceLogSubsystem('CFG', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#cred       ] = SpruceLogSubsystem('CRD', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#der        ] = SpruceLogSubsystem('DER', LogLevel.error, LogLevel.error, true, true);
    subsystems[#did        ] = SpruceLogSubsystem('DID', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#dio        ] = SpruceLogSubsystem('DIO', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#events     ] = SpruceLogSubsystem('EVE', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#gui        ] = SpruceLogSubsystem('GUI', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#keygen     ] = SpruceLogSubsystem('KEY', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#logger     ] = SpruceLogSubsystem('LOG', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#markdown   ] = SpruceLogSubsystem('MKD', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#mdoc       ] = SpruceLogSubsystem('MDK', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#mnemonic   ] = SpruceLogSubsystem('MNM', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#net        ] = SpruceLogSubsystem('NET', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#profile    ] = SpruceLogSubsystem('PRF', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#present    ] = SpruceLogSubsystem('PNT', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#qrcode     ] = SpruceLogSubsystem('QRC', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#sentry     ] = SpruceLogSubsystem('SEN', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#system     ] = SpruceLogSubsystem('SYS', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#splash     ] = SpruceLogSubsystem('SPL', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#truage     ] = SpruceLogSubsystem('TRU', LogLevel.info,  LogLevel.error, true, true);
    subsystems[#authWelcome] = SpruceLogSubsystem('AWC', LogLevel.info,  LogLevel.error, true, true);


    _attemptInit();
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _attemptInit()
  //│    To fully light up the logger, we need access to the config data, which requires getting the IBM token and making a
  //│ call to the /logging/config endpoint.  We can't stall the logger while we're waiting for that to happen or we could miss
  //│ important things, and the IBM token in particular sometimes simply isn't ready for use.  To mitigate this, we attempt
  //│ to init in the background until we succeed.
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  void _attemptInit() async
  {
    if(_initState != LoggerInitState.uninitialized) return;

    _initState = LoggerInitState.preparing;

    _initState = LoggerInitState.ready;
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: logSubsystem()
  //│    Make a log subsystem and associate it with the supplied symbol.  This will overwrite a system if the symbol was
  //│ already in use.
  //│
  //│ Arguments:
  //│    sys       → the symbol which refers to the log subsystem
  //│    tag       → the [TAG] string
  //│    timestamp → whether to display timestamps
  //│    location  → whether to display code locations
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  void logSubsystem(Symbol sys, String tag, bool timestamp, bool location)
  {
    subsystems[sys] = SpruceLogSubsystem(tag, LogLevel.info, LogLevel.error, timestamp, location);
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _noLogging()
  //│    Check whether logging is disabled.
  //│
  //│ Returns:
  //│    `true` if logging is disabled, `false` otherwise.
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  bool _noLogging()
  {
    _attemptInit(); // Try to make sure we're lit up properly.

    // TODO: check remote disable via firebase
    // TODO: It might actually make more sense to have a second stub logger that does nothing, and sub that in to `log` above
    // when logging is disabled.

    return false; //(const String.fromEnvironment('DEBUG') != null); // something is screwy here.
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _location()
  //│    Return a code location string, if enabled.  Gloriously, Dart doesn't have file/line/function macros or the like, so
  //│ we extract the required information from a stack trace.  I imagine this isn't cheap, but we don't do the work if `enable`
  //│ isn't set.
  //│
  //│ Arguments:
  //│    enable → whether to return a location
  //│
  //│ Returns:
  //│    A code location string if `enable` is true, otherwise an empty string.
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  String _location(bool enable) {
    if (!enable) return '';

    final st       = StackTrace.current;
    final frames   = st.toString().split('\n');
    final re       = RegExp(r'^#\d+\s+(.+)\s+\(package:([^/]+)/(.+.\w):(\d+)\)$');
    final matches  = re.allMatches(frames[2]); // We want one frame above the frame that called us.
    final match    = matches.elementAt(0);
    final function = match.group(1) ?? '?()';
    final file     = match.group(2) ?? '/??';
    final line     = match.group(3) ?? '??';

    return '$file:$line: $function ';
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _subsystem()
  //│    Get the subsystem matching the specified symbol, or create a one if necessary.
  //│
  //│ Arguments:
  //│    sys → the name of the subsystem
  //│
  //│ Returns:
  //│    Logging subsystem metadata, generated if necessary.
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  SpruceLogSubsystem _subsystem(Symbol sys)
  {
    if(!subsystems.containsKey(sys)) // Synthesize a one if needed.
    {
      final re      = RegExp(r'"(.*)"');
      final matches = re.allMatches(sys.toString());
      final match   = matches.elementAt(0);
      final tag     = match.group(1) ?? sys.toString();

      warn(#logger, 'Unknown log subsystem $tag, creating...');
      subsystems[sys] = SpruceLogSubsystem(tag, LogLevel.info, LogLevel.error, true, true);
    }

    return subsystems[sys] ?? defsys; // This should never fall back.
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _shouldNotLog()
  //│    Check whether the supplied log level passes the verbosity checks.
  //│
  //│ Arguments:
  //│    ls  → the log subsystem
  //│    lvl → the log level
  //│
  //│ Returns:
  //│    Whether the associated log should be emitted or dropped.
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  bool _shouldNotLog(SpruceLogSubsystem ls, LogLevel lvl)
  {
    if(lvl.index > fileVerbosity.index &&            // Global verbosity check.
       lvl.index > netVerbosity.index) return true;

    if(lvl.index > ls.fileVerbosity.index &&         // Subsystem verbosity check.
       lvl.index > ls.netVerbosity.index) return true;

    return false;                              // We're good!
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _timestamp()
  //│    Return an ISO-8601 timestamp string if enabled.
  //│
  //│ Arguments:
  //│    enable → whether to return a timestamp
  //│
  //│ Returns:
  //│    An ISO-8601 formatted timestamp string if `enable` is true, otherwise an empty string.
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  String _timestamp(bool enable) {
    if (!enable) return '';

    return '${DateTime.now().toUtc().toIso8601String()} ';
  }

  //╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  //│ Local-Method: _log()
  //│    Log a string, with metadata.  The metadata (timestamp, tag...) are strings, but may be empty strings depending on
  //│ settings for the log subsystem the log was sent to.
  //│
  //│ Arguments:
  //│    timestamp → the timestamp string
  //│    tag       → the subsystem tag
  //│    marker    → a marker string such as 'WARN:'
  //│    location  → the code location
  //│    s         → the string to be logged
  //╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  void _log(Symbol subsystem, LogLevel logLevel, String timestamp, String tag, String marker, String location, String s) async
  {
    // TODO: We might want to modify this so that if s.length < linebreak we print with the metadata normally, but otherwise
    // we print the metadata and a newline, and then add these raw.  The potential problem there is we may need some locking
    // to prevent logs from interleaving.  Dart is aggressively single threaded, though so maybe not?

    // If we do, we could use ⎛, ⎜ and ⎝ to delineate.

    final file = (fileVerbosity.index >= logLevel.index);

    for(var i = 0; i < s.length; i += linebreak)
    {
      var start = i;
      var end = i + linebreak;
      if (end > s.length) end = (s.length);

      final out = '$timestamp[$tag] $marker$location${s.substring(start, end)}';

      if (file) {
        debugPrint(out);
      }
    }
  }




  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: err()
  //┃    Log an error, if verbosity is set high enough.  This is intended for severe or fatal situations, where if we're logging
  //┃ _at all_ we should report.
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Unit err(Symbol sys, String s) {
    if (_noLogging()) return unit;

    final ls = _subsystem(sys);

    if(_shouldNotLog(ls, LogLevel.error)) return unit;

    _log(sys, LogLevel.error, _timestamp(ls.timestamp), ls.tag, 'ERROR: ',
        _location(ls.location), s);
    return unit;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: errTe()
  //┃    Log an error, if verbosity is set high enough.  This is intended for severe or fatal situations, where if we're logging
  //┃ _at all_ we should report.
  //┃
  //┃    This version of the function will append the left, or "error" value of the TaskEither to the message s, and returns a function
  //┃    that returns a TaskEither for easier composition.
  //┃
  //┃    Generally, this function should be passed as an argument to TaskEither.orElse
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  TaskEither<L, R> Function(L l) errTe<L, R>(Symbol sys, String s) =>
    (L l) {
      err(sys, '$s: ${l.toString()}'); // TODO: Expand err() inline here; this breaks _location()'s magic.
      return TaskEither.left(l);
    };

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: errPii()
  //┃    Log an error with personally identifiable information, if verbosity is set high enough and PII logging is enabled.
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Unit errPii(Symbol sys, String s) {
    if (_noLogging() || disablePii) return unit;

    final ls = _subsystem(sys);

    if(_shouldNotLog(ls, LogLevel.error)) return unit;

    _log(sys, LogLevel.error, _timestamp(ls.timestamp), ls.tag, 'ERROR: ',
        _location(ls.location), s);
    return unit;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: errPiiTe()
  //┃    Log an error with personally identifiable information, if verbosity is set high enough and PII logging is enabled.
  //┃
  //┃    This version of the function returns a function that returns a TaskEither for easier composition.  It operates on the
  //┃    left, or "error" value in a task either and should be generally be an argument to TaskEither.orElse
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  TaskEither<L, R> Function(L l) errPiiTe<L, R>(Symbol sys, String s) =>
    (L l) {
      errPii(sys, '$s: ${l.toString()}'); // TODO: Expand errPii() inline here; this breaks _location()'s magic.
      return TaskEither.left(l);
    };

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: warn()
  //┃    Log a warning, if verbosity is set high enough.  This is for non-fatal but unexpected things; a REST call failing,
  //┃ perhaps, or creating a resource that should have been cached but is missing (perhaps because this is the initial run of
  //┃ the app).
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Unit warn(Symbol sys, String s) {
    if (_noLogging()) return unit;

    final ls = _subsystem(sys);

    if(_shouldNotLog(ls, LogLevel.warn)) return unit;

    _log(sys, LogLevel.warn, _timestamp(ls.timestamp), ls.tag, 'WARN: ',
        _location(ls.location), s);
    return unit;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: warnPii()
  //┃    Log a warning with personally identifiable information, if verbosity is set high enough and PII logging is enabled.
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Unit warnPii(Symbol sys, String s) {
    if (_noLogging() || disablePii) return unit;

    final ls = _subsystem(sys);

    if(_shouldNotLog(ls, LogLevel.warn)) return unit;

    _log(sys, LogLevel.warn, _timestamp(ls.timestamp), ls.tag, 'WARN: ',
        _location(ls.location), s);
    return unit;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: info()
  //┃    Log information, if verbosity is set high enough.  This level of logging is intended for ongoing progress notification
  //┃ and the like; most of the time it's likely not useful, but when you're trying to track down what went wrong, it provides
  //┃ some context.
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Unit info(Symbol sys, String s) {
    if (_noLogging()) return unit;

    final ls = _subsystem(sys);

    if(_shouldNotLog(ls, LogLevel.info)) return unit;

    _log(sys, LogLevel.info, _timestamp(ls.timestamp), ls.tag, '',
        _location(ls.location), s);
    return unit;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: infoTe()
  //┃    Log information, if verbosity is set high enough.  This level of logging is intended for ongoing progress notification
  //┃ and the like; most of the time it's likely not useful, but when you're trying to track down what went wrong, it provides
  //┃ some context.
  //┃
  //┃ This version of the function returns a function that returns a TaskEither for easier composition
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  TaskEither<L, R> Function(R r) infoTe<L, R>(Symbol sys, String s) => (R r) {
        info(sys,
            s); // TODO: Expand info() inline here; this breaks _location()'s magic.
        return TaskEither.right(r);
      };

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: infoPii()
  //┃    Log information with personally identifiable info, if verbosity is set high enough and PII logging is enabled.
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Unit infoPii(Symbol sys, String s) {
    if (_noLogging() || disablePii) return unit;

    final ls = _subsystem(sys);

    if(_shouldNotLog(ls, LogLevel.info)) return unit;

    _log(sys, LogLevel.info, _timestamp(ls.timestamp), ls.tag, '',
        _location(ls.location), s);
    return unit;
  }

  //┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //┃ Method: infoPiiTe()
  //┃    Log information with personally identifiable info, if verbosity is set high enough and PII logging is enabled.
  //┃    This version of the function returns a function that returns a TaskEither for easier composition
  //┃
  //┃ Arguments:
  //┃    sys → the log system to which this log belongs
  //┃    s   → the string to log
  //┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  TaskEither<L, R> Function(R val) infoPiiTe<L, R>(Symbol sys, String s) =>
      (R r) {
        infoPii(sys,
            s); // TODO: Expand infoPii() inline here; this breaks _location()'s magic.
        return TaskEither.right(r);
      };
}
