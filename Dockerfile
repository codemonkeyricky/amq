# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install required system dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        libffi-dev \
        libffi7 \
        libgmp-dev \
        libgmp10 \
        libncurses-dev \
        libncurses5 \
        libtinfo5 \
        zlib1g-dev \
        git \
        vim \
        net-tools

    # && rm -rf /var/lib/apt/lists/*

# Install GHCup (Haskell toolchain installer)
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Add GHCup binaries to PATH
ENV PATH="/root/.ghcup/bin:${PATH}"

# Install a specific GHC version (e.g., 9.4.5)
RUN ghcup install ghc 9.4.5 --set

# Install Cabal (Haskell build tool)
RUN ghcup install cabal latest --set

# Verify installations
RUN ghc --version && cabal --version

RUN cabal install --lib hashable random network aeson array bytestring containers transformers

RUN git clone https://github.com/codemonkeyricky/haskell.git && \
        cd haskell && \
        git checkout c97ad93b569531c111e9704cce4c9fa2d6ee410f 
RUN cd haskell && make 

