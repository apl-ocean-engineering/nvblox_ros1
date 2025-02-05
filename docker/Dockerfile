FROM nvidia/cuda:11.8.0-devel-ubuntu20.04 AS core

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO noetic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Adding typical tools we need or like to have
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    nano \
    python3-venv \
    python3-catkin-tools \
    ros-noetic-catkin \
    ros-noetic-rviz \
    ros-noetic-rviz-visual-tools \
    ros-noetic-rqt \
    ros-noetic-rqt-common-plugins \
    ros-noetic-image-view \
    git \
    wget \
    tmux \
    python3-pip \
    python3-vcstool \
    python3-catkin-tools \
    python3-rosdep \
    python3-tk \
    libgoogle-glog-dev \
    libgtest-dev \
    libgflags-dev \
    python3-dev \
    libsqlite3-dev

RUN pip install --upgrade cmake \
    && rm -rf /var/lib/apt/lists/*

# Add pretty colors to bash and set background color to black
RUN echo 'export PS1="\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> ~/.bashrc && \
    echo 'alias ls="ls --color=auto"' >> ~/.bashrc && \
    echo 'export TERM=xterm-256color' >> ~/.bashrc && \
    echo 'export CLICOLOR=1' >> ~/.bashrc && \
    echo 'export LSCOLORS=GxFxCxDxBxegedabagaced' >> ~/.bashrc && \
    echo 'printf "\033]11;#000000\007"' >> ~/.bashrc && \
    echo "source ~/.bashrc" >> ~/.bash_profile

FROM core AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV WORKDIR=/root/nvblox_ws
WORKDIR $WORKDIR

# Initialize rosdep if not already initialized
RUN [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ] && rosdep init || echo "rosdep already initialized" && rosdep update
RUN mkdir -p $WORKDIR/src

# Clone the Git repository into the src directory
WORKDIR $WORKDIR/src
RUN git config --global url."https://github.com/".insteadOf "git@github.com:" && \
    git clone https://github.com/apl-ocean-engineering/nvblox_ros1.git && \
    cd nvblox_ros1 && \
    git submodule update --init --recursive && \
    vcs import --recursive --input nvblox_ros_deps.repos

# Use rosdep to install package dependencies in the workspace
WORKDIR $WORKDIR
RUN apt-get update && rosdep install --from-paths src --ignore-src -r -y --rosdistro=noetic -y

# Build the workspace using catkin
WORKDIR $WORKDIR
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin init && \
    catkin config --extend /opt/ros/noetic && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin build"

SHELL ["/bin/bash", "-c"]