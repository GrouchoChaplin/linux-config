# #!/bin/bash
# set -e

# echo ">>> Resetting Java module streams..."
# sudo dnf -y module reset javapackages-tools || true
# sudo dnf -y module reset java || true

# echo ">>> Enabling OpenJDK 21 module..."
# sudo dnf -y module enable java-21-openjdk

# echo ">>> Installing OpenJDK 21 runtime + development headers..."
# sudo dnf -y install java-21-openjdk java-21-openjdk-devel

# echo ">>> Configuring alternatives for java and javac..."
# JAVA_BIN=$(dirname $(readlink -f $(which java)))
# JAVA_HOME=$(dirname $JAVA_BIN)

# sudo alternatives --install /usr/bin/java java $JAVA_BIN/java 2100
# sudo alternatives --install /usr/bin/javac javac $JAVA_BIN/javac 2100

# sudo alternatives --set java $JAVA_BIN/java
# sudo alternatives --set javac $JAVA_BIN/javac

# echo ">>> Setting JAVA_HOME globally..."
# PROFILE=/etc/profile.d/java21.sh
# echo "export JAVA_HOME=$JAVA_HOME" | sudo tee $PROFILE
# echo "export PATH=\$JAVA_HOME/bin:\$PATH" | sudo tee -a $PROFILE

# echo ">>> Reloading environment..."
# source $PROFILE

# echo ">>> Done! Installed Java version:"
# java -version
# javac -version
# echo "JAVA_HOME=$JAVA_HOME"



# Remove old failed attempts (optional)
sudo dnf remove java-17-openjdk* java-11-openjdk* java-1.8.0-openjdk* -y

# Install Adoptium JDK 21
sudo rpm --import https://packages.adoptium.net/artifactory/api/gpg/key/public
sudo curl -o /etc/yum.repos.d/adoptium.repo \
  https://packages.adoptium.net/artifactory/rpm/centos/adoptium.repo

sudo dnf install temurin-21-jdk
