# Switch off internet interface
function turnOffWifi() {
        #Turn wifi off
        echo "Wifi is turning off..."
        nmcli radio wifi off

        # Wait for 5 seconds
        sleep 5
}
# Display Interfaces 
function displayInterfaces() {
        # Display Network interfaces present on machine
        interfaces=$(ifconfig | cut -d ' ' -f 1 | tr -d "[:space:]")
        IFS=':' read -ra interface_list <<< "$interfaces"
        counter=1
        for interface in "${interface_list[@]}"
        do
          	echo [$counter] $interface
                ((counter=counter+1))
        done
        # Prompt user to enter which interface to use
        read -p "Type name of network interface: " number

}
#Change MAC address based on interface
function changeMAC() {
        # Assigns random MAC Address to wifi adapter w1ps10
        sudo macchanger -r $number

        # Turn wifi back on
        nmcli radio wifi on
        echo "Wifi is turning back on..."

        # Wait 5 seconds
        sleep 5
}
# Display network info
function displayNetworkInfo() {
        # Display network information
        ifconfig
        sleep 3

        # New MAC Address
        MACAddress=$(ifconfig | grep ether | tr -s ' ' | cut -d ' ' -f 3 | sed -n 2p)
        echo "MAC Address change Successful!"
        echo "New spoofed MAC Address:"         $MACAddress
}
# Install Macchanger if not already installed
function installMACChanger() { 
        # Install openssh-server based on the package manager on Linux system 
        if [ ! -z $(command -v apt) ]; then sudo apt install macchanger; fi
        if [ ! -z $(command -v dnf) ]; then sudo dnf install macchanger; fi
        if [ ! -z $(command -v yum) ]; then sudo yum install macchanger; fi
        if [ ! -z $(command -v pacman) ]; then sudo pacman -S install macchanger; fi
}
# Main function 
function main() {
        # Install macchanger
        installMACChanger
        displayInterfaces
        turnOffWifi
        changeMAC
        displayNetworkInfo
}
# Call main function
main
