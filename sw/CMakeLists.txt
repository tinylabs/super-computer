#
# Cmake root to build super-computer base directly from raspberry PI zero
#
cmake_minimum_required( VERSION 3.18 )
project( super-computer )

find_package(Git)
if(Git_FOUND)
  message("Git found: ${GIT_EXECUTABLE}")
endif()

# Pull in dependent external repos
include( ExternalProject )

# Download and compile libusbgx
ExternalProject_Add( libusbgx
  PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/ext/libusbgx
  GIT_REPOSITORY https://github.com/linux-usb-gadgets/libusbgx.git
  TIMEOUT 10
  UPDATE_COMMAND ${GIT_EXECUTABLE} pull
  CONFIGURE_COMMAND autoreconf -i && ./configure
  BUILD_COMMAND make
  INSTALL_COMMAND sudo make install
  BUILD_IN_SOURCE 1
)

# Download, patch, compile and link gt
ExternalProject_Add( gt
  DEPENDS libusbgx
  PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/ext/gt
  GIT_REPOSITORY  https://github.com/linux-usb-gadgets/gt.git
  TIMEOUT 10
  UPDATE_COMMAND ${GIT_EXECUTABLE} pull
  # Patch to remove dependency on asciidoc - Its too big...
  #PATCH_COMMAND patch -p1 < xxx
  CMAKE_ARGS ../gt/source/
)

# Add dwc2 overlay in boot

# Update command line to load dwc2 and libcomposite on boot

# Install python scripts

# Start super-computer UI on boot

# Add cron job to look for updates
