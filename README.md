# colab-runtime_rocm
based on the official colab-runtime image (see https://research.google.com/colaboratory/local-runtimes.html) and rocm (see https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/install-methods/package-manager/package-manager-ubuntu.html)

## Usage

(you can also check the docker-compose file in this repo)

### use as Colab Docker runtime image
1. Pull the colab-runtime_rocm image from Docker Hub using `docker pull ghcr.io/phueper/colab-runtime_rocm:rocm_7.1.1`.
1. Run the container with 
```shell
docker run -it --rm --device "/dev/kfd:/dev/kfd" --device "/dev/dri:/dev/dri" -p 127.0.0.1:9000:8080 ghcr.io/phueper/colab-runtime_rocm:rocm_7.1.1
```
1. Once the container has started, it will print a message with the initial backend URL used for authentication, of the form 'http://127.0.0.1:9000/?token=...'. Make a copy of this URL and use it as a "Local Runtime" in Google Colab.

### use as Jupyter runtime image (untested)
1. Pull the colab-runtime_rocm image from Docker Hub using `docker pull ghcr.io/phueper/colab-runtime_rocm:rocm_7.1.1`.
1. Run the container with
```shell
docker run -it --rm --device "/dev/kfd:/dev/kfd" --device "/dev/dri:/dev/dri" -p 8888:8888 ghcr.io/phueper/colab-runtime_rocm:rocm_7.1.1
```
2. Access the Jupyter notebook server at http://localhost:8888.

## Verify in colab

To verify, connect to the runtime as "Local Runtime" in a colab session, and run

```python
import torch

print(torch.cuda.is_available())
print(torch.cuda.get_device_name())
print(torch.cuda.get_device_properties())
```

This should output something like

```
True
AMD Radeon 8060S
_CudaDeviceProperties(name='AMD Radeon 8060S', major=11, minor=5, gcnArchName='gfx1151', ...
```

confirming that pytorch is successfully accessing the GPU