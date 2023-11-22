FROM ubuntu:20.04

COPY C-STAR_* /tmp/
ENV DEBIAN_FRONTEND=non-interactive
RUN apt-get update && \
    apt-get install -y git wget cmake xz-utils g++ zlib1g-dev && \
    ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6.2 /usr/lib/x86_64-linux-gnu/libtinfo.so && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang+llvm-12.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz \
        -O /tmp/clang-llvm.tar.xz && \
    mkdir -p /usr/local/llvm && \
    cd /usr/local/llvm && \
    tar xJf /tmp/clang-llvm.tar.xz --strip-components=1 && \
    rm -f /tmp/clang-llvm.tar.xz && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/cx-language/cx && \
    cd cx && \
    git reset --hard $(cat /tmp/C-STAR_COMMIT_HASH) && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_PREFIX_PATH=/usr/local/llvm -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . --config Release && \
    cp -p cx /usr/local/bin && \
    cd .. && \
    rm -rf $(find . -mindepth 1 -maxdepth 1 '!' -name std) && \
    apt-get remove -y git wget cmake && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/local/llvm/
