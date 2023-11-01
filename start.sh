#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install libcurl4-openssl-dev libjansson-dev libomp-dev git screen nano jq wget cron vim curl logrotate gettext-base
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

wget ${GITHUB_DOWNLOAD_URL} -P /tmp/

for i in $GITHUB_DOWNLOAD_NAME
do
  if [ -f ~/ccminer/$i ]
  then

    /usr/bin/diff /tmp/$i ~/ccminer/$i && echo "same file" || mv ~/ccminer/$i ~/ccminer/$i_old; mv /tmp/$i ~/ccminer/$i; chmod u+x ~/ccminer/$i
  fi
done

cp ~/autostart/ccminer-a55 /etc/init.d/ && chmod ugo+rx /etc/init.d/ccminer-a55
cp ~/autostart/ccminer-a53 /etc/init.d/ && chmod ugo+rx /etc/init.d/ccminer-a53

cp ~/autostart/logrotate.conf /etc/logrotate.d/ccminer.conf


lscpu | grep Cortex-A53 && ln -s ../init.d/ccminer-a53 /etc/rc3.d/
export HOSTNAME=$(cat /etc/hostname)
envsubst <~/autostart/config.json > ~/ccminer/config.json
