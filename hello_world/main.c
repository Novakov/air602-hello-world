#include <stdio.h>
#include <string.h>
#include "wm_type_def.h"
#include "wm_wifi.h"
#include "wm_netif.h"
#include "wm_osal.h"


extern int wm_printf(const char *fmt,...);

static void scan_callback()
{
    wm_printf("Scan done\n");

    char buffer[400];
    memset(buffer, 0, sizeof(buffer));

    int r = tls_wifi_get_scan_rslt(buffer, sizeof(buffer));
    wm_printf("Scan result=%d\n", r);

    struct tls_scan_bss_t* scanResult = buffer;
    wm_printf("Got %d results\n", scanResult->count);

    for (int i = 0; i < scanResult->count; i++)
    {
        wm_printf("%d. %s\n", i, scanResult->bss[i].ssid);
    }
}

static void test_scan()
{
    wm_printf("Running wifi scan...");    

    tls_wifi_scan_result_cb_register(&scan_callback);

    int r = tls_wifi_scan();

    wm_printf("%d\n", r);
}

static void netif_status_callback(u8_t netif_state)
{
    wm_printf("netif status: %d\n", netif_state);
}

static void test_connect()
{
    wm_printf("Connecting to wifi\n");
    const char* ssid = "<SSID>";
    const char* pwd = "<PWD>";

    tls_wifi_disconnect();

    struct tls_ethif* iface = tls_netif_get_ethif();

    u8 wireless_protocol = 0;
    tls_param_get(TLS_PARAM_ID_WPROTOCOL, (void*) &wireless_protocol, TRUE);
	if (TLS_PARAM_IEEE80211_INFRA != wireless_protocol)
	{
        wm_printf("Switching to infra\n");
	    tls_wifi_softap_destroy();
	    wireless_protocol = TLS_PARAM_IEEE80211_INFRA;
        tls_param_set(TLS_PARAM_ID_WPROTOCOL, (void*) &wireless_protocol, FALSE);
	}
    else
    {
        wm_printf("Protocol ok\n");
    }

    struct tls_param_ip ip_param;
    tls_param_get(TLS_PARAM_ID_IP, &ip_param, FALSE);
    ip_param.dhcp_enable = TRUE;
    tls_param_set(TLS_PARAM_ID_IP, &ip_param, FALSE);

    uint8_t a = tls_netif_add_status_event(netif_status_callback);    
    wm_printf("tls_netif_add_status_event = %d\n", a);

    tls_wifi_connect(ssid, strlen(ssid), pwd, strlen(pwd));    

    while(1)
    {
        wm_printf("ping iface.status=%d ip=%ld\n", iface->status, iface->ip_addr);
        tls_os_time_delay(HZ * 5);
    }
}

void UserMain(void)
{
	wm_printf("\n Hello World2\n");
    

    test_connect();
}