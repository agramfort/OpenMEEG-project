# OpenMEEG
#
# Copyright (c) INRIA 2013-2014. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.

function(clapack_project)

    set(ep clapack)

    # List the dependencies of the project

    set(${ep}_dependencies "")
      
    # Prepare the project

    EP_Initialisation(${ep} 
        USE_SYSTEM OFF 
        BUILD_SHARED_LIBS ON
    )

    if (NOT USE_SYSTEM_${ep})

        # Set directories

        EP_SetDirectories(${ep} EP_DIRECTORIES ep_dirs)

        # Define repository where get the sources

        if (NOT DEFINED ${ep}_SOURCE_DIR)
            set(location GIT_REPOSITORY "git@github.com:openmeeg/clapack.git")
        endif()

        # Add specific cmake arguments for configuration step of the project

        set(ep_optional_args)

        # set compilation flags

        if (UNIX)
            set(${ep}_c_flags "${${ep}_c_flags} -w")
        endif()

        set(cmake_args
            ${ep_common_cache_args}
            ${ep_optional_args}
            -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}
            -DBUILD_TESTING:BOOL=OFF
        )

        # Check if patch has to be applied

        ep_GeneratePatchCommand(${ep} PATCH_COMMAND)

        # Add external-project

        ExternalProject_Add(${ep}
            ${ep_dirs}
            ${location}
            UPDATE_COMMAND ""
            ${PATCH_COMMAND}
            CMAKE_GENERATOR ${gen}
            CMAKE_ARGS ${cmake_args}
            DEPENDS ${${ep}_dependencies}
        )

        # Set variable to provide infos about the project

        ExternalProject_Get_Property(clapack binary_dir)
        set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

        # Add custom targets

        EP_AddCustomTargets(${ep})

    endif()

endfunction()