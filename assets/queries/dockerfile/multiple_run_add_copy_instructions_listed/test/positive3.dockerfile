FROM ubuntu
ADD cairo.spec /rpmbuild/SOURCES
ADD cairo-1.13.1.tar.xz /rpmbuild/SOURCES
ADD cairo-multilib.patch /rpmbuild/SOURCES
