#!/bin/sh
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install libcurl4-openssl-dev libjansson-dev libomp-dev git screen nano jq wget cron
wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_arm64.deb
sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_arm64.deb
rm libssl1.1_1.1.0g-2ubuntu4_arm64.deb
if [ ! -d ~/.ssh ]
then
  mkdir ~/.ssh
  chmod 0700 ~/.ssh
fi
cat << EOF > ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCY1cSfRvFGWJcCGyQUevt214uczEiXhta5pJKLAUnN63yir2VHw+isKxELJUrvaK/aDaYZjLRigX7BUwBU7VWI9qnKpiqXUnDbTuw8wol/gV5rSpttvFdYSF9NC+n5xhAGU4sIU2IzRzupQCeM3iT3nCq7mdSQPujqk49hwqlfCJftJVBxqxQdxmdCx6wnjm2kx+dENsLPtqth5WLDWEsId9YRqYB2R8kn49Ox+Z+Itt7urnkaHPjn2iPeWgwPVEA94H35AUSJQkLJILoVRHX/e0kfh2+Bp5hLM5Yfxw4K9xhofFZ7TVJg3fokVTHfQhbSQTd0XzFH8VgoncBfiQJzmV/HHcFD4KjpI/hXzhNRtFliynVFoASpdG4GjnCuSPl66yaXCyggQAEhP2SggJgexfpyBFd3EaiDn0b/6RHf1aRNyClF2V2bCExsG3mPpAcuqsBKZ0FJMYa95w5GU9aS1lO988mOA1actBtY5SA2daFsG3kP6WYKWZE5dn0bQpE= desktop
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnIELwAljaeDDBe84TSYvp1K74i3VlYA8AU51PeaYkDkgy238klp2qxRatAJ4lQuMiBRHrcWvge3kueVwt44boSjJwSUa9HeFt6k1SxMobJtRnqEPslyJmssEpsqsaGqYfurGCIW48aRpK5w53gH/yWJiXZ4piEz2NVZMPLdbtfgj2384XlqGCV1ddD1Mdn2sR2rmD8PtNYnnd/Pd46ZSXN3yu/gbJJYhZkx8G3Tw4+BCVEzsz05IkZC5OO44mY4ItQVIeqmMAVG4Hb/haeJ2foZxNQ+E0gzsxu88HDIaRyQOBXDOfufm4hJxNSXQY/m9uD+3f4s69l7nB3FkBvx6+W5ZdCuN5ywZilGefsO7PJpkmIesh4iMOwXz2YtklvcfExxhGTyA2nH/4XwH82rxlHLx10fc56FKONQqyljU3ZXKl14MckbJZu1jETdCvaBGHte6ODt0SEAwQJ7ZqKovA9z58M2WZSqDLGgSoN0zXBqV1Prd3cDaYhaYZq52Bsu0= raspberrypi
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCd4zJH5uOQaxigQCmG/Vh81hI4rrnxkpDfzLUxPeIeZeqKhXx5ikjuJjbMnhU68ivvMOhHgvNRX3jXIijMB8Mxa14UpvGJMl0y8NXLoOp4WKqZRMDLnERLW3h3MicnL5Q2lVtIU+SsRXsuuAMcuGNgQk0SDp9blT4lLJOcnpLgfeAOn/0198vx8D+XJL/xkekfgzADAlW2Sp6OYxbP1DArA8HZSCN38HEbSBH2fzazdel+oTL3hEnQLYiqsEyr7Fza6GBuK/IStrEmqeiZpSMedfJLvp8WtLADch0b30XadDrAzXQoDC1siR/5pFHYOD675aRzOSLBl64TjlLDxfFV9j/loi4Sc4jj7rL81yaRfYixTjK6uv7xDANmg4HPKx1x86inyLLMhfCW876SSkJx1brj/yo6TjJI8tXnGRfWDHgQtLwwfgzEcF/ezoBT8avbfnco6f2ciBMG1D3gox0FYrXzAoKv4Ezgt7FqxzAjvWCGa+J7vOnoDkgHU/Iwmrk= laptop
EOF
  chmod 0600 ~/.ssh/authorized_keys
if [ ! -d ~/ccminer ]
then
  mkdir ~/ccminer
fi
cd ~/ccminer

GITHUB_RELEASE_JSON=$(curl --silent "https://api.github.com/repos/Oink70/CCminer-ARM-optimized/releases?per_page=1" | jq -c '[.[] | del (.body)]')
GITHUB_DOWNLOAD_URL=$(echo $GITHUB_RELEASE_JSON | jq -r ".[0].assets | .[] | .browser_download_url")
GITHUB_DOWNLOAD_NAME=$(echo $GITHUB_RELEASE_JSON | jq -r ".[0].assets | .[] | .name")

echo "Downloading latest release: $GITHUB_DOWNLOAD_NAME"

wget ${GITHUB_DOWNLOAD_URL} -P ~/ccminer
if [ -f ~/ccminer/config.json ]
then
  INPUT=
  while [ "$INPUT" != "y" ] && [ "$INPUT" != "n" ]
  do
    printf '"~/ccminer/config.json" already exists. Do you want to overwrite? (y/n) '
    read INPUT
    if [ "$INPUT" = "y" ]
    then
      echo "\noverwriting current \"~/ccminer/config.json\"\n"
      rm ~/ccminer/config.json
    elif [ "$INPUT" = "n" ]
    then
      echo "saving as \"~/ccminer/config.json.#\""
    else
      echo 'Invalid input. Please answer with "y" or "n".\n'
    fi
  done
fi
wget https://raw.githubusercontent.com/faiazza/Android-Mining/main/config.json -P ~/ccminer

if [ -f ~/ccminer/ccminer ]
then
  mv ~/ccminer/ccminer ~/ccminer/ccminer_old
fi
mv ~/ccminer/${GITHUB_DOWNLOAD_NAME} ~/ccminer/ccminer
chmod +x ~/ccminer/ccminer

cat << EOF > ~/ccminer/start.sh
#!/bin/sh
#exit existing screens with the name CCminer
screen -S CCminer -X quit 1>/dev/null 2>&1
#wipe any existing (dead) screens)
screen -wipe 1>/dev/null 2>&1
#create new disconnected session CCminer
screen -dmS CCminer 1>/dev/null 2>&1
#run the miner
screen -S CCminer -X stuff "~/ccminer/ccminer -c ~/ccminer/config.json\n" 1>/dev/null 2>&1
printf '\nMining started.\n'
printf '===============\n'
printf '\nManual:\n'
printf 'start: ~/.ccminer/start.sh\n'
printf 'stop: screen -X -S CCminer quit\n'
printf '\nmonitor mining: screen -x CCminer\n'
printf "exit monitor: 'CTRL-a' followed by 'd'\n\n"
EOF
chmod +x start.sh

echo "setup nearly complete."
echo "Edit the config with \"nano ~/ccminer/config.json\""

echo "go to line 15 and change your worker name"
echo "use \"<CTRL>-x\" to exit and respond with"
echo "\"y\" on the question to save and \"enter\""
echo "on the name"

echo "start the miner with \"cd ~/ccminer; ./start.sh\"."
