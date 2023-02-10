FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

RUN \
    # Just like RUN commands, every ENV line creates a new intermediate layer. So ENV lines are
    # reserved only for those environment variables that must persist after this RUN script has
    # completed.
    export JVM_VERSION="11" && \
    export NVM_DIR="/usr/local/nvm" && \
    export NODEJS_VERSION="16.18.0" && \
    export NODEJS_SHA256SUM="a50dd97f8deb363c61d7026e5f0abc0f140916d7fcabcc549e9444c1f5c97f03" && \
    export CLOJURE_VERSION="1.11.1.1165" && \
    export CLOJURE_SHA256SUM="72d662bdc99b79037f9e34996272384de35e01e0416d8eb79cc940ee0f0fc808" && \
    #export CLJ_KONDO_VERSION="2022.10.14" && \
    #export CLJ_KONDO_SHA256SUM="1fead3bd0763f83357fb0d5b7a5b9590ec6e10522c5d9176c5a405412142b907" && \
    #export GH_VERSION="2.18.1" && \
    #export GH_SHA256SUM="aca6852c457ae975155c936ad5c2691ff65a62a33142c94722bf76034a7ac43f" && \
    #export GIT_GPGKEY="E1DD270288B4E6030699E45FA1715D88E1DF1F24" && \
    #export DEBIAN_FRONTEND="noninteractive" && \
    #export DOTFILES_BASE_URI="https://raw.githubusercontent.com/day8/dockerfiles-for-dev-ci-images/master/dotfiles/" && \
    cd /tmp && \
    apt-get update -qq && \
    apt-get dist-upgrade -qq -y && \
    echo '\n\n' && \
    mkdir /usr/local/nvm && \
    #
    # Install tools needed by the subsequent commands.
    apt-get install -qq -y --no-install-recommends \
        locales tzdata \
        ca-certificates gnupg \
        curl wget \
        unzip && \
    # Install Node.js:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash - && \
    . $NVM_DIR/nvm.sh  && \
    nvm install 16.18.0  && \
    nvm use 16.18.0 && \
    #java
    apt-get install -y openjdk-11-jre-headless && \
    # rm -f "node-v${NODEJS_VERSION}-linux-x64.tar.xz" && \
    #
    # Install Clojure:
    echo "Installing 'Official' Clojure CLI ${CLOJURE_VERSION}..." && \
    wget -q "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh" && \
    echo "Verifying linux-install-$CLOJURE_VERSION.sh checksum..." && \
    sha256sum linux-install-$CLOJURE_VERSION.sh && \
    echo "$CLOJURE_SHA256SUM *linux-install-$CLOJURE_VERSION.sh" | sha256sum -c - && \
    chmod +x linux-install-$CLOJURE_VERSION.sh && \
    ./linux-install-$CLOJURE_VERSION.sh && \
    rm -f "linux-install-${CLOJURE_VERSION}.sh" && \
    clojure -e "(clojure-version)" && \
    echo "echo \"Node.js `node --version` with NPM `npm --version`\"" >> /docker-entrypoint.sh && \
    echo "echo \"`npx`\"" >> /docker-entrypoint.sh && \
    echo 'exec "$@"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh && \
    echo '\n\n'

ENV NVM_DIR "/usr/local/nvm"
ENV NODE_VERSION "16.18.0"

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


RUN \
   apt-get install -y git && \
   npm install -g npm@9.4.1 && \
   npm install -g shadow-cljs



#RUN groupadd -r kolle && useradd -r -g kolle kolle


#RUN mkdir /home/kolle

#USER kolle

#ADD metadata-rf $HOME/

#RUN cd $HOME/metadata-rf
#RUN clojure -T:build build-uber-jar

#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
