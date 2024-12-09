"""Python script to generate the Makefile compiler commands
"""

# compiler flags, pke name, sources
PKE_OPTIONS = [
    ("-DPKE_KYBER -DKYBER_K=2", "kyber512", "KYBERSOURCES"),
    ("-DPKE_KYBER -DKYBER_K=3", "kyber768", "KYBERSOURCES"),
    ("-DPKE_KYBER -DKYBER_K=4", "kyber1024", "KYBERSOURCES"),
    ("-DPKE_MCELIECE -DMCELIECE_N=3488", "mceliece348864", "EASYMCELIECESOURCES"),
    ("-DPKE_MCELIECE -DMCELIECE_N=4608", "mceliece460896", "EASYMCELIECESOURCES"),
    ("-DPKE_MCELIECE -DMCELIECE_N=6688", "mceliece6688128", "EASYMCELIECESOURCES"),
    ("-DPKE_MCELIECE -DMCELIECE_N=6960", "mceliece6960119", "EASYMCELIECESOURCES"),
    ("-DPKE_MCELIECE -DMCELIECE_N=8192", "mceliece8192128", "EASYMCELIECESOURCES"),
]

# compiler flags, mac name
MAC_OPTIONS = [
    ("-DMAC_POLY1305", "poly1305"),
    ("-DMAC_GMAC", "gmac"),
    ("-DMAC_CMAC", "cmac"),
    ("-DMAC_KMAC256", "kmac256"),
]

# authentication modes
AUTHMODES_OPTIONS = [
    "none", "server", "client", "all"
]

def gen_kex_server_command(first_port: int = 8000):
    """generate shell commands using every combination of pke, mac, and authmode"""
    offset = 0
    cmds = []
    for authmode in AUTHMODES_OPTIONS:
        for _, pke_name, _ in PKE_OPTIONS:
            # add the option of using vanilla KEM, not ETM-KEM
            for _, mac_name in [("", "")] + MAC_OPTIONS:
                target = f"./target/kex_server_{pke_name}{mac_name}"
                cmd = f"{target} {authmode} 127.0.0.1 {first_port + offset}"
                cmds.append(cmd)
                offset += 1
        print()
    return cmds

def gen_test_etmkem_speed_cmds():
    cmdtemplate = "$(CC) $(CFLAGS) $(LDFLAGS) {pke_cflags} {mac_cflags} " \
        + "$({pke_sources}) $(SOURCES) test_etmkem_speed.c " \
        + "-o target/test_{pke_name}_{mac_name}_speed"
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

def gen_test_etmkem_correctness_cmds():
    cmdtemplate = "$(CC) $(CFLAGS) $(LDFLAGS) {pke_cflags} {mac_cflags} " \
        + "$({pke_sources}) $(SOURCES) test_etmkem_correctness.c " \
        + "-o target/test_{pke_name}_{mac_name}_correctness"
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
            run_cmds.append(f"./target/test_{pke_name}_{mac_name}_correctness")
    return build_cmds + run_cmds

if __name__ == "__main__":
    cmds = gen_kex_server_command()
    for cmd in cmds:
        print(cmd)
