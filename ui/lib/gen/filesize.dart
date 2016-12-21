@JS("filesize")
library filesize;

import "package:js/js.dart";

/// Type definitions for filesize 3.2.1
/// Project: https://github.com/avoidwork/filesize.js
/// Definitions by: Giedrius Grabauskas <https://github.com/GiedriusGrabauskas>
/// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
@JS()
external IFilesize get fileSize;
@JS()
external set fileSize(
    IFilesize v); /* WARNING: export assignment not yet supported. */

// Module Filesize
@anonymous
@JS()
abstract class SiJedecBits {
  external String get b;
  external set b(String v);
  external String get Kb;
  external set Kb(String v);
  external String get Mb;
  external set Mb(String v);
  external String get Gb;
  external set Gb(String v);
  external String get Tb;
  external set Tb(String v);
  external String get Pb;
  external set Pb(String v);
  external String get Eb;
  external set Eb(String v);
  external String get Zb;
  external set Zb(String v);
  external String get Yb;
  external set Yb(String v);
  external factory SiJedecBits(
      {String b,
      String Kb,
      String Mb,
      String Gb,
      String Tb,
      String Pb,
      String Eb,
      String Zb,
      String Yb});
}

@anonymous
@JS()
abstract class SiJedecBytes {
  external String get B;
  external set B(String v);
  external String get KB;
  external set KB(String v);
  external String get MB;
  external set MB(String v);
  external String get GB;
  external set GB(String v);
  external String get TB;
  external set TB(String v);
  external String get PB;
  external set PB(String v);
  external String get EB;
  external set EB(String v);
  external String get ZB;
  external set ZB(String v);
  external String get YB;
  external set YB(String v);
  external factory SiJedecBytes(
      {String B,
      String KB,
      String MB,
      String GB,
      String TB,
      String PB,
      String EB,
      String ZB,
      String YB});
}

/*type SiJedec = SiJedecBits & SiJedecBytes & { [name: string]: string };*/
@anonymous
@JS()
abstract class Options {
  /// Enables bit sizes, default is false
  external bool get bits;
  external set bits(bool v);

  /// Number base, default is 2
  external num get base;
  external set base(num v);

  /// Decimal place, default is 2
  external num get round;
  external set round(num v);

  /// Output of function (array, exponent, object, or string), default is string
  external String get output;
  external set output(String v);

  /// Dictionary of SI/JEDEC symbols to replace for localization, defaults to english if no match is found
  /// : use 'symbols'
  external SiJedecBits /*SiJedecBits&SiJedecBytes&JSMap of <String,String>*/ get suffixes;
  external set suffixes(
      SiJedecBits /*SiJedecBits&SiJedecBytes&JSMap of <String,String>*/ v);

  /// Dictionary of SI/JEDEC symbols to replace for localization, defaults to english if no match is found
  external SiJedecBits /*SiJedecBits&SiJedecBytes&JSMap of <String,String>*/ get symbols;
  external set symbols(
      SiJedecBits /*SiJedecBits&SiJedecBytes&JSMap of <String,String>*/ v);

  /// Specifies the SI suffix via exponent, e.g. 2 is MB for bytes, default is -1
  external num get exponent;
  external set exponent(num v);

  /// Enables unix style human readable output, e.g ls -lh, default is false
  external bool get unix;
  external set unix(bool v);

  /// Character between the result and suffix, default is " "
  external String get spacer;
  external set spacer(String v);
  external factory Options(
      {bool bits,
      num base,
      num round,
      String output,
      SiJedecBits /*SiJedecBits&SiJedecBytes&JSMap of <String,String>*/ suffixes,
      SiJedecBits /*SiJedecBits&SiJedecBytes&JSMap of <String,String>*/ symbols,
      num exponent,
      bool unix,
      String spacer});
}

@anonymous
@JS()
abstract class IFilesize {
  /*external String call(num bytes);*/
  /*external String call(num bytes, Options options);*/
  external String call(num bytes, [Options options]);
}

// End module Filesize

