FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl git make clang vim openssh-server wget sudo xz-utils

RUN cd /opt \
	&& git clone https://github.com/tpoechtrager/osxcross.git \
	&& cd osxcross \
	&& curl -L -o tarballs/MacOSX10.11.sdk.tar.xz https://github.com/phracker/MacOSX-SDKs/releases/download/MacOSX10.11.sdk/MacOSX10.11.sdk.tar.xz \
	&& PORTABLE=1 UNATTENDED=1 ./build.sh

RUN echo 'root:root' | chpasswd
RUN sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN ln -sf /opt/osxcross/build/cctools-895-ld64-274.2_8e9c3f2/cctools/misc/install_name_tool /usr/local/bin/install_name_tool
RUN ln -sf /opt/osxcross/build/cctools-895-ld64-274.2_8e9c3f2/cctools/otool/otool /usr/local/bin/otool
ENV PATH $PATH:/opt/osxcross/target/bin

CMD ["/usr/sbin/sshd", "-D"]

ENV HOME /root
WORKDIR /root


