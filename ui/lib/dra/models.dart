/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 21/12/16
 * Author     : bwnyasse
 *  
 */
part of led_ui;

typedef String ResponsePreprocessor(String s);

class ServerReference {
  final Uri uri;
  http.Client client;

  ServerReference(this.uri, [this.client]);

  Uri buildUri(String path, Map<String, String> queryParameters) {
    return new Uri(
        scheme: uri.scheme,
        userInfo: uri.userInfo,
        host: uri.host,
        port: uri.port,
        path: path,
        queryParameters: queryParameters);
  }
}

class ResponseStream {
  StreamController<String> _dataFlow;

  ResponseStream() : _dataFlow = new StreamController();

  Stream<String> get flow => _dataFlow.stream.transform(new LineSplitter());

  void add(String data) => _dataFlow.add(data);
}

class RequestType {
  static const post = const RequestType('POST');
  static const get = const RequestType('GET');

  final String value;

  const RequestType(this.value);

  @override
  String toString() => value;
}

/// Error thrown
class DockerRemoteApiError {
  final int statusCode;
  final String reason;
  final String body;

  DockerRemoteApiError(this.statusCode, this.reason, this.body);

  @override
  String toString() =>
      '${super.toString()} - StatusCode: ${statusCode}, Reason: ${reason}, Body: ${body}';
}

abstract class AsJsonReponse {

  Map _asJson;
  String _asPrettyJson;

  AsJsonReponse.fromJson(Map json, Version apiVersion) {
    _asJson = json;
    _asPrettyJson =new JsonEncoder.withIndent('  ').convert(json);
  }
}

class Version implements Comparable {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch) {
    if (major == null || major < 0) {
      throw new ArgumentError('"major" must not be null and must not be < 0.');
    }
    if (minor == null || minor < 0) {
      throw new ArgumentError('"minor" must not be null and must not be < 0.');
    }
    if (patch != null && patch < 0) {
      throw new ArgumentError('If "patch" is provided the value must be >= 0.');
    }
  }

  factory Version.fromString(String version) {
    assert(version != null && version.isNotEmpty);
    final parts = version.split('.');
    int major = 0;
    int minor = 0;
    int patch;

    if (parts.length < 2) {
      throw 'Unsupported version string format "${version}".';
    }

    if (parts.length >= 1) {
      major = int.parse(parts[0]);
    }
    if (parts.length >= 2) {
      minor = int.parse(parts[1]);
    }
    if (parts.length >= 3) {
      patch = int.parse(parts[2]);
    }
    if (parts.length >= 4) {
      throw 'Unsupported version string format "${version}".';
    }
    return new Version(major, minor, patch);
  }

  @override
  bool operator ==(other) {
    if (other is! Version) {
      return false;
    }
    final o = other as Version;
    return o.major == major &&
        o.minor == minor &&
        ((o.patch == null && patch == null) || (o.patch == patch));
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() => '${major}.${minor}${patch != null ? '.${patch}' : ''}';

  bool operator <(Version other) {
    assert(other != null);
    if (major < other.major) {
      return true;
    } else if (major > other.major) {
      return false;
    }
    if (minor < other.minor) {
      return true;
    } else if (minor > other.minor) {
      return false;
    }
    if (patch == null && other.patch == null) {
      return false;
    }
    if (patch == null || other.patch == null) {
      throw 'Only version with an equal number of parts can be compared.';
    }
    if (patch < other.patch) {
      return true;
    }
    return false;
  }

  bool operator >(Version other) {
    return other != this && !(this < other);
  }

  bool operator >=(Version other) {
    return this == other || this > other;
  }

  bool operator <=(Version other) {
    return this == other || this < other;
  }

  @override
  int compareTo(Version other) {
    if (this < other) {
      return -1;
    } else if (this == other) {
      return 0;
    }
    return 1;
  }

  static int compare(Comparable a, Comparable b) => a.compareTo(b);
}

/*
Example request: GET /version HTTP/1.1
Example response:

HTTP/1.1 200 OK
Content-Type: application/json

{
"Version": "1.12.0",
"Os": "linux",
"KernelVersion": "3.19.0-23-generic",
"GoVersion": "go1.6.3",
"GitCommit": "deadbee",
"Arch": "amd64",
"ApiVersion": "1.24",
"BuildTime": "2016-06-14T07:09:13.444803460+00:00",
"Experimental": true
}
*/
class VersionResponse extends AsJsonReponse{
  Version _version;
  Version get version => _version;

  String _os;
  String get os => _os;

  String _kernelVersion;
  String get kernelVersion => _kernelVersion;

  String _goVersion;
  String get goVersion => _goVersion;

  String _gitCommit;
  String get gitCommit => _gitCommit;

  String _architecture;
  String get architecture => _architecture;

  Version _apiVersion;
  Version get apiVersion => _apiVersion;


  VersionResponse.fromJson(Map json, Version apiVersion) : super.fromJson(json, apiVersion) {
    _version = new Version.fromString(json['Version']);
    _os = json['Os'];
    _kernelVersion = json['KernelVersion'];
    _goVersion = json['GoVersion'];
    _gitCommit = json['GitCommit'];
    _architecture = json['Arch'];
    _apiVersion = new Version.fromString(json['ApiVersion']);
  }
}


/// Response to the info request.
class InfoResponse extends AsJsonReponse{
  int _containers;
  int get containers => _containers;

  int _containersRunning;
  int get containersRunning => _containersRunning;

  int _containersStopped;
  int get containersStopped => _containersStopped;

  int _containersPaused;
  int get containersPaused => _containersPaused;

  bool _cpuCfsPeriod;
  bool get cpuCfsPeriod => _cpuCfsPeriod;

  bool _cpuCfsQuota;
  bool get cpuCfsQuota => _cpuCfsQuota;

  bool _debug;
  bool get debug => _debug;

  String _dockerRootDir;
  String get dockerRootDir => _dockerRootDir;

  String _driver;
  String get driver => _driver;

  UnmodifiableListView<List<List>> _driverStatus;
  UnmodifiableListView<List<List>> get driverStatus => _driverStatus;

  String _executionDriver;
  String get executionDriver => _executionDriver;

  bool _experimentalBuild;
  bool get experimentalBuild => _experimentalBuild;

  int _fdCount;
  int get fdCount => _fdCount;

  int _goroutinesCount;
  int get goroutinesCount => _goroutinesCount;

  String _httpProxy;
  String get httpProxy => _httpProxy;

  String _httpsProxy;
  String get httpsProxy => _httpsProxy;

  String _id;
  String get id => _id;

  int _images;
  int get images => _images;

  UnmodifiableListView<String> _indexServerAddress;
  UnmodifiableListView<String> get indexServerAddress => _indexServerAddress;

  String _initPath;
  String get initPath => _initPath;

  String _initSha1;
  String get initSha1 => _initSha1;

  bool _ipv4Forwarding;
  bool get ipv4Forwarding => _ipv4Forwarding;

  String _kernelVersion;
  String get kernelVersion => _kernelVersion;

  UnmodifiableMapView<String, String> _labels;
  UnmodifiableMapView<String, String> get labels => _labels;

  String _loggingDriver;
  String get loggingDriver => _loggingDriver;

  bool _memoryLimit;
  bool get memoryLimit => _memoryLimit;

  int _memTotal;
  int get memTotal => _memTotal;

  String _name;
  String get name => _name;

  int _cpuCount;
  int get cpuCount => _cpuCount;

  int _eventsListenersCount;
  int get eventsListenersCount => _eventsListenersCount;

  String _noProxy;
  String get noProxy => _noProxy;

  bool _oomKillDisable;
  bool get oomKillDisable => _oomKillDisable;

  String _operatingSystem;
  String get operatingSystem => _operatingSystem;

  RegistryConfigs _registryConfigs;
  RegistryConfigs get registryConfigs => _registryConfigs;

  bool _swapLimit;
  bool get swapLimit => _swapLimit;

  DateTime _systemTime;
  DateTime get systemTime => _systemTime;

  InfoResponse.fromJson(Map json, Version apiVersion) : super.fromJson(json, apiVersion) {
    _containers = json['Containers'];
    _containersRunning = json['ContainersRunning'];
    _containersStopped = json['ContainersStopped'];
    _containersPaused = json['ContainersPaused'];
    _cpuCfsPeriod = json['CpuCfsPeriod'];
    _cpuCfsQuota = json['CpuCfsQuota'];
    _debug = _parseBool(json['Debug']);
    _dockerRootDir = json['DockerRootDir'];
    _driver = json['Driver'];
    _driverStatus = _toUnmodifiableListView(json['DriverStatus']);
    _executionDriver = json['ExecutionDriver'];
    _experimentalBuild = json['ExperimentalBuild'];
    _httpProxy = json['HttpProxy'];
    _httpsProxy = json['HttpsProxy'];
    _id = json['ID'];
    _images = json['Images'];
    _indexServerAddress = json['IndexServerAddress'] is String
        ? _toUnmodifiableListView([json['IndexServerAddress']])
        : _toUnmodifiableListView(json['IndexServerAddress']);
    _initPath = json['InitPath'];
    _initSha1 = json['InitSha1'];
    _ipv4Forwarding = _parseBool(json['IPv4Forwarding']);
    _kernelVersion = json['KernelVersion'];
    _labels = _parseLabels(json['Labels']);
    _loggingDriver = json['LoggingDriver'];
    _memoryLimit = _parseBool(json['MemoryLimit']);
    _memTotal = json['MemTotal'];
    _name = json['Name'];
    _cpuCount = json['NCPU'];
    _eventsListenersCount = json['NEventsListener'];
    _fdCount = json['NFd'];
    _goroutinesCount = json['NGoroutines'];
    _noProxy = json['NoProxy'];
    _oomKillDisable = json['OomKillDisable'];
    _operatingSystem = json['OperatingSystem'];
    _registryConfigs =
    new RegistryConfigs.fromJson(json['RegistryConfigs']);
    _swapLimit = _parseBool(json['SwapLimit']);
    _systemTime = _parseDate(json['SystemTime']);

  }
}

/// Basic info about a container.
class Container {
  String _id;
  String get id => _id;

  String _command;
  String get command => _command;

  DateTime _created;
  DateTime get created => _created;

  UnmodifiableMapView _labels;
  UnmodifiableMapView get labels => _labels;

  String _image;
  String get image => _image;

  List<String> _names;
  List<String> get names => _names;

  List<PortArgument> _ports;
  List<PortArgument> get ports => _ports;

  String _status;
  String get status => _status;

  Container(this._id);

  Container.fromJson(Map json, Version apiVersion) {
    _id = json['Id'];
    _command = json['Command'];
    _created = _parseDate(json['Created']);
    _labels = _parseLabels(json['Labels']);
    _image = json['Image'];
    _names = json['Names'];
    _ports = json['Ports'] == null
        ? null
        : json['Ports']
        .map((p) => new PortResponse.fromJson(p, apiVersion))
        .toList();
    _status = json['Status'];

  }

  Map toJson() {
    final json = {};
    if (id != null) json['Id'] = id;
    if (command != null) json['Command'] = command;
    if (created != null) json['Created'] = created.toIso8601String();
    if (image != null) json['Image'] = image;
    if (names != null) json['Names'] = names;
    if (ports != null) json['Ports'] = ports;
    if (status != null) json['Status'] = status;
    return json;
  }
}

class PortArgument {
  final String hostIp;
  final int host;
  final int container;
  final String name;
  const PortArgument(this.host, this.container, {this.name: null, this.hostIp});
  String toDockerArgument() {
    assert(container != null && container > 0);

    if (hostIp != null && hostIp.isNotEmpty) {
      if (host != null) {
        return '${hostIp}:${host}:${container}';
      } else {
        return '${hostIp}::${container}';
      }
    } else {
      if (host != null) {
        return '${host}:${container}';
      } else {
        return '${container}';
      }
    }
  }
}

class PortResponse {
  String _ip;
  String get ip => _ip;

  int _privatePort;
  int get privatePort => _privatePort;

  int _publicPort;
  int get publicPort => _publicPort;

  String _type;
  String get type => _type;

  PortResponse.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _ip = json['IP'];
    _privatePort = json['PrivatePort'];
    _publicPort = json['PublicPort'];
    _type = json['Type'];
  }
}

/// Information about an image returned by 'inspect'
class ImageInfo {
  String _architecture;
  String get architecture => _architecture;

  String _author;
  String get author => _author;

  String _comment;
  String get comment => _comment;

  Config _config;
  Config get config => _config;

  String _container;
  String get container => _container;

  Config _containerConfig;
  Config get containerConfig => _containerConfig;

  DateTime _created;
  DateTime get created => _created;

  String _dockerVersion;
  String get dockerVersion => _dockerVersion;

  String _id;
  String get id => _id;

  UnmodifiableMapView<String, String> _labels;
  UnmodifiableMapView<String, String> get labels => _labels;

  String _os;
  String get os => _os;

  String _parent;
  String get parent => _parent;

  int _size;
  int get size => _size;

  int _virtualSize;
  int get virtualSize => _virtualSize;

  UnmodifiableListView<String> _repoDigests;
  UnmodifiableListView<String> get repoDigests => _repoDigests;

  UnmodifiableListView<String> _repoTags;
  UnmodifiableListView<String> get repoTags => _repoTags;

  ImageInfo.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _architecture = json['Architecture'];
    _author = json['Author'];
    _comment = json['Comment'];
    _config = new Config.fromJson(json['Config'], apiVersion);
    _container = json['Container'];
    _containerConfig = new Config.fromJson(json['ContainerConfig'], apiVersion);
    _created = _parseDate(json['Created']);
    _dockerVersion = json['DockerVersion'];
    _id = json['Id'];
    _labels = _parseLabels(json['Labels']);
    _os = json['Os'];
    // depending on the request `Parent` or `ParentId` is set.
    _parent = json['Parent'];
    _parent = json['ParentId'] != null ? json['ParentId'] : null;
    _size = json['Size'];
    _virtualSize = json['VirtualSize'];
    _repoDigests = _toUnmodifiableListView(json['RepoDigests']);
    _repoTags = _toUnmodifiableListView(json['RepoTags']);

  }
}

class ContainerInfo {
  String _appArmorProfile;
  String get appArmorProfile => _appArmorProfile;

  String _appliedVolumesFrom; // ExecInfo
  String get appliedVolumesFrom => _appliedVolumesFrom;

  UnmodifiableListView<String> _args;
  UnmodifiableListView<String> get args => _args;

  Config _config;
  Config get config => _config;

  DateTime _created;
  DateTime get created => _created;

  String _driver;
  String get driver => _driver;

  String _execDriver;
  String get execDriver => _execDriver;

  String _execIds;
  String get execIds => _execIds;

  HostConfig _hostConfig;
  HostConfig get hostConfig => _hostConfig;

  String _hostnamePath;
  String get hostnamePath => _hostnamePath;

  String _hostsPath;
  String get hostsPath => _hostsPath;

  String _id;
  String get id => _id;

  String _image;
  String get image => _image;

  String _logPath;
  String get logPath => _logPath;

  String _mountLabel;
  String get mountLabel => _mountLabel;

  UnmodifiableMapView<String, UnmodifiableListView<String>> _mountPoints; // TODO add generic type with actual data
  UnmodifiableMapView<String, UnmodifiableListView<String>> get mountPoints =>
      _mountPoints;

  String _name;
  String get name => _name;

  NetworkSettings _networkSettings;
  NetworkSettings get networkSettings => _networkSettings;

  String _path;
  String get path => _path;

  String _processLabel;
  String get processLabel => _processLabel;

  String _resolveConfPath;
  String get resolveConfPath => _resolveConfPath;

  int _restartCount;
  int get restartCount => _restartCount;

  State _state;
  State get state => _state;

  Volumes _volumes;
  Volumes get volumes => _volumes;

  VolumesRw _volumesRw;
  VolumesRw get volumesRw => _volumesRw;

  bool _updateDns;
  bool get updateDns => _updateDns;

  ContainerInfo.fromJson(Map json, Version apiVersion) {
    _appArmorProfile = json['AppArmorProfile'];
    _appliedVolumesFrom = json['AppliedVolumesFrom'];
    _args = _toUnmodifiableListView(json['Args']);
    _config = new Config.fromJson(json['Config'], apiVersion);
    _created = _parseDate(json['Created']);
    _driver = json['Driver'];
    _execDriver = json['ExecDriver'];
    _execIds = json['ExecIDs'];
    _hostConfig = new HostConfig.fromJson(json['HostConfig'], apiVersion);
    _hostnamePath = json['HostnamePath'];
    _hostsPath = json['HostsPath'];
    if (json.containsKey('Id')) {
      _id = json['Id'];
    } else if (json.containsKey('ID')) {
      _id = json['ID']; // ExecInfo
    }
    _image = json['Image'];
    _logPath = json['LogPath'];
    _mountLabel = json['MountLabel'];
    _mountPoints = _toUnmodifiableMapView(
        json['MountPoints']); // TODO check with actual data
    _name = json['Name'];
    _networkSettings =
    new NetworkSettings.fromJson(json['NetworkSettings'], apiVersion);
    _path = json['Path'];
    _processLabel = json['ProcessLabel'];
    _resolveConfPath = json['ResolvConfPath'];
    _restartCount = json['RestartCount'];
    _state = new State.fromJson(json['State'], apiVersion);
    _updateDns = json['UpdateDns'];
    _volumes = new Volumes.fromJson(json['Volumes'], apiVersion);
    _volumesRw = new VolumesRw.fromJson(json['VolumesRW'], apiVersion);

  }

  Map toJson() {
    final json = {};
    if (appArmorProfile != null) json['AppArmorProfile'] = appArmorProfile;
    if (args != null) json['Args'] = args;
    if (config != null) json['Config'] = config.toJson();
    if (created == null) json['Created'] = _created.toIso8601String();
    if (driver != null) json['Driver'] = driver;
    if (execDriver != null) json['ExecDriver'] = execDriver;
    if (hostConfig != null) json['HostConfig'] = hostConfig.toJson();
    if (hostnamePath != null) json['HostnamePath'] = hostnamePath;
    if (hostsPath != null) json['HostsPath'] = hostsPath;
    if (id != null) json['Id'] = id;
    if (image != null) json['Image'] = image;
    if (mountLabel != null) json['MountLabel'] = mountLabel;
    if (mountPoints != null) json['MountPoints'] = mountPoints;
    if (name != null) json['Name'] = name;
    if (networkSettings != null) json['NetworkSettings'] =
        networkSettings.toJson();
    if (path != null) json['Path'] = path;
    if (processLabel != null) json['ProcessLabel'] = processLabel;
    if (resolveConfPath != null) json['ResolvConfPath'] = resolveConfPath;
    if (state != null) json['State'] = state.toJson();
    if (volumes != null) json['Volumes'] = volumes.toJson();
    if (volumesRw != null) json['VolumesRW'] = volumesRw.toJson();
    return json;
  }
}

class RegistryConfigs {
  UnmodifiableMapView _indexConfigs;
  UnmodifiableMapView get indexConfigs => _indexConfigs;

  UnmodifiableListView<String> _insecureRegistryCidrs;
  UnmodifiableListView<String> get insecureRegistryCidrs =>
      _insecureRegistryCidrs;

  RegistryConfigs.fromJson(Map json) {
    if (json == null) {
      return;
    }

    _indexConfigs = _toUnmodifiableMapView(json['IndexConfigs']);
    _insecureRegistryCidrs =
        _toUnmodifiableListView(json['InsecureRegistryCIDRs']);
  }
}

class VolumesRw {
  VolumesRw.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
  }

  Map toJson() {
    return null;
//    final json = {};
//    return json;
  }
}

class NetworkSettings {
  String _bridge;
  String get bridge => _bridge;

  String _endpointId;
  String get endpointId => _endpointId;

  String _gateway;
  String get gateway => _gateway;

  String _globalIPv6Address;
  String get globalIPv6Address => _globalIPv6Address;

  int _globalIPv6PrefixLen;
  int get globalIPv6PrefixLen => _globalIPv6PrefixLen;

  bool _hairpinMode;
  bool get hairpinMode => _hairpinMode;

  String _ipAddress;
  String get ipAddress => _ipAddress;

  int _ipPrefixLen;
  int get ipPrefixLen => _ipPrefixLen;

  String _ipv6Gateway;
  String get ipv6Gateway => _ipv6Gateway;

  String _linkLocalIPv6Address;
  String get linkLocalIPv6Address => _linkLocalIPv6Address;

  int _linkLocalIPv6PrefixLen;
  int get linkLocalIPv6PrefixLen => _linkLocalIPv6PrefixLen;

  String _macAddress;
  String get macAddress => _macAddress;

  String _networkId;
  String get networkId => _networkId;

  UnmodifiableMapView _portMapping;
  UnmodifiableMapView get portMapping => _portMapping;

  UnmodifiableMapView _ports;
  UnmodifiableMapView get ports => _ports;

  String _sandboxKey;
  String get sandboxKey => _sandboxKey;

  UnmodifiableListView _secondaryIPAddresses;
  UnmodifiableListView get secondaryIPAddresses => _secondaryIPAddresses;

  UnmodifiableListView _secondaryIPv6Addresses;
  UnmodifiableListView get secondaryIPv6Addresses => _secondaryIPv6Addresses;

  NetworkSettings.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _bridge = json['Bridge'];
    _endpointId = json['EndpointID'];
    _gateway = json['Gateway'];
    _globalIPv6Address = json['GlobalIPv6Address'];
    _globalIPv6PrefixLen = json['GlobalIPv6PrefixLen'];
    _hairpinMode = json['HairpinMode'];
    _ipAddress = json['IPAddress'];
    _ipPrefixLen = json['IPPrefixLen'];
    _ipv6Gateway = json['IPv6Gateway'];
    _linkLocalIPv6Address = json['LinkLocalIPv6Address'];
    _linkLocalIPv6PrefixLen = json['LinkLocalIPv6PrefixLen'];
    _macAddress = json['MacAddress'];
    _networkId = json['NetworkID'];
    _portMapping = _toUnmodifiableMapView(json['PortMapping']);
    _ports = _toUnmodifiableMapView(json['Ports']);
    _sandboxKey = json['SandboxKey'];
    _secondaryIPAddresses =
        _toUnmodifiableListView(json['SecondaryIPAddresses']);
    _secondaryIPv6Addresses =
        _toUnmodifiableListView(json['SecondaryIPv6Addresses']);
  }

  Map toJson() {
    final json = {};
    if (bridge != null) json['Bridge'] = bridge;
    if (endpointId != null) json['EndpointID'] = endpointId;
    if (gateway != null) json['Gateway'] = gateway;
    if (globalIPv6Address != null) json['GlobalIPv6Address'] =
        globalIPv6Address;
    if (globalIPv6PrefixLen != null) json['GlobalIPv6PrefixLen'] =
        globalIPv6PrefixLen;
    if (hairpinMode != null) json['HairpinMode'] = hairpinMode;
    if (ipAddress != null) json['IPAddress'] = ipAddress;
    if (ipPrefixLen != null) json['IPPrefixLen'] = ipPrefixLen;
    if (ipv6Gateway != null) json['IPv6Gateway'] = ipv6Gateway;
    if (linkLocalIPv6Address != null) json['LinkLocalIPv6Address'] =
        linkLocalIPv6Address;
    if (linkLocalIPv6PrefixLen != null) json['LinkLocalIPv6PrefixLen'] =
        linkLocalIPv6PrefixLen;
    if (macAddress != null) json['MacAddress'] = macAddress;
    if (portMapping != null) json['PortMapping'] = portMapping;
    if (ports != null) json['Ports'] = ports;
    return json;
  }
}

class State {
  bool _dead;
  bool get dead => _dead;

  String _error;
  String get error => _error;

  int _exitCode;
  int get exitCode => _exitCode;

  DateTime _finishedAt;
  DateTime get finishedAt => _finishedAt;

  bool _outOfMemoryKilled;
  bool get outOfMemoryKilled => _outOfMemoryKilled;

  bool _paused;
  bool get paused => _paused;

  int _pid;
  int get pid => _pid;

  bool _restarting;
  bool get restarting => _restarting;

  bool _running;
  bool get running => _running;

  DateTime _startedAt;
  DateTime get startedAt => _startedAt;

  State.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }

    _dead = json['Dead'];
    _error = json['Error'];
    _exitCode = json['ExitCode'];
    _finishedAt = _parseDate(json['FinishedAt']);
    _outOfMemoryKilled = json['OOMKilled'];
    _paused = json['Paused'];
    _pid = json['Pid'];
    _restarting = json['Restarting'];
    _running = json['Running'];
    _startedAt = _parseDate(json['StartedAt']);
  }

  Map toJson() {
    final json = {};
    if (exitCode != null) json['ExitCode'] = exitCode;
    if (finishedAt != null) json['FinishedAt'] = finishedAt;
    if (paused != null) json['Paused'] = paused;
    if (pid != null) json['Pid'] = pid;
    if (restarting != null) json['Restarting'] = restarting;
    if (running != null) json['Running'] = running;
    if (startedAt != null) json['StartedAt'] = startedAt;
    return json;
  }
}

class Config {
  bool _attachStderr;
  bool get attachStderr => _attachStderr;

  bool _attachStdin;
  bool get attachStdin => _attachStdin;

  bool _attachStdout;
  bool get attachStdout => _attachStdout;

  UnmodifiableListView<String> _cmd;
  UnmodifiableListView<String> get cmd => _cmd;

  int _cpuShares;
  int get cpuShares => _cpuShares;

  String _cpuSet;
  String get cpuSet => _cpuSet;

  String _domainName;
  String get domainName => _domainName;

  String _entryPoint;
  String get entryPoint => _entryPoint;

  UnmodifiableMapView<String, String> _env;
  UnmodifiableMapView<String, String> get env => _env;

  UnmodifiableMapView<String, UnmodifiableMapView<String, String>> _exposedPorts;
  UnmodifiableMapView<String, UnmodifiableMapView<String, String>> get exposedPorts =>
      _exposedPorts;

  String _hostName;
  String get hostName => _hostName;

  String _image;
  String get image => _image;

  UnmodifiableMapView _labels;
  UnmodifiableMapView get labels => _labels;

  String _macAddress;
  String get macAddress => _macAddress;

  String get imageName => _image.split(':')[0];
  String get imageVersion => _image.split(':')[1];

  int _memory;
  int get memory => _memory;

  int _memorySwap;
  int get memorySwap => _memorySwap;

  bool _networkDisabled;
  bool get networkDisabled => _networkDisabled;

  UnmodifiableListView<String> _onBuild;
  UnmodifiableListView<String> get onBuild => _onBuild;

  bool _openStdin;
  bool get openStdin => _openStdin;

  String _portSpecs;
  String get portSpecs => _portSpecs;

  bool _stdinOnce;
  bool get stdinOnce => _stdinOnce;

  bool _tty;
  bool get tty => _tty;

  String _user;
  String get user => _user;

  String _volumeDriver;
  String get volumeDriver => _volumeDriver;

  Volumes _volumes;
  Volumes get volumes => _volumes;

  String _workingDir;
  String get workingDir => _workingDir;

  Config.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _attachStderr = json['AttachStderr'];
    _attachStdin = json['AttachStdin'];
    _attachStdout = json['AttachStdout'];
    _cmd = _toUnmodifiableListView(json['Cmd']);
    _cpuShares = json['CpuShares'];
    _cpuSet = json['Cpuset'];
    _domainName = json['Domainname'];
    _entryPoint = json['Entrypoint'];
    final e = json['Env'];
    if (e != null) {
      _env = _toUnmodifiableMapView(new Map<String, String>.fromIterable(
          e.map((i) => i.split('=')),
          key: (i) => i[0], value: (i) => i.length == 2 ? i[1] : null));
    }
    _exposedPorts = _toUnmodifiableMapView(json['ExposedPorts']);
    _hostName = json['Hostname'];
    _image = json['Image'];
    _labels = _parseLabels(json['Labels']);
    _macAddress = json['MacAddress'];
    _memory = json['Memory'];
    _memorySwap = json['MemorySwap'];
    _networkDisabled = json['NetworkDisabled'];
    _onBuild = _toUnmodifiableListView(json['OnBuild']);
    _openStdin = json['OpenStdin'];
    _portSpecs = json['PortSpecs'];
    _stdinOnce = json['StdinOnce'];
    _tty = json['Tty'];
    _user = json['User'];
    _volumeDriver = json['VolumeDriver'];
    _volumes = new Volumes.fromJson(json['Volumes'], apiVersion);
    _workingDir = json['WorkingDir'];

  }

  Map toJson() {
    final json = {};
    if (attachStderr != null) json['AttachStderr'] = attachStderr;
    if (attachStdin != null) json['AttachStdin'] = attachStdin;
    if (attachStdout != null) json['AttachStdout'] = attachStdout;
    if (cmd != null) json['Cmd'] = cmd;
    if (cpuShares != null) json['CpuShares'] = cpuShares;
    if (cpuSet != null) json['Cpuset'] = cpuSet;
    if (domainName != null) json['Domainname'] = domainName;
    if (entryPoint != null) json['Entrypoint'] = entryPoint;
    if (env != null) json['Env'] = env;
    if (exposedPorts != null) json['ExposedPorts'] = exposedPorts;
    if (hostName != null) json['Hostname'] = hostName;
    if (image != null) json['Image'] = image;
    if (memory != null) json['Memory'] = memory;
    if (memorySwap != null) json['MemorySwap'] = memorySwap;
    if (networkDisabled != null) json['NetworkDisabled'] = networkDisabled;
    if (onBuild != null) json['OnBuild'] = onBuild;
    if (openStdin != null) json['OpenStdin'] = openStdin;
    if (portSpecs != null) json['PortSpecs'] = portSpecs;
    if (stdinOnce != null) json['StdinOnce'] = stdinOnce;
    if (tty != null) json['Tty'] = tty;
    if (user != null) json['User'] = user;
    if (volumeDriver != null) json['VolumeDriver'] = volumeDriver;
    if (volumes != null) json['Volumes'] = volumes;
    if (workingDir != null) json['WorkingDir'] = workingDir;
    return json;
  }
}

/// See [HostConfigRequest] for documentation of the members.
class HostConfig {
  List<String> _binds;
  List<String> get binds => _toUnmodifiableListView(_binds);

  int _blkioWeight;
  int get blkioWeight => _blkioWeight;

  List<String> _capAdd;
  List<String> get capAdd => _toUnmodifiableListView(_capAdd);

  List<String> _capDrop;
  List<String> get capDrop => _toUnmodifiableListView(_capDrop);

  String _cGroupParent;
  String get cGroupParent => _cGroupParent;

  String _containerIdFile;
  String get containerIdFile => _containerIdFile;

  int _cpuPeriod;
  int get cpuPeriod => _cpuPeriod;

  int _cpuQuota;
  int get cpuQuota => _cpuQuota;

  int _cpuShares;
  int get cpuShares => _cpuShares;

  String _cpusetCpus;
  String get cpusetCpus => _cpusetCpus;

  String _cpusetMems;
  String get cpusetMems => _cpusetMems;

  Map<String, String> _devices;
  Map<String, String> get devices => _toUnmodifiableMapView(_devices);

  List<String> _dns;
  List<String> get dns => _toUnmodifiableListView(_dns);

  List<String> _dnsSearch;
  List<String> get dnsSearch => _toUnmodifiableListView(_dnsSearch);

  List<String> _extraHosts;
  List<String> get extraHosts => _toUnmodifiableListView(_extraHosts);

  String _ipcMode;
  String get ipcMode => _ipcMode;

  List<String> _links;
  List<String> get links => _toUnmodifiableListView(_links);

  Map<String, Config> _logConfig;
  Map<String, Config> get logConfig => _toUnmodifiableMapView(_logConfig);

  Map<String, String> _lxcConf;
  Map<String, String> get lxcConf => _toUnmodifiableMapView(_lxcConf);

  int _memory;
  int get memory => _memory;

  int _memorySwap;
  int get memorySwap => _memorySwap;

  String _networkMode;
  String get networkMode => _networkMode;

  bool _oomKillDisable;
  bool get oomKillDisable => _oomKillDisable;

  String _pidMode;
  String get pidMode => _pidMode;

  Map<String, List<PortBinding>> _portBindings;
  Map<String, List<PortBinding>> get portBindings =>
      _toUnmodifiableMapView(_portBindings);

  bool _privileged;
  bool get privileged => _privileged;

  bool _publishAllPorts;
  bool get publishAllPorts => _publishAllPorts;

  bool _readonlyRootFs;
  bool get readonlyRootFs => _readonlyRootFs;

  RestartPolicy _restartPolicy;
  RestartPolicy get restartPolicy => _restartPolicy;

  String _securityOpt;
  String get securityOpt => _securityOpt;

  Map _ulimits;
  Map get ulimits => _ulimits;

  String _utsMode;
  String get utsMode => _utsMode;

  List _volumesFrom;
  List get volumesFrom => _toUnmodifiableListView(_volumesFrom);

  HostConfig();

  HostConfig.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    _binds = json['Binds'];
    _blkioWeight = json['BlkioWeight'];
    _capAdd = json['CapAdd'];
    _capDrop = json['CapDrop'];
    _cGroupParent = json['CgroupParent'];
    _containerIdFile = json['ContainerIDFile'];
    _cpuPeriod = json['CpuPeriod'];
    _cpusetCpus = json['CpusetCpus'];
    _cpusetMems = json['CpusetMems'];
    _cpuShares = json['CpuShares'];
    _devices = json['Devices'];
    _dns = json['Dns'];
    _dnsSearch = json['DnsSearch'];
    _extraHosts = json['ExtraHosts'];
    _ipcMode = json['IpcMode'];
    _links = json['Links'];
    _logConfig = json['LogConfig'];
    _lxcConf = json['LxcConf'];
    _memory = json['Memory'];
    _memorySwap = json['MemorySwap'];
    _networkMode = json['NetworkMode'];
    _oomKillDisable = json['OomKillDisable'];
    _pidMode = json['PidMode'];
    final Map<String, List<Map<String, String>>> portBindings =
    json['PortBindings'];
    if (portBindings != null) {
      _portBindings = new Map<String, List<PortBinding>>.fromIterable(
          portBindings.keys,
          key: (k) => k,
          value: (k) => portBindings[k]
              .map((pb) => new PortBinding.fromJson(pb, apiVersion))
              .toList());
    }
    _privileged = json['Privileged'];
    _publishAllPorts = json['PublishAllPorts'];
    _readonlyRootFs = json['ReadonlyRootfs'];
    _restartPolicy =
    new RestartPolicy.fromJson(json['RestartPolicy'], apiVersion);
    _securityOpt = json['SecurityOpt'];
    _ulimits = json['Ulimits'];
    _utsMode = json['UTSMode'];
    _volumesFrom = json['VolumesFrom'];

  }

  Map toJson() {
    final json = {};
    if (binds != null) json['Binds'] = binds;
    if (capAdd != null) json['CapAdd'] = capAdd;
    if (capDrop != null) json['CapDrop'] = capDrop;
    if (cGroupParent != null) json['CgroupParent'] = cGroupParent;
    if (containerIdFile != null) json['ContainerIDFile'] = containerIdFile;
    if (cpuPeriod != null) json['CpuPeriod'] = cpuPeriod;
    if (cpusetCpus != null) json['CpusetCpus'] = cpusetCpus;
    if (cpusetMems != null) json['CpusetMems'] = cpusetMems;
    if (cpuQuota != null) json['CpuQuota'] = cpuShares;
    if (cpuShares != null) json['CpuShares'] = cpuShares;
    if (devices != null) json['Devices'] = devices;
    if (dns != null) json['Dns'] = dns;
    if (dnsSearch != null) json['DnsSearch'] = dnsSearch;
    if (extraHosts != null) json['ExtraHosts'] = extraHosts;
    if (ipcMode != null) json['IpcMode'] = ipcMode;
    if (links != null) json['Links'] = links;
    if (logConfig != null) json['LogConfig'] = logConfig;
    if (lxcConf != null) json['LxcConf'] = lxcConf;
    if (memory != null) json['Memory'] = memory;
    if (memorySwap != null) {
      assert(memory > 0);
      assert(memorySwap > memory);
      json['MemorySwap'] = memorySwap;
    }
    if (networkMode != null) json['NetworkMode'] = networkMode;
    if (oomKillDisable != null) json['OomKillDisable'] = oomKillDisable;
    if (pidMode != null) json['PidMode'] = pidMode;
//    if (portBindings != null) json['PortBindings'] = portBindings;
    if (portBindings != null) json['PortBindings'] = new Map.fromIterable(
        portBindings.keys,
        key: (k) => k,
        value: (k) => portBindings[k].map((pb) => pb.toJson()).toList());
    if (privileged != null) json['Privileged'] = privileged;
    if (publishAllPorts != null) json['PublishAllPorts'] = publishAllPorts;
    if (readonlyRootFs != null) json['ReadonlyRootfs'] = readonlyRootFs;
    if (restartPolicy != null) json['RestartPolicy'] = restartPolicy.toJson();
    if (securityOpt != null) json['SecurityOpt'] = securityOpt;
    if (ulimits != null) json['Ulimits'] = ulimits;
    if (utsMode != null) json['UTSMode'] = utsMode;
    if (volumesFrom != null) json['VolumesFrom'] = volumesFrom;
    return json;
  }
}

class PortBindingRequest extends PortBinding {
  String get hostIp => _hostIp;
  set hostIp(String val) => _hostIp = val;

  String get hostPort => _hostPort;
  set hostPort(String val) => _hostPort = val;
}

class PortBinding {
  String _hostIp;
  String get hostIp => _hostIp;

  String _hostPort;
  String get hostPort => _hostPort;

  PortBinding();

  PortBinding.fromJson(Map json, Version apiVersion) {
    _hostIp = json['HostIp'];
    _hostPort = json['HostPort'];
  }

  Map toJson() {
    final result = {'HostPort': hostPort};
    if (hostIp != null) {
      result['HostIp'] = hostIp;
    }
    return result;
  }
}

enum RestartPolicyVariant { doNotRestart, always, onFailure }

///  The behavior to apply when the container exits. The value is an object with
///  a `Name` property of either "always" to always restart or `"on-failure"` to
///  restart only when the container exit code is non-zero. If `on-failure` is
///  used, `MaximumRetryCount` controls the number of times to retry before
///  giving up. The default is not to restart. (optional) An ever increasing
///  delay (double the previous delay, starting at 100mS) is added before each
///  restart to prevent flooding the server.
class RestartPolicy {
  RestartPolicyVariant _variant;
  RestartPolicyVariant get variant => _variant;
  int _maximumRetryCount;
  int get maximumRetryCount => _maximumRetryCount;

  RestartPolicy(this._variant, this._maximumRetryCount);

  RestartPolicy.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    if (json['Name'] != null && json['Name'].isNotEmpty) {
      final value = RestartPolicyVariant.values
          .where((v) => v.toString().endsWith(json['Name']));
//      print(json);
      if (value.length != 1) {
        throw 'Invalid value "${json['Name']}".';
      }
      _variant = value.first;
      if (value == RestartPolicyVariant.onFailure) {
        _maximumRetryCount = json['MaximumRetryCount'];
      }
    }
  }

  Map toJson() {
    assert(_maximumRetryCount == null ||
        _variant == RestartPolicyVariant.onFailure);
    if (variant == null) {
      return null;
    }
    switch (_variant) {
      case RestartPolicyVariant.doNotRestart:
        return null;
      case RestartPolicyVariant.always:
        return {'always': null};
      case RestartPolicyVariant.onFailure:
        if (_maximumRetryCount != null) {
          return {'on-failure': null, 'MaximumRetryCount': _maximumRetryCount};
        }
        return {'on-failure': null};
      default:
        throw 'Unsupported enum value.';
    }
  }
}

class Volumes {
  Map<String, Map> _volumes = {};
  UnmodifiableMapView<String, Map> get volumes =>
      _toUnmodifiableMapView(_volumes);

  Volumes();

  Volumes.fromJson(Map json, Version apiVersion) {
    if (json == null) {
      return;
    }
    json.keys.forEach((k) => add(k, json[k]));
//    print(json);
    //assert(json.keys.length <= 0); // ensure all keys were read
  }

  Map toJson() {
    if (_volumes.isEmpty) {
      return null;
    } else {
      return volumes;
    }
  }

  // TODO(zoechi) better name for other when I figured out what it is
  void add(String path, Map other) {
    _volumes[path] = other;
  }
}

Map<String, String> _parseLabels(Map<String, List<String>> json) {
  if (json == null) {
    return null;
  }
  final l =
  json['Labels'] != null ? json['Labels'].map((l) => l.split('=')) : null;
  return l == null
      ? null
      : _toUnmodifiableMapView(new Map.fromIterable(l,
      key: (l) => l[0], value: (l) => l.length == 2 ? l[1] : null));
}

UnmodifiableMapView _toUnmodifiableMapView(Map map) {
  if (map == null) {
    return null;
  }
  return new UnmodifiableMapView(new Map.fromIterable(map.keys,
      key: (k) => k, value: (k) {
        if (map == null) {
          return null;
        }
        if (map[k] is Map) {
          return _toUnmodifiableMapView(map[k]);
        } else if (map[k] is List) {
          return _toUnmodifiableListView(map[k]);
        } else {
          return map[k];
        }
      }));
}

UnmodifiableListView _toUnmodifiableListView(Iterable list) {
  if (list == null) {
    return null;
  }
  if (list.length == 0) {
    return new UnmodifiableListView(const []);
  }

  return new UnmodifiableListView(list.map((e) {
    if (e is Map) {
      return _toUnmodifiableMapView(e);
    } else if (e is List) {
      return _toUnmodifiableListView(e);
    } else {
      return e;
    }
  }).toList());
}

DateTime _parseDate(dynamic dateValue) {
  if (dateValue == null) {
    return null;
  }
  if (dateValue is String) {
    if (dateValue == '0001-01-01T00:00:00Z') {
      return new DateTime(1, 1, 1);
    }

    try {
      final years = int.parse((dateValue as String).substring(0, 4));
      final months = int.parse(dateValue.substring(5, 7));
      final days = int.parse(dateValue.substring(8, 10));
      final hours = int.parse(dateValue.substring(11, 13));
      final minutes = int.parse(dateValue.substring(14, 16));
      final seconds = int.parse(dateValue.substring(17, 19));
      final milliseconds = int.parse(dateValue.substring(20, 23));
      return new DateTime.utc(
          years, months, days, hours, minutes, seconds, milliseconds);
    } catch (_) {
      print('parsing "${dateValue}" failed.');
      rethrow;
    }
  } else if (dateValue is int) {
    return new DateTime.fromMillisecondsSinceEpoch(dateValue * 1000,
        isUtc: true);
  }
  throw 'Unsupported type "${dateValue.runtimeType}" passed.';
}

bool _parseBool(dynamic boolValue) {
  if (boolValue == null) {
    return null;
  }
  if (boolValue is bool) {
    return boolValue;
  }
  if (boolValue is int) {
    return boolValue == 1;
  }
  if (boolValue is String) {
    if (boolValue.toLowerCase() == 'true') {
      return true;
    } else if (boolValue.toLowerCase() == 'false') {
      return false;
    }
  }

  throw new FormatException(
      'Value "${boolValue}" can not be converted to bool.');
}