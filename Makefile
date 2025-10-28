ISO_SERVER_URL ?= http://192.168.10.1
ISO_DIR ?= ./iso
ISO_9660_DIR ?= ./iso_9660

.PHONY: up
up: iso_9660_mount
	ISO_DIR=${ISO_DIR} \
	ISO_9660_DIR=${ISO_9660_DIR} \
	docker compose up -d

.PHONY: down
down: iso_9660_umount
	ISO_DIR=${ISO_DIR} \
	ISO_9660_DIR=${ISO_9660_DIR} \
	docker compose down -v

.PHONY: iso_9660_mount
iso_9660_mount:
	mkdir -p ${ISO_9660_DIR}; \
	for iso_file in ${ISO_DIR}/*.iso; do \
		[ -f "$$iso_file" ] && { \
			echo "Processing $$(basename -s .iso $$iso_file)"; \
			mkdir -p ${ISO_9660_DIR}/$$(basename -s .iso $$iso_file); \
			sudo mount -t iso9660 -o loop,ro \
				$$iso_file \
				${ISO_9660_DIR}/$$(basename -s .iso $$iso_file); \
		}; \
	done

.PHONY: iso_9660_umount
iso_9660_umount:
	for dir in ${ISO_9660_DIR}/*; do \
		[ -d "$$dir" ] && { \
			echo "Processing $$(basename -s .iso $$dir)"; \
			sudo umount ${ISO_9660_DIR}/$$(basename -s .iso $$dir); \
		}; \
	done; \
	rm -rf ${ISO_9660_DIR}
