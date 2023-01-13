image_name := neovim-builder

all: build-container
	podman run --rm \
		--volume $(CURDIR):/home/builder/workspace \
		--workdir /home/builder/workspace \
		--entrypoint ./build.sh \
		--userns keep-id \
		$(image_name)

build-container: Containerfile
	podman build . -t $(image_name)

clean:
	rm -Rf build
