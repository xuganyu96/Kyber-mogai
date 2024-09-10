# Key exchange performances
Measured on M1 MacBook Air using loopback network. Measurement unit is $\mu s$ (microsecond) per round of key exchange, measured between client's first message and client's finishing deriving the final session key (round trip time, or RTT for short). A total of 10,000 rounds of key exchange were performed.

**Security level: ML-KEM-512**:
|KEM|Auth mode|Median|Average|
|:--|:--|:--|:--|
|ML-KEM512 + Poly1305|None|70|72|
|ML-KEM512 + GMAC|None|73|76|
|ML-KEM512 + CMAC|None|75|79|
|ML-KEM512 + KMAC|None|76|78|
|ML-KEM512|None|92|97|
|ML-KEM512 + Poly1305|Server|103|106|
|ML-KEM512 + GMAC|Server|106|110|
|ML-KEM512 + CMAC|Server|108|112|
|ML-KEM512 + KMAC|Server|109|113|
|ML-KEM512|Server|145|151|
|ML-KEM512 + Poly1305|Client|100|102|
|ML-KEM512 + GMAC|Client|104|109|
|ML-KEM512 + CMAC|Client|107|111|
|ML-KEM512 + KMAC|Client|107|111|
|ML-KEM512|Client|145|151|
|ML-KEM512 + Poly1305|Mutual|133|138|
|ML-KEM512 + GMAC|Mutual|139|143|
|ML-KEM512 + CMAC|Mutual|143|148|
|ML-KEM512 + KMAC|Mutual|145|151|
|ML-KEM512|Mutual|200|213|


**Security level: ML-KEM-768**:
|KEM|Auth mode|Median|Average|
|:--|:--|:--|:--|
|ML-KEM768 + Poly1305|None|99|104|
|ML-KEM768 + GMAC|None|101|105|
|ML-KEM768 + CMAC|None|103|109|
|ML-KEM768 + KMAC|None|103|107|
|ML-KEM768|None|135|140|
|ML-KEM768 + Poly1305|Server|144|150|
|ML-KEM768 + GMAC|Server|149|156|
|ML-KEM768 + CMAC|Server|153|160|
|ML-KEM768 + KMAC|Server|154|159|
|ML-KEM768|Server|215|222|
|ML-KEM768 + Poly1305|Client|144|151|
|ML-KEM768 + GMAC|Client|150|158|
|ML-KEM768 + KMAC|Client|153|159|
|ML-KEM768|Client|216|224|
|ML-KEM768 + Poly1305|Mutual|190|196|
|ML-KEM768 + GMAC|Mutual|197|210|
|ML-KEM768 + CMAC|Mutual|202|208|
|ML-KEM768 + KMAC|Mutual|204|210|
|ML-KEM768|Mutual|294|301|

**Security level: ML-KEM-1024**:
|KEM|Auth mode|Median|Average|
|:--|:--|:--|:--|
|ML-KEM1024 + Poly1305|None|138|141|
|ML-KEM1024 + GMAC|None|140|145|
|ML-KEM1024 + CMAC|None|143|148|
|ML-KEM1024 + KMAC|None|144|149|
|ML-KEM1024|None|193|199|
|ML-KEM1024 + Poly1305|Server|202|209|
|ML-KEM1024 + GMAC|Server|212|228|
|ML-KEM1024 + CMAC|Server|212|218|
|ML-KEM1024 + KMAC|Server|213|220|
|ML-KEM1024|Server|310|318|
|ML-KEM1024 + Poly1305|Client|202|209|
|ML-KEM1024 + GMAC|Client|206|214|
|ML-KEM1024 + CMAC|Client|212|219|
|ML-KEM1024 + KMAC|Client|220|242|
|ML-KEM1024|Client|310|328|
|ML-KEM1024 + Poly1305|Mutual|266|273|
|ML-KEM1024 + GMAC|Mutual|273|282|
|ML-KEM1024 + CMAC|Mutual|280|287|
|ML-KEM1024 + KMAC|Mutual|282|288|
|ML-KEM1024|Mutual|512|511|
