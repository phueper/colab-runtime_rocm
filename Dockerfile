# vim: filetype=dockerfile

FROM europe-docker.pkg.dev/colab-images/public/runtime AS default
ARG ROCMVERSION=7.1.1
ARG TORCH_ROCMVERSION=7.1

LABEL org.opencontainers.image.source=https://github.com/phueper/colab-runtime_rocm
LABEL org.opencontainers.image.description="colab-runtime with ROCm support, based on the google colab runtime image"

# install rocm as documented here https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/install-methods/package-manager/package-manager-ubuntu.html
COPY <<EOF /etc/apt/sources.list.d/rocm.list
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/${ROCMVERSION} jammy main
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/${ROCMVERSION}/ubuntu jammy main
EOF
COPY <<EOF /etc/apt/preferences.d/rocm-pin-600
Package: *
Pin: release o=repo.radeon.com
Pin-Priority: 600
EOF
RUN sudo mkdir --parents --mode=0755 /etc/apt/keyrings \
    && wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | \
        gpg --dearmor | sudo tee /etc/apt/keyrings/rocm.gpg > /dev/null \
    && sudo apt update \
    && apt-get install -y rocm libdrm-amdgpu-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install nightly torch
RUN pip3 install --force-reinstall --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm${TORCH_ROCMVERSION}
RUN pip3 cache purge