#!/bin/bash
user=$1
echo "$user     ALL=(ALL)       ALL" >> /etc/sudoers
STOP_FILE="/tmp/stop_lkp_script"

# Function to check if the stop file exists
check_exit() {
    if [ -f "$STOP_FILE" ]; then
        echo "Stop file detected. Exiting script..."
        exit 0
    fi
}

# Signal handling to allow graceful exit on Ctrl+C
trap "echo 'Caught SIGINT. Exiting...'; exit 0" SIGINT
echo " "

read -p "Do you want to create a service file for the lkp running? (yes/y): " servi < /dev/tty
servi=$(echo "$servi" | tr '[:upper:]' '[:lower:]')
loc=$(cd ../ && pwd)



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

loc=$(cd ../ && pwd)
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
echo " "
echo "============================================"
echo "Cloning into the LKP-Tests Directory"
echo "============================================"
echo " "
echo "Removing any directory named lkp-tests in the current directory"
rm -rf $loc/lkp-tests &> /dev/null
check_exit
cd $loc

git clone https://github.com/intel/lkp-tests/
check_exit
echo " "
echo "==========================================================="
echo "Modifying the installation files in the lkp-tests directory"
echo "==========================================================="
echo " "
cd $loc/lkp-tests
echo "Creating a new file with the distro name for installation in installer directory"
cp $loc/lkp-tests/distro/installer/centos $loc/lkp-tests/distro/installer/opencloudos
cp $loc/lkp-tests/distro/installer/centos $loc/lkp-tests/distro/installer/anolis
cp $loc/lkp-tests/distro/installer/centos $loc/lkp-tests/distro/installer/openeuler

check_exit
> $loc/lkp-tests/distro/installer/opencloudos
> $loc/lkp-tests/distro/installer/anolis
> $loc/lkp-tests/distro/installer/openeuler

check_exit
# Confirm that the file contents were deleted
echo "Contents of '$FILE' deleted."


echo "Creating a new file with the distro name for installation in adaptation-pkg directory"


cp $loc/lkp-tests/distro/adaptation-pkg/centos $loc/lkp-tests/distro/adaptation-pkg/opencloudos
cp $loc/lkp-tests/distro/adaptation-pkg/centos $loc/lkp-tests/distro/adaptation-pkg/anolis
cp $loc/lkp-tests/distro/adaptation-pkg/centos $loc/lkp-tests/distro/adaptation-pkg/openeuler

check_exit
echo "Changing the source repo link for rt-tests to older rt-tests"
filename="$loc/lkp-tests/programs/hackbench/pkg/PKGBUILD"
line_number=10
new_text='source=("https://www.kernel.org/pub/linux/utils/rt-tests/older/rt-tests-${pkgver}.tar.gz")'
sed -i "${line_number}s|.*|${new_text}|" "${filename}"
linu=2
new_line2='pkgver=2.6'
sed -i "${linu}s|.*|${new_line2}|" "${filename}"
check_exit
line_number1=5
new_text1='url="https://www.kernel.org/pub/linux/utils/rt-tests/older"'
sed -i "${line_number1}s|.*|${new_text1}|" "${filename}"
check_exit


fn="$loc/lkp-tests/programs/rt-tests/pkg/PKGBUILD"
ln=8
n_t='source=("https://www.kernel.org/pub/linux/utils/rt-tests/older/rt-tests-$pkgver.tar.gz")'
sed -i "${ln}s|.*|${n_t}|" "${fn}"
linu2=2
new_line2='pkgver=2.6'
sed -i "${linu2}s|.*|${new_line2}|" "${fn}"
lnt=9
nl9="md5sums=('SKIP')"
sed -i "${lnt}s|.*|${nl9}|" "${fn}"
check_exit
echo " "

echo "============================================"
echo "Installing and splitting the LKP tests"
echo "============================================"
echo " "
echo "building lkp to /usr/local/bin"
make install &> /dev/null
echo "Installing lkp with dependencies"
yes | /usr/local/bin/lkp install &> /dev/null
echo "Splitting the test-cases into directory named spilts"
check_exit
hey="$loc/lkp-tests/jobs/hackbench.yaml"

# Uncomment the line "# - 50%" in the specified file
sed -i 's/# - 50%/- 50%/' "$hey"
sed -i 's/- 1600%/# - 1600%/' "$hey"

check_exit

mkdir $loc/lkp-tests/splits 
cd $loc/lkp-tests/splits
echo " "
echo "Splitting Hackbench"
echo "--------------------"
/usr/local/bin/lkp split-job $loc/lkp-tests/jobs/hackbench.yaml 
check_exit
echo " "
echo "Splitting Ebizzy"
echo "--------------------"
/usr/local/bin/lkp split-job $loc/lkp-tests/jobs/ebizzy.yaml
check_exit
echo " "
echo "Splitting Unixbench"
echo "--------------------"
/usr/local/bin/lkp split-job $loc/lkp-tests/jobs/unixbench.yaml
check_exit
echo " "
echo "Installing test-cases"

# Function to display loading animation
loading_animation() {
    local delay=0.1
    local spinstr='|/-\'
    while :; do
        for ((i=0; i<${#spinstr}; i++)); do
            printf "\r%s" "${spinstr:$i:1}"
            sleep $delay
        done
    done
}

# Start loading animation in the background
loading_animation &
# Save the PID of the loading animation process
spinner_pid=$!
# Simulate a long-running process (replace with your actual command)
echo "---------This might take a while, please wait while the process completes........"
/usr/local/bin/lkp install $loc/lkp-tests/splits/hackbench-pipe-8-process-100%.yaml &> /dev/null
/usr/local/bin/lkp install $loc/lkp-tests/splits/ebizzy-10s-100x-200%.yaml &> /dev/null
/usr/local/bin/lkp install $loc/lkp-tests/splits/unixbench-100%-300s-arithoh.yaml &> /dev/null
check_exit
# Stop the loading animation
kill "$spinner_pid" > /dev/null 2>&1
# Clean up the line after animation
echo -e "\rDone!     "

echo " "
echo "=========================="
echo "Clearing the older results"
echo "=========================="
echo " "
rm -rf /lkp/result/hackbench/*
rm -rf /lkp/result/ebizzy/*
rm -rf /lkp/result/unixbench/*
echo " "
echo "============================================"
echo "Creating a service file for running LKP"
echo "============================================"
echo " "
check_exit
cd $loc/lkp-tests/

touch $loc/lkp-tests/lkp.sh

echo "Creating a script file to run all the required test-cases, in this case they are:"
echo "Hackbench"
echo "Ebizzy"
echo "Unixbench"
echo " "
echo "Writing into lkp.sh"


echo "#!/bin/bash" >> lkp.sh
echo "STATE_FILE=\"$loc/lkp-tests/progress.txt\"" >> lkp.sh
echo "test_cases=(" >> lkp.sh
echo "Creating a service file for running gthe script"
files=$(ls "$loc/lkp-tests/splits/")
file_array=($files)

for test_case in "${file_array[@]}"
do
   echo "    \"lkp run $loc/lkp-tests/splits/$test_case\"" >> lkp.sh
done
echo ")" >> lkp.sh
:'
# Add the loop to run the test cases
echo "for test_case in \"\${test_cases[@]}\"; do" >> lkp.sh
echo "    echo \"Running: \$test_case\"" >> lkp.sh
echo "    \$test_case" >> lkp.sh
echo "    if [ \$? -eq 0 ]; then" >> lkp.sh
echo "        echo \"\$test_case completed successfully.\" >> \$STATE_FILE" >> lkp.sh
echo "    else" >> lkp.sh
echo "        echo \"\$test_case failed.\" >> \$STATE_FILE" >> lkp.sh
echo "    fi" >> lkp.sh
echo "done" >> lkp.sh
'
# Append the get_last_completed and run_tests functions
echo "get_last_completed() {" >> lkp.sh
echo "    if [ -f \"\$STATE_FILE\" ]; then" >> lkp.sh
echo "        cat \"\$STATE_FILE\"" >> lkp.sh
echo "    else" >> lkp.sh
echo "        echo \"\"  # No progress made yet" >> lkp.sh
echo "    fi" >> lkp.sh
echo "}" >> lkp.sh
echo "" >> lkp.sh

echo "# Function to run tests" >> lkp.sh
echo "run_tests() {" >> lkp.sh
echo "    local last_completed=\$(get_last_completed)" >> lkp.sh
echo "    local start_index=0" >> lkp.sh
echo "" >> lkp.sh
echo "    # Find the index of the last completed test" >> lkp.sh
echo "    for i in \"\${!test_cases[@]}\"; do" >> lkp.sh
echo "        if [[ \"\${test_cases[\$i]}\" == \"\$last_completed\" ]]; then" >> lkp.sh
echo "            start_index=\$((i + 1))" >> lkp.sh
echo "            break" >> lkp.sh
echo "        fi" >> lkp.sh
echo "    done" >> lkp.sh
echo "" >> lkp.sh
echo "    # Run tests starting from where it left off" >> lkp.sh
echo "    for (( i = start_index; i < \${#test_cases[@]}; i++ )); do" >> lkp.sh
echo "        echo \"Running: \${test_cases[\$i]}\"" >> lkp.sh
echo "        \${test_cases[\$i]}" >> lkp.sh
#echo "        lkp run \"\${test_cases[\$i]}\"" >> lkp.sh
echo "        if [ \$? -eq 0 ]; then" >> lkp.sh
echo "            echo \"\${test_cases[\$i]}\" > \"\$STATE_FILE\"" >> lkp.sh
echo "        else" >> lkp.sh
echo "            echo \"Test failed, stopping execution.\"" >> lkp.sh
echo "            exit 1" >> lkp.sh
echo "        fi" >> lkp.sh
#echo "        echo \"\${test_cases[\$i]}\" > \"\$STATE_FILE\"" >> lkp.sh
echo "    done" >> lkp.sh
echo "" >> lkp.sh
echo "    # Clean up the state file if all tests are completed" >> lkp.sh
echo "    rm -f \"\$STATE_FILE\"" >> lkp.sh
echo "}" >> lkp.sh
echo "" >> lkp.sh
echo "run_tests" >> lkp.sh

chmod 777 $loc/lkp-tests/lkp.sh


:'echo "#!/bin/bash" >> lkp.sh

files=$(ls "$loc/lkp-tests/splits/")

file_array=($files)
check_exit
for test_case in "${file_array[@]}"
do
  echo "lkp run $loc/lkp-tests/splits/$test_case" >> lkp.sh
done
check_exit
echo "Making the written script executable"
chmod 777 lkp.sh
'
echo "Creating a service to run lkp"

cd /etc/systemd/system/
touch lkp.service
truncate -s 0 lkp.service
check_exit
echo -e "[Unit]" >> lkp.service
echo -e "Description=LKP Tests Service" >> lkp.service
echo -e "After=network.target" >> lkp.service
echo -e "\n" >> lkp.service
echo -e "[Service]" >> lkp.service
echo -e "WorkingDirectory=$loc/lkp-tests" >> lkp.service
echo -e "ExecStart=/bin/bash $loc/lkp-tests/lkp.sh" >> lkp.service
echo -e "\n" >> lkp.service 
echo -e "[Install]" >> lkp.service
echo -e "WantedBy=multi-user.target" >> lkp.service

if [[ "$servi" == "yes" || "$servi" == "y" ]]; then
	echo "Reloading daemon"
	systemctl daemon-reload
	echo "Enabling lkp service"
	systemctl enable lkp.service
	echo "Starting lkp service"
	systemctl start lkp.service
	check_exit
	echo " "
else
	echo "Created service file but didnot start the service"
	echo "--- start it use the below commands ---"
	echo "  systemctl daemon-reload"
	echo "  systemctl enable lkp.service"
	echo "  systemctl start lkp.service"
	echo " "
fi
echo "===================================="
echo "------------------------------------"
echo " "
echo "-----To find the results run the file /lkp/result/result.sh you will get the sorted results.-----"
echo " "
echo "use the below to stop the service or to stop running the lkp test-cases"
echo "		sudo systemctl stop lkp.service"
echo "use the below to disable the service"
echo "		sudo systemctl disable lkp.service"
echo " "

echo "///////Note: The service created will auto-matically run when the system is started, to disable it use the above command mentioned /////////"
echo " "
echo "------------------------------------"
echo "===================================="

sleep 10

cp $loc/LKP_Automated/result.sh /lkp/result/
