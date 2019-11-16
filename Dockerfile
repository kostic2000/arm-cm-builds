##
## GCC ARM Toolchain

FROM amd64/ubuntu:latest
MAINTAINER Konstantin Begun

ARG GNU_ARM_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
ARG ARM_PACK_URL=https://github.com/ARM-software/CMSIS_5/releases/download/5.6.0/ARM.CMSIS.5.6.0.pack
ARG ATMEL_PACK_URL=http://packs.download.atmel.com/Atmel.SAMD21_DFP.1.3.395.atpack
ARG NRF_PACK_URL=https://developer.nordicsemi.com/nRF5_SDK/pieces/nRF_DeviceFamilyPack/NordicSemiconductor.nRF_DeviceFamilyPack.8.15.2.pack
ARG NRF_S110_URL=https://developer.nordicsemi.com/nRF5_SDK/pieces/nRF_SoftDevice_S110/NordicSemiconductor.nRF_SoftDevice_S110.8.0.3.pack

ARG installdir=/opt/distr

ENV \
	PATH=$PATH:$installdir/toolchain/gcc-arm-none-eabi/bin \
	ARM_PACK=$installdir/ARM_pack \
	ATMEL_PACK=$installdir/Atmel_pack \
	NRF_PACK=$installdir/nRF_pack \
	NRF_S110=$installdir/nRF_S110

RUN \
    #### install build tools ####
    apt-get update \
 && apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
		bsdtar \
		build-essential \
		python \
		python-pip \
    #### install GNU ARM toolchain ####
 && mkdir $installdir && cd $installdir \
 && mkdir toolchain \
 && wget -qO- $GNU_ARM_URL | bsdtar -C toolchain -xvf - \
 && mv toolchain/gcc-arm-none-eabi-* toolchain/gcc-arm-none-eabi \
	#### Install unicorn ####
 && pip install setuptools wheel \
 && pip install unicorn pyelftools \
	#### Download packs ####
 && mkdir ARM_pack && wget -qO- $ARM_PACK_URL | bsdtar -C ARM_pack -xvf - \
 && mkdir Atmel_pack && wget -qO- $ATMEL_PACK_URL | bsdtar -C Atmel_pack -xvf - \
 && mkdir nRF_pack && wget -qO- $NRF_PACK_URL | bsdtar -C nRF_pack -xvf - \
 && mkdir nRF_S110 && wget -qO- $NRF_S110_URL | bsdtar -C nRF_S110 -xvf - \
	#### Cleanup ####
 && apt-get autoremove -y   \
 && apt-get clean           \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && ldconfig
