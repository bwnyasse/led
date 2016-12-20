/**
 * Copyright (c) 2016 ui. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 20/12/16
 * Author     : bwnyasse
 *  
 */
part of led_ui;

@Component(
    selector: 'route-remote-api-cmp',
    templateUrl: 'components/route_components/route_remote_api_cmp.html',
    directives: const [ContainerRemoteApiCmp],
    providers: const [ LConfiguration ])
class RouteRemoteApiCmp {
}