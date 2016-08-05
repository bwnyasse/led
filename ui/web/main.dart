/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 05/08/16
 * Author     : bwnyasse
 *  
 */
import 'package:angular/application_factory.dart';
import 'package:fluentd_log_explorer/application_module.dart';

///
/// Point d'entrée du project.
///
/// Définit les modules qui doivent charger pour le lancement de l'application.
///
void main() {
  applicationFactory()
    ..addModule(new ApplicationModule())
    ..run();
}
