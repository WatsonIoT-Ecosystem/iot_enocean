#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <../gtw/gatewayclient.h>

#include "const-c.inc"

typedef GatewayClient GTWClient;
GTWClient client;

MODULE = enoceaniot		PACKAGE = enoceaniot		

INCLUDE: const-xs.inc

int
initializegateway(orgid,gwtype,gwid,authmtd,authtkn)
        char *orgid
        char *gwtype
        char *gwid
        char *authmtd
        char *authtkn
        CODE:
        RETVAL = initializeGateway(&client,orgid,gwtype,gwid,authmtd,authtkn);
        OUTPUT:
        RETVAL

int
connectgateway()
        CODE:
        RETVAL = connectGateway(&client);
        OUTPUT:
        RETVAL

int
publishgatewayevent(eventtype, eventformat, data, qos)
        char *eventtype
        char *eventformat
        unsigned char *data
        short qos
        CODE:
        RETVAL = publishGatewayEvent(&client, eventtype, eventformat, data, qos);
        OUTPUT:
        RETVAL

int
publishdeviceevent(devicetype, deviceid, eventtype, eventformat, data, qos)
        char *devicetype
        char *deviceid
        char *eventtype
        char *eventformat
        unsigned char *data
        short qos
        CODE:
        RETVAL = publishDeviceEvent(&client,devicetype,deviceid,eventtype, eventformat, data, qos);
        OUTPUT:
        RETVAL

int
disconnectgateway()
        CODE:
        RETVAL = disconnectGateway(&client);
        OUTPUT:
        RETVAL

MODULE = enoceaniot         PACKAGE = GTWClientPtr
void
DESTROY(gtwconf)
        GTWClient *gtwconf;
        CODE:
        free(gtwconf);



