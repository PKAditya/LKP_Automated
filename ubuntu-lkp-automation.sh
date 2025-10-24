#!/bin/bash

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


loc=$(cd ../ && pwd)
echo " "
echo "============================"
echo "Installing dependencies"
echo "============================"
echo " "
echo "Installing make"
sudo apt install make -y
check_exit
echo "Updating the system "
sudo apt update -y
check_exit
echo "Installing git"
sudo apt install git -y
check_exit

sudo apt update -y
check_exit
echo " "
echo "============================================="
echo "Cloning into the lkp-tests and installing lkp"
echo "============================================="
echo " "
cd $loc 
check_exit
git clone https://github.com/intel/lkp-tests.git
check_exit
cd $loc/lkp-tests

echo "Reseting the repo head to the working version of lkp"
git reset --hard 0bcdf89

echo "Changing the rt-tests source link to older source"
filename="$loc/lkp-tests/programs/hackbench/pkg/PKGBUILD"
line_number=10
new_text='source=("https://www.kernel.org/pub/linux/utils/rt-tests/older/rt-tests-${pkgver}.tar.gz")'
sed -i "${line_number}s|.*|${new_text}|" "${filename}"
check_exit
line_number1=5
new_text1='url="https://www.kernel.org/pub/linux/utils/rt-tests/older"'
sed -i "${line_number1}s|.*|${new_text1}|" "${filename}"
check_exit
fn="$loc/lkp-tests/programs/rt-tests/pkg/PKGBUILD"
ln=8
n_t='source=("https://www.kernel.org/pub/linux/utils/rt-tests/older/rt-tests-$pkgver.tar.gz")'
sed -i "${ln}s|.*|${n_t}|" "${fn}"
echo " "
echo " "
echo "============================================"
echo "Installing and splitting the LKP tests"
echo "============================================"
echo " "
echo "Building the lkp"
sudo make install 
check_exit
echo "Installing lkp"
yes | sudo lkp install
check_exit
echo "splitting the test-cases into directory called splits"
mkdir $loc/lkp-tests/splits
check_exit
cd $loc/lkp-tests/splits
echo "  Splitting Hackbench"
lkp split-job $loc/lkp-tests/jobs/hackbench.yaml
check_exit
echo "  Splitting Ebizzy"
lkp split-job $loc/lkp-tests/jobs/ebizzy.yaml
check_exit
echo "  Splitting Unixbench"
lkp split-job $loc/lkp-tests/jobs/unixbench.yaml
check_exit
echo " "
echo "Installing split test-cases"
lkp install $loc/lkp-tests/splits/hackbench-pipe-8-process-100%.yaml
check_exit

echo " "
echo "================================================"
echo "Creating a lkp service to run the lkp test-cases"
echo "================================================"
echo " "
check_exit
echo "Writing all the runnable test-cases to a script"
cd $loc/lkp-tests/
check_exit
touch $loc/lkp-tests/lkp.sh

check_exit
echo "#!/bin/bash" >> lkp.sh

echo "Creating a service file for running the script"
files=$(ls "$loc/lkp-tests/splits/")
check_exit
file_array=($files)

for test_case in "${file_array[@]}"
do
  echo "lkp run $loc/lkp-tests/splits/$test_case" >> lkp.sh
done

check_exit
chmod 777 lkp.sh

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
echo "Reloading the daemon"
systemctl daemon-reload
echo "Enabling the lkp service"
systemctl enable lkp.service
echo "Starting the lkp service"
check_exit
systemctl start lkp.service



echo "===================================="
echo "------------------------------------"

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

