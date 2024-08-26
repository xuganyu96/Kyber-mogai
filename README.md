# 魔改 Kyber
- [x] 修改kyber性能测试，使得可以在Apple Silicon上运行  
但是跑出来的数据看起来好奇怪
- [x] 测量封装和解封使用的CPU周期`test/test_etm_speed.c`
- [x] 尝试使用GMAC，HMAC，KMAC，CMAC

## 配置 OpenSSL
在 MacOS 上推荐使用 brew 安装 OpenSSL。安装完成后需要输出两个环境变量：
```bash
export OPENSSLDIR="/path/to/openssl"
export CFLAGS="-I${OPENSSL_PATH}/include"
export LDFLAGS="-L${OPENSSL_PATH}/lib"
```

在 Makefile 中写编译指令的时候需要加入对应的变量
```makefile
$(CC) ... $(CFLAGS) $(LDFLAGS) -lcrypto ...
```

## 配置 language server

```yaml
CompileFlags:
  Add: ["-I/opt/homebrew/Cellar/openssl@3/3.3.1/include"]
```
