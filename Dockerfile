# vim: filetype=dockerfile

FROM europe-docker.pkg.dev/colab-images/public/runtime AS default
# install rocm as documented here https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/install-methods/package-manager/package-manager-ubuntu.html
COPY <<EOF /etc/apt/sources.list.d/rocm.list
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/7.1.1 jammy main
deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/graphics/7.1.1/ubuntu jammy main
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
RUN pip3 install --force-reinstall --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm7.1
RUN pip3 cache purge