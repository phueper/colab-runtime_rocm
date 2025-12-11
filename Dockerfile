# vim: filetype=dockerfile

ARG ROCM7VERSION=7.1.1

FROM rocm/dev-almalinux-8:${ROCM7VERSION}-complete AS rocm

FROM europe-docker.pkg.dev/colab-images/public/runtime AS default
COPY --from=rocm /opt/rocm /usr/local/rocm
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/rocm/lib
ENV PATH=/opt/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/tools/node/bin:/tools/google-cloud-sdk/bin:/usr/local/rocm/bin
RUN pip3 install --force-reinstall --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm7.1