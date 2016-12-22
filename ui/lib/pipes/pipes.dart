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

@Pipe(name: 'humanSize')
class HumanSize implements PipeTransform {
  transform(dynamic value) => jsinterop.filesize(value);
}

@Pipe(name: 'truncateId')
class TruncateId implements PipeTransform {
  transform(dynamic value) => value.toString().replaceAll('sha256:','').substring(0,15);
}