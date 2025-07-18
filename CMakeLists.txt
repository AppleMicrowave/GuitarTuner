cmake_minimum_required(VERSION 3.16)

project(Guitar_tuner VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(FFTW_PATH "C:/lib/fftw64")

# подключение библиотеки fftw
include_directories(${FFTW_PATH})
set(FFTW_LIB "${FFTW_PATH}/libfftw3-3.lib")

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Multimedia)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGuitar_tuner
    main.cpp
)

qt_add_qml_module(appGuitar_tuner
    URI Guitar_tuner
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES images/guitar_default.png
        SOURCES guitar.h guitar.cpp
        SOURCES audiomanager.h audiomanager.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGuitar_tuner PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGuitar_tuner
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGuitar_tuner
    PRIVATE Qt6::Quick
    PRIVATE ${FFTW_LIB}
    PRIVATE Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appGuitar_tuner
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
