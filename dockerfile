# 基础镜像
FROM ubuntu:20.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 备份原始的 sources.list
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

# 替换 sources.list 为阿里云镜像地址
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse"         > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse"        >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse"          >> /etc/apt/sources.list && \
    echo "deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse"         >> /etc/apt/sources.list

# 更新系统并安装基本工具
RUN apt-get update 
RUN apt-get install -y curl gnupg2 ca-certificates lsb-release apt-transport-https git vim unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && npm i -g pnpm

# 安装 Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

# 设置 Deno 环境变量
ENV DENO_INSTALL="/root/.deno"
ENV PATH="$DENO_INSTALL/bin:$PATH"

# 验证安装
RUN deno --version && node --version

# 设置工作目录（可选）
WORKDIR /app

# 容器启动时默认执行的命令（可选）
CMD ["bash"]
