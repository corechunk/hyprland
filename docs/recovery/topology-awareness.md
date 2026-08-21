No, KDE Connect will not work directly over a Controller Area Network (CAN bus). [1] 
KDE Connect is built entirely on standard network sockets and requires a transmission protocol layer that supports standard Internet Protocol (IP) networking, which CAN lacks by default.
## Why it does not work out of the box

* Different Network Layers: KDE Connect operates on the application layer and relies on standard TCP/UDP ports (1714–1764). It expects an underlying IP network to route data packets between devices.
* No Native IP Routing: A standard automotive or industrial CAN network transmits small data frames (8 bytes for classic CAN, or up to 64 bytes for CAN FD) without native IP addressing or routing mechanisms. [2, 3] 
* Discovery Limitations: KDE Connect discovers peer devices using network broadcasts or multicasts. CAN networks do not natively broadcast local network discovery mechanisms like those used in Wi-Fi or standard Ethernet (UDP broadcasts).

## Theoretical Workarounds
To theoretically pass KDE Connect traffic over a CAN topology, you would have to bridge the structural gap between standard networking and serial bus communications:

* IP-over-CAN: You would need to use a specialized kernel module or software layer (such as SLCAN or custom network drivers) to wrap IP packets into CAN frames, effectively treating the CAN interface as a standard Linux network interface (can0 acting like eth0).
* Bandwidth Bottleneck: Even if you successfully route IP traffic through CAN, classic CAN maxes out at 1 Mbps. KDE Connect features like shared clipboards or notifications might pass, but features like multimedia streaming, file transfer, or filesystem sharing would immediately stall or drop connections due to extreme bandwidth limits.

Are you trying to connect an embedded Linux device or Raspberry Pi inside a vehicle framework, or would you like to explore other serial-over-IP networking tools?
