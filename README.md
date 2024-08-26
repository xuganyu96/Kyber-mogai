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

这个项目依赖于 OpenSSL 3（开发环境使用 3.3.1），不兼容 OpenSSL 1.1。

## 性能比较
几种不同的消息认证码之间的性能比较

|名称|中位数|平均数|
|:--|:--|:--|
|Poly1305|961|2875|
|AES-256-GCM|3899|4979|
|AES-256-CBC|7279|7340|
|KMAC-256|9593|9826|

## 配置 language server

```yaml
CompileFlags:
  Add: [
    "-I/opt/homebrew/Cellar/openssl@3/3.3.1/include", 
    "-D__arm64__",
    "-Wall", 
    "-Wextra", 
    "-Wpedantic", 
    "-Wmissing-prototypes", 
    "-Wredundant-decls", 
    "-Wshadow", 
    "-Wpointer-arith", 
    "-O3", 
    "-fomit-frame-pointer",
  ]
```
