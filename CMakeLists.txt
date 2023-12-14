cmake_minimum_required(VERSION 3.19...3.28)

project(FortranMPIexamples
LANGUAGES C Fortran
)

enable_testing()

include(cmake/compilers.cmake)

add_subdirectory(test)

file(GENERATE OUTPUT .gitignore CONTENT "*")
