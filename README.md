###前提

windows系统，安装virtualbox
安装docker
安装docker compose

###运行

**启动链**
start-chain.sh 启动链并部署调用合约
stop-chain.sh 关闭链并清理相关docker容器

**生成组织身份证书**
start-ca.sh 启动CA服务以及客户端生成组织身份证书
stop-ca.sh 关闭并清理先关docker容器

代码已包含一套生成好的身份证书，并和[myfabric-demo-java-client](https://github.com/fftt2017/myfabric-demo-java-client)项目certificate目录中证书保持一致。如果重新生成组织身份证书，需要复制相关证书到certificate目录（参考certificate.bat），否则[myfabric-demo-java-client](https://github.com/fftt2017/myfabric-demo-java-client)无法运行。