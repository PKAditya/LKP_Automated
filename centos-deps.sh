#!/bin/bash

STOP_FILE="/tmp/stop_lkp_script"
check_exit() {
    if [ -f "$STOP_FILE" ]; then
        echo "Stop file detected. Exiting script..."
        exit 0
    fi
}

echo " "
echo "============================================"
echo "Installing all required dependencies for LKP"
echo "============================================"
echo " "

echo "updating the system"
yum update -y &> /dev/null
check_exit
echo "installing git"
yum install git -y &> /dev/null
check_exit

echo "installing gcc" 
echo "installing make"
yum install gcc make -y &> /dev/null
check_exit
echo "installing time"
yum install time -y &> /dev/null
check_exit
echo "installing perf"
yum install perf  -y &> /dev/null
check_exit
echo "installing tar"
yum install tar  -y &> /dev/null
check_exit
echo "installing rubygems-devel"
yum install rubygems-devel -y &> /dev/null
check_exit
echo "installing time"
yum install time -y &> /dev/null
echo "installing ruby-devel"
yum install -y ruby-devel &> /dev/null
check_exit
echo "installing rubygem-psych"
yum install -y rubygem-psych &> /dev/null
check_exit
echo "installing development tools manually"
yum install gcc gcc-c++ make cmake git automake autoconf -y &> /dev/null
check_exit
echo "installing bsdtar"
yum install -y bsdtar &> /dev/null
check_exit
echo "installing glibc-static"
yum install -y glibc-static &> /dev/null
check_exit
echo "installing turbojpeg"
yum install -y turbojpeg &> /dev/null
check_exit
echo "installing slang-devel"
yum install -y slang-devel.x86_64 &> /dev/null
check_exit
echo "installing libunwind-devel"
yum install -y libunwind-devel.x86_64 &> /dev/null
check_exit
echo "installing libcap-devel"
yum install -y libcap-devel.x86_64 &> /dev/null
check_exit
echo "installing libbabeltrace"
yum install -y libbabeltrace &> /dev/null
check_exit
echo "installing numactl-devel"
yum install -y numactl-devel.x86_64  &> /dev/null
check_exit
echo "installing libbabeltrace-devel"
yum install -y libbabeltrace-devel &> /dev/null
check_exit
echo "installing python3-devel"
yum install -y python3-devel &> /dev/null
check_exit
echo "installing numactl-devel"
yum install -y numactl-devel.x86_64 &> /dev/null
check_exit
echo "installing libcap-devel"
yum install -y libcap-devel &> /dev/null
check_exit
echo "installing libcurl-minimal"
yum install -y libcurl-minimal &> /dev/null
check_exit
echo "installing Java-8"
yum install -y java-1.8.0-openjdk-devel &> /dev/null
check_exit
echo "installing fakeroot"
yum install -y fakeroot &> /dev/null
check_exit
echo "installing openssl-devel"
yum install openssl-devel -y &> /dev/null
check_exit
echo "installing openssl"
yum install openssl -y &> /dev/null
check_exit
echo "installing libcurl"
yum install libcurl -y &> /dev/null
check_exit
echo "installing libcurl-devel"
yum install libcurl-devel -y &> /dev/null
check_exit
echo "installing patch"
yum install patch -y &> /dev/null
check_exit

echo "installing text-table"
gem install text-table &> /dev/null
check_exit
echo "installing activesupport"
gem install activesupport -v 6.0.0 &> /dev/null
check_exit
echo "installing ruby"
gem install ruby &> /dev/null
check_exit
echo "installing bigdecimal"
gem install bigdecimal &> /dev/null
check_exit
echo "installing json"
gem install json &> /dev/null
check_exit
echo "installing racc"
gem install racc &> /dev/null
check_exit
echo "installing parser"
gem install parser &> /dev/null
check_exit
echo "installing tins"
gem install tins &> /dev/null
check_exit
echo "installing parser"
gem install parser &> /dev/null
check_exit
echo "installing term-ansicolor"
gem install term-ansicolor &> /dev/null
check_exit
echo "installing rubocop-ast"
gem install rubocop-ast &> /dev/null
check_exit
echo "installing rubocop"
gem install rubocop &> /dev/null
check_exit
echo "installing flex"
yum install -y flex &> /dev/null
check_exit
echo "installing bison"
yum install -y bison &> /dev/null
check_exit
echo "installing elfutils-libelf-devel"
yum install -y elfutils-libelf-devel &> /dev/null
check_exit
echo "installing elfutils-devel"
yum install -y elfutils-devel &> /dev/null
check_exit
echo "installing libX11-devel"
yum install -y libX11-devel &> /dev/null
check_exit
echo "installing systemtap-sdt-devel"
yum install -y systemtap-sdt-devel &> /dev/null
check_exit
echo "installing perl-ExtUtils-Embed"
yum install -y perl-ExtUtils-Embed &> /dev/null
check_exit
echo "installing perl-ExtUtils-Embed"
yum install -y perl-core &> /dev/null
check_exit
echo "installing perl-ExtUtils-Embed"
yum install -y perl-FindBin &> /dev/null
check_exit
echo "installing mesa-libGL-devel"
yum install -y mesa-libGL-devel &> /dev/null
check_exit
echo "installing mesa-libGL-devel"
yum install -y libXext-devel &> /dev/null
check_exit
echo "installing libcapstone-dev"
yum install -y libcapstone-dev &> /dev/null
check_exit
echo "installing capstone-devel"
yum install -y capstone-devel &> /dev/null
check_exit
echo "installing libdw-dev"
yum install -y libdw-dev &> /dev/null
check_exit
echo "installing systemtap-sdt-dev"
yum install -y systemtap-sdt-dev &> /dev/null
check_exit
echo "installing libperl-dev"
yum install -y libperl-dev &> /dev/null
check_exit
echo "installing clang"
yum install -y clang &> /dev/null
check_exit
echo "installing clang-devel"
yum install -y clang-devel &> /dev/null
check_exit
echo "installing libpfm"
yum install -y libpfm &> /dev/null
check_exit
echo "installing libpfm-devel"
yum install -y libpfm-devel &> /dev/null
check_exit
echo "installing perl-IPC-Run"
yum install -y perl-IPC-Run &> /dev/null
check_exit
echo "installing libxslt-devel"
yum install -y libxslt-devel &> /dev/null
check_exit
echo "installting bundler 2.5.19"
gem install bundler -v 2.5.19 &> /dev/null
check_exit
bundler _2.5.29_ install &> /dev/null
check_exit
echo "installing llvm-devel"
yum install -y llvm-devel &> /dev/null
echo "install gem git"
gem install git
echo " "
