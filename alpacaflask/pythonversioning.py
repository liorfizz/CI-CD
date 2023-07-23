import docker
import re

client = docker.from_env()
images = client.images.list()

# Regular expression pattern to match version numbers in the tag
version_pattern = r"^liorfizz/alpaca:(\d+\.\d+\.\d+)$"

existing_versions = [
    re.match(version_pattern, image.tags[0]).group(1)
    for image in images
    if image.tags and re.match(version_pattern, image.tags[0])
]

if existing_versions:
    latest_version = max(existing_versions)
    # Convert the version number string to a tuple of integers for easy manipulation
    latest_version_parts = tuple(map(int, latest_version.split(".")))
    next_version_parts = (latest_version_parts[0], latest_version_parts[1], latest_version_parts[2] + 1 )
else:
    next_version_parts = (2, 3, 0)

# Format the version number as "0.0.0" or "0.0.1"
next_version = f"{next_version_parts[0]}.{next_version_parts[1]}.{next_version_parts[2]}"

image_name = f"liorfizz/alpaca:{next_version}"

client.images.build(path=".", tag=image_name, rm=True, pull=True)
print(f"Successfully built image: {image_name}")

# Push the image with the specified tag
client.images.push(repository="liorfizz/alpaca", tag=next_version)
print(f"Successfully pushed image: {image_name}")

# Push the image with the 'latest' tag
latest_tag = "latest"
latest_image_name = f"liorfizz/alpaca:{latest_tag}"
image_to_tag = client.images.get(image_name)
image_to_tag.tag(repository="liorfizz/alpaca", tag=latest_tag)
client.images.push(repository="liorfizz/alpaca", tag=latest_tag)
print(f"Successfully pushed image: {latest_image_name}")

# Clean up older versions of the image
for image in images:
    if image.tags and re.match(version_pattern, image.tags[0]):
        version = re.match(version_pattern, image.tags[0]).group(1)
        if version != latest_version and version != next_version:
            client.images.remove(image.id, force=True)
            print(f"Successfully removed image: {image.tags[0]}")
