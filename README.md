# 魔改 Kyber
性能比较请参见[性能比较](./performance/readme.md)

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
