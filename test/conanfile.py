from conans import ConanFile, tools, CMake
from conans.errors import NotFoundException
import os

class WineTestConan(ConanFile):
    name = "winetest"
    version = "1.0.0"
    description = "Test for Wine"
    # topics can get used for searches, GitHub topics, Bintray tags etc. Add here keywords about the library
    topics = ("wine", "test", "msvc")
    url = ""
    homepage = ""
    author = "Michele Adduci <michele.adduci@openlimit.com>"
    license = ""  # Indicates license type of the packaged library; please use SPDX Identifiers https://spdx.org/licenses/
    exports = ["LICENSE.md", "FindGSOAP.cmake"]      # Packages the license for the conanfile.py
    exports_sources = ["CMakeLists.txt", "test.cpp"]
    generators = "cmake"
    short_paths = True
    settings = "os", "arch", "compiler", "build_type"
    # Custom attributes for Bincrafters recipe conventions
    _source_subfolder = "source_subfolder"
    _build_subfolder = "build_subfolder"

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        #self.run('cmake -g "{generator}" -DCMAKE_BUILD_TYPE={build_type} {source}'.format(generator="NMake MakeFiles", build_type="Release", source=self.source_folder))
        #self.run('cmake --build . ')
        self.run('cmake --build . --target package')

    def package(self):
        # If the CMakeLists.txt has a proper install method, the steps below may be redundant
        # If so, you can just remove the lines below
        include_folder = os.path.join(self._source_subfolder, "include")
        self.copy(pattern="*", dst="include", src=include_folder)
        self.copy(pattern="*.dll", dst="bin", keep_path=False)
        self.copy(pattern="*.lib", dst="lib", keep_path=False)
        self.copy(pattern="*.a", dst="lib", keep_path=False)
        self.copy(pattern="*.so*", dst="lib", keep_path=False)
        self.copy(pattern="*.dylib", dst="lib", keep_path=False)

