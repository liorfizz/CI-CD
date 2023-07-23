import docker

client = docker.from_env()
images = client.images.list()

existing_versions = []
for image in images:
    if image.tags:
        tag = image.tags[0]
        if tag.startswith("liorfizz/alpaca:"):
            version_str = tag[len("liorfizz/alpaca:"):]
            if all(part.isdigit() for part in version_str.split(".")):
                existing_versions.append(version_str)

if existing_versions:
    latest_version = max(existing_versions)
    major, minor, patch = map(int, latest_version.split("."))
    next_version = f"{major}.{minor}.{patch + 1}"
else:
    next_version = "2.3.0"

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
    if image.tags:
        tag = image.tags[0]
        if tag.startswith("liorfizz/alpaca:"):
            version_str = tag[len("liorfizz/alpaca:"):]
            if all(part.isdigit() for part in version_str.split(".")) and version_str != latest_version and version_str != next_version:
                client.images.remove(image.id, force=True)
                print(f"Successfully removed image: {tag}")

