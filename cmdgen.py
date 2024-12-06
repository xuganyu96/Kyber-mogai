"""Python script to generate the Makefile compiler commands
"""

# compiler flags, pke name, sources
PKE_OPTIONS = [
    ("-DPKE_KYBER -DKYBER_K=2", "kyber512", "KYBERSOURCES"),
    ("-DPKE_KYBER -DKYBER_K=3", "kyber768", "KYBERSOURCES"),
    ("-DPKE_KYBER -DKYBER_K=4", "kyber1024", "KYBERSOURCES"),
    ("-DPKE_MCELIECE348864", "mceliece348864", "MCELIECE348864SOURCES"),
    ("-DPKE_MCELIECE460896", "mceliece460896", "MCELIECE460896SOURCES"),
    ("-DPKE_MCELIECE6688128", "mceliece6688128", "MCELIECE6688128SOURCES"),
    ("-DPKE_MCELIECE6960119", "mceliece6960119", "MCELIECE6960119SOURCES"),
    ("-DPKE_MCELIECE8192128", "mceliece8192128", "MCELIECE8192128SOURCES"),
]

# compiler flags, mac name
MAC_OPTIONS = [
    ("-DMAC_POLY1305", "poly1305"),
    ("-DMAC_GMAC", "gmac"),
    ("-DMAC_CMAC", "cmac"),
    ("-DMAC_KMAC256", "kmac256"),
]



def gen_test_etmkem_speed_cmds():
    cmdtemplate = "$(CC) $(CFLAGS) $(LDFLAGS) {pke_cflags} {mac_cflags} $({pke_sources}) $(SOURCES) .c -o target/test_{pke_name}_{mac_name}_speed"
    build_cmds = []
    run_cmds = []
    for pke_cflags, pke_name, pke_sources in PKE_OPTIONS:
        for mac_cflags, mac_name in MAC_OPTIONS:
            build_cmds.append(
                cmdtemplate.format(
                    pke_cflags=pke_cflags,
                    mac_cflags=mac_cflags,
                    pke_sources=pke_sources,
                    pke_name=pke_name,
                    mac_name=mac_name,
                )
            )
            run_cmds.append(f"./target/test_{pke_name}_{mac_name}_speed")
    return build_cmds + run_cmds

if __name__ == "__main__":
    cmds = gen_test_etmkem_speed_cmds()
    for cmd in cmds:
        print(cmd)
