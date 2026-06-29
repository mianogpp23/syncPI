# Oscam Sky DE

Configurazione per OSCam su server cardsharing **s2.skyhd1.xyz** per **Sky Deutschland**.

## Dati server

| Campo | Valore |
|-------|--------|
| URL | s2.skyhd1.xyz |
| Porte | 19001–19008 (NewCamd) |
| Username | 252037 |
| Password | 472526 |
| CAID Sky DE | 098D |
| Protocollo | NewCamd (mgcamd) |
| DES key | `0102030405060708091011121314` (standard) |
| ICAM | Abilitato (`icam = 1`) |

## Configurazione oscam.server

```ini
[reader]
label                         = skyhd1_skyde
protocol                      = newcamd
device                        = s2.skyhd1.xyz,19001
key                           = 0102030405060708091011121314
user                          = 252037
password                      = 472526
group                         = 1
caid                          = 098D
ident                         = 098D:000000
cccversion                    = 2.1.2
cccwantemu                    = 0
inactivitytimeout             = 30
reconnecttimeout              = 30
lb_weight                     = 100
icam                           = 1
```

## File completi

Vedi [configurazione.txt](oscam-skyde/configurazione.txt) per la configurazione completa (oscam.conf, oscam.server, oscam.dvbapi, oscam.user).
