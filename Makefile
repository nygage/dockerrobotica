all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build        - build robotics"
	# @echo "   1. make pull             - pull all images"
	# @echo "   1. make clean            - remove all images"
	@echo ""

build_coche:
	@docker build --tag=ros:coche coche/. 

# pull:
# 	@docker pull ros

# clean:
# 	@docker rmi -f ros


