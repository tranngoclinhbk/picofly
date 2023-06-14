FROM ubuntu:jammy
RUN apt-get update && apt-get install -y gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
RUN apt-get install -y git python3 cmake
RUN mkdir /build
RUN git clone https://github.com/raspberrypi/pico-sdk.git /build/pico-sdk && cd /build/pico-sdk && git submodule update --init
RUN git clone https://github.com/rehius/usk.git /build/usk
RUN git clone https://github.com/rehius/busk.git /build/busk
RUN ln -s /build/pico-sdk/external/pico_sdk_import.cmake /build/usk/ && ln -s /build/pico-sdk/external/pico_sdk_import.cmake /build/busk/
RUN sed -i 's/RAM(rwx) : ORIGIN =  0x20000000, LENGTH = 256k/RAM(rwx) : ORIGIN = 0x20038000, LENGTH = 32k/g' /build/pico-sdk/src/rp2_common/pico_standard_link/memmap_default.ld
ENV PICO_SDK_PATH=/build/pico-sdk
RUN cmake -S /build/busk -B /build/busk && make -C /build/busk && make -C /build/busk clean
RUN cmake -S /build/usk -B /build/usk && make -C /build/usk && make -C /build/usk clean
RUN cd /build/usk && python3 prepare.py
