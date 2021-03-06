######################################################################################################################################################
#                                                        D E F A U L T    G E N E R A T O R S                                                        #
######################################################################################################################################################


# Default the Binary generators: problem is that none of the CPACK_BINARY_<GenName> will show up in CMakeCache,
# which makes it less clear what will happen in terms of package generation
#if(WIN32)
  #set(CPACK_GENERATOR "IFW;ZIP")
#elseif(APPLE)
  #set(CPACK_GENERATOR "IFW;TGZ")
#elseif(UNIX)
  #set(CPACK_GENERATOR "STGZ;TGZ")
#endif()



# So instead, let's cache the default value we want for the individual options for CPACK_BINARY_<GenName>
if (UNIX)

  # Set everything to off for now
  set(CPACK_BINARY_DEB     OFF CACHE BOOL "Recommended OFF")
  set(CPACK_BINARY_FREEBSD OFF CACHE BOOL "Recommended OFF")
  set(CPACK_BINARY_RPM     OFF CACHE BOOL "Recommended OFF")
  set(CPACK_BINARY_TBZ2    OFF CACHE BOOL "Recommended OFF")
  set(CPACK_BINARY_NSIS    OFF CACHE BOOL "Recommended OFF")

  if(APPLE)
    set(CPACK_BINARY_IFW ON CACHE BOOL "Enable to build IFW package, which is the recommended method")
    set(CPACK_BINARY_STGZ    OFF CACHE BOOL "Recommended OFF")

    # Mac Specific options to turn off
    set(CPACK_BINARY_BUNDLE        OFF CACHE BOOL "Recommended OFF")
    set(CPACK_BINARY_DRAGNDROP     OFF CACHE BOOL "Recommended OFF")
    set(CPACK_BINARY_OSXX11        OFF CACHE BOOL "Recommended OFF")
    set(CPACK_BINARY_PACKAGEMAKER  OFF CACHE BOOL "This was the legacy method on Apple, superseded by IFW.")
    set(CPACK_BINRARY_PRODUCTBUILD OFF CACHE BOOL "Recommended OFF")

  else()
    set(CPACK_BINARY_IFW     OFF CACHE BOOL "This should be off")
    set(CPACK_BINARY_STGZ ON CACHE BOOL "Enable to build a Linux sh installer script, which is the recommended method") # Uses STGZ currently (install .sh script CACHE BOOL)

    # Unix (non Apple CACHE BOOL) specific option to turn off
    set(CPACK_BINARY_TZ  OFF CACHE BOOL "Recommended OFF")
  endif()
  # Tar.gz for inclusion in other programs for eg
  set(CPACK_BINARY_TGZ    ON CACHE BOOL "Enable to build a tar.gz package, recommended for an official release")


elseif(WIN32)
  set(CPACK_BINARY_IFW    ON CACHE BOOL "Enable to build IFW package, which is the recommend method")
  set(CPACK_BINARY_ZIP    ON CACHE BOOL "Enable to build a ZIP package, recommended for an official release")

  set(CPACK_BINARY_NSIS  OFF CACHE BOOL "This was the legacy method on Windows, superseded by IFW")
  set(CPACK_BINARY_7Z    OFF CACHE BOOL "Recommended OFF")
  set(CPACK_BINARY_NUGET OFF CACHE BOOL "Recommended OFF")
  set(CPACK_BINARY_WIX   OFF CACHE BOOL "Recommended OFF")


  # TODO: the "FORCE" is temporary to avoid people having an existing build directory build IFW, remove after next release
  # We want to force update the cache to avoid user suddenly getting build errors
  if(CPACK_BINARY_NSIS)
    set(CPACK_BINARY_NSIS  OFF CACHE BOOL "This was the legacy method on Windows, superseded by IFW" FORCE)
    set(CPACK_BINARY_IFW    ON CACHE BOOL "Enable to build IFW package, which is the recommend method" FORCE)
    message("Switching from NSIS to IFW as the supported generator has changed on Windows")
  endif()

endif()


# Turn off source generators
# Need a list, which can't be empty, but not have sensible defined value. So a list of two empty element works as
# a workaround
# list(CPACK_SOURCE_GENERATOR ";")

# Instead use indiv CPACK_SOURCE_<GenName>: all to OFF
if (UNIX)

  set(CPACK_SOURCE_RPM  OFF CACHE BOOL "Recommended OFF")
  set(CPACK_SOURCE_TBZ2 OFF CACHE BOOL "Recommended OFF")
  set(CPACK_SOURCE_TGZ  OFF CACHE BOOL "Recommended OFF")
  set(CPACK_SOURCE_TXZ  OFF CACHE BOOL "Recommended OFF")
  set(CPACK_SOURCE_TZ   OFF CACHE BOOL "Recommended OFF")
  set(CPACK_SOURCE_ZIP  OFF CACHE BOOL "Recommended OFF")

elseif(WIN32)

  set(CPACK_SOURCE_7Z  OFF CACHE BOOL "Recommended OFF")
  set(CPACK_SOURCE_ZIP OFF CACHE BOOL "Recommended OFF")
endif()


######################################################################################################################################################
#                                              B A S E    I N S T A L L   &    P R O J E C T    I N F O                                              #
######################################################################################################################################################

# Base install
set(CPACK_INSTALL_CMAKE_PROJECTS
  "${CMAKE_BINARY_DIR};EnergyPlus;ALL;/"
)

if( BUILD_FORTRAN )
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/ExpandObjects/;ExpandObjects;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/ReadVars/;ReadVars;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/Transition/;Transition;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/Basement/;Basement;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/HVAC-Diagram/;HVAC-Diagram;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/ParametricPreprocessor/;ParametricPreprocessor;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/Slab/;Slab;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/ConvertESOMTR/;ConvertESOMTR;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/CalcSoilSurfTemp/;CalcSoilSurfTemp;ALL;/")
  list(APPEND CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_BINARY_DIR}/src/AppGPostProcess/;AppGPostProcess;ALL;/")
endif()

set(CPACK_PACKAGE_VENDOR "US Department of Energy" )
set(CPACK_IFW_PACKAGE_PUBLISHER "${CPACK_PACKAGE_VENDOR}")

set(CPACK_PACKAGE_CONTACT "Edwin Lee <edwin.lee@nrel.gov>")
set(CPACK_PACKAGE_DESCRIPTION "EnergyPlus is a whole building energy simulation program that engineers, architects, and researchers use to model both energy consumption and water use in buildings.")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "EnergyPlus is a whole building energy simulation program.")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/Modules")

set(CPACK_PACKAGE_VERSION_MAJOR "${CMAKE_VERSION_MAJOR}" )
set(CPACK_PACKAGE_VERSION_MINOR "${CMAKE_VERSION_MINOR}" )
set(CPACK_PACKAGE_VERSION_PATCH "${CMAKE_VERSION_PATCH}" )
set(CPACK_PACKAGE_VERSION_BUILD "${CMAKE_VERSION_BUILD}" )

set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${CPACK_PACKAGE_VERSION_BUILD}")
# Default the debian package name to include version to allow several versions to be installed concurrently instead of overwriting any existing one
# set(CPACK_DEBIAN_PACKAGE_NAME "energyplus-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

set(CPACK_IFW_PRODUCT_URL "https://www.energyplus.net")
# set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://www.energyplus.net")

include(cmake/TargetArch.cmake)
target_architecture(TARGET_ARCH)

if ( "${CMAKE_BUILD_TYPE}" STREQUAL "" OR "${CMAKE_BUILD_TYPE}" STREQUAL "Release" )
  set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_NAME}-${TARGET_ARCH}")
else()
  set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_NAME}-${TARGET_ARCH}-${CMAKE_BUILD_TYPE}")
endif()

# Installation directory on the target system (common to all CPack Genrators)
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}-${CPACK_PACKAGE_VERSION_MINOR}-${CPACK_PACKAGE_VERSION_PATCH}")

if( WIN32 AND NOT UNIX )
  set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP TRUE)
  include(InstallRequiredSystemLibraries)
  if(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)
    install(PROGRAMS ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION "./")
  endif()
endif()

install(FILES "${CMAKE_SOURCE_DIR}/LICENSE.txt" DESTINATION "./" COMPONENT Licenses)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE.txt")

install( FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Energy+.idd" DESTINATION ./ )
install( FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Energy+.schema.epJSON" DESTINATION ./ )


#################################################################  A U T O D O C S  ##################################################################

# Some docs are generated on the fly here, create a dir for the 'built' files
set( DOCS_OUT "${CMAKE_BINARY_DIR}/autodocs" )
# This is NOT an install command, we actually want it to be performed so we can generate the package, so do it at build system generation
file(MAKE_DIRECTORY ${DOCS_OUT})

# the output variables listing
install(CODE "execute_process(COMMAND \"${PYTHON_EXECUTABLE}\" \"${CMAKE_SOURCE_DIR}/doc/tools/parse_output_variables.py\" \"${CMAKE_SOURCE_DIR}/src/EnergyPlus\" \"${DOCS_OUT}/SetupOutputVariables.csv\" \"${DOCS_OUT}/SetupOutputVariables.md\")")
install(FILES "${CMAKE_BINARY_DIR}/autodocs/SetupOutputVariables.csv" DESTINATION "./")

# the example file summary
install(CODE "execute_process(COMMAND \"${PYTHON_EXECUTABLE}\" \"${CMAKE_SOURCE_DIR}/doc/tools/example_file_summary.py\" \"${CMAKE_SOURCE_DIR}/testfiles\" \"${DOCS_OUT}/ExampleFiles.html\")"
   COMPONENT ExampleFiles)
install(FILES "${DOCS_OUT}/ExampleFiles.html" DESTINATION "./ExampleFiles/" COMPONENT ExampleFiles)

# the example file objects link
install(CODE "execute_process(COMMAND \"${PYTHON_EXECUTABLE}\" \"${CMAKE_SOURCE_DIR}/doc/tools/example_file_objects.py\"
\"${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Energy+.idd\" \"${CMAKE_SOURCE_DIR}/testfiles\" \"${DOCS_OUT}/ExampleFiles-ObjectsLink.html\")"
  COMPONENT ExampleFiles)
install(FILES "${DOCS_OUT}/ExampleFiles-ObjectsLink.html" DESTINATION "./ExampleFiles/" COMPONENT ExampleFiles)

# the change log, only if we do have a github token in the environment
# Watch out! GITHUB_TOKEN could go out of scope by the time install target is run.
# Better to move this condition into the install CODE.
if(NOT "$ENV{GITHUB_TOKEN}" STREQUAL "")
  install(CODE "execute_process(COMMAND \"${PYTHON_EXECUTABLE}\" \"${CMAKE_SOURCE_DIR}/doc/tools/create_changelog.py\" \"${CMAKE_SOURCE_DIR}\" \"${DOCS_OUT}/changelog.md\" \"${DOCS_OUT}/changelog.html\" \"${GIT_EXECUTABLE}\" \"$ENV{GITHUB_TOKEN}\" \"${PREV_RELEASE_SHA}\" \"${CPACK_PACKAGE_VERSION}\")")
  install(FILES "${DOCS_OUT}/changelog.html" DESTINATION "./" OPTIONAL)
else()
  message(WARNING "No GITHUB_TOKEN found in environment; package won't include the change log")
endif()


#################################################################  D A T A S E T S  ##################################################################


# Install files that are in the current repo
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/AirCooledChiller.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/ASHRAE_2005_HOF_Materials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Boilers.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/California_Title_24-2008.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Chillers.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/CompositeWallConstructions.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/DXCoolingCoil.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/ElectricGenerators.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/ElectricityUSAEnvironmentalImpactFactors.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/ElectronicEnthalpyEconomizerCurves.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/ExhaustFiredChiller.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/FluidPropertiesRefData.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/FossilFuelEnvironmentalImpactFactors.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/GLHERefData.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/GlycolPropertiesRefData.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2012.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2013.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2014.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2015.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2016.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2017.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2018.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/LCCusePriceEscalationDataSet2019.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/MoistureMaterials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/PerfCurves.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/PrecipitationSchedulesUSA.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/RefrigerationCasesDataSet.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/RefrigerationCompressorCurves.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/ResidentialACsAndHPsPerfCurves.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/RooftopPackagedHeatPump.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/SandiaPVdata.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Schedules.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/SolarCollectors.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/StandardReports.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/SurfaceColorSchemes.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/USHolidays-DST.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Window5DataFile.dat" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/WindowBlindMaterials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/WindowConstructs.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/WindowGasMaterials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/WindowGlassMaterials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/WindowScreenMaterials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/WindowShadeMaterials.idf" DESTINATION "./DataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/FMUs/MoistAir.fmu" DESTINATION "./DataSets/FMUs" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/FMUs/ShadingController.fmu" DESTINATION "./DataSets/FMUs" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/TDV/TDV_2008_kBtu_CTZ06.csv" DESTINATION "./DataSets/TDV" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/TDV/TDV_read_me.txt" DESTINATION "./DataSets/TDV" COMPONENT Datasets)

INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Macro/Locations-DesignDays.xls" DESTINATION "./MacroDataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Macro/SandiaPVdata.imf" DESTINATION "./MacroDataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Macro/SolarCollectors.imf" DESTINATION "./MacroDataSets" COMPONENT Datasets)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/datasets/Macro/UtilityTariffObjects.imf" DESTINATION "./MacroDataSets" COMPONENT Datasets)


#############################################################  W E A T H E R    D A T A  #############################################################

# weather files
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_CA_San.Francisco.Intl.AP.724940_TMY3.ddy" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_CA_San.Francisco.Intl.AP.724940_TMY3.epw" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_CA_San.Francisco.Intl.AP.724940_TMY3.stat" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_CO_Golden-NREL.724666_TMY3.ddy" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_CO_Golden-NREL.724666_TMY3.epw" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_CO_Golden-NREL.724666_TMY3.stat" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_FL_Tampa.Intl.AP.722110_TMY3.ddy" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_FL_Tampa.Intl.AP.722110_TMY3.epw" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_FL_Tampa.Intl.AP.722110_TMY3.stat" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.ddy" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.stat" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_VA_Sterling-Washington.Dulles.Intl.AP.724030_TMY3.ddy" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_VA_Sterling-Washington.Dulles.Intl.AP.724030_TMY3.epw" DESTINATION "./WeatherData" COMPONENT WeatherData)
INSTALL(FILES "${CMAKE_SOURCE_DIR}/weather/USA_VA_Sterling-Washington.Dulles.Intl.AP.724030_TMY3.stat" DESTINATION "./WeatherData" COMPONENT WeatherData)


#############################################################   E X A M P L E    F I L E S   #########################################################

INSTALL( DIRECTORY testfiles/ DESTINATION ExampleFiles/
  COMPONENT ExampleFiles
  PATTERN _* EXCLUDE
  PATTERN *.ddy EXCLUDE
  PATTERN CMakeLists.txt EXCLUDE
  PATTERN performance EXCLUDE
)


#############################################################   M I S C E L L A N E O U S   ##########################################################

# TODO Remove version from file name or generate
# These files names are stored in variables because they also appear as start menu shortcuts later.
set( RULES_XLS Rules9-1-0-to-9-2-0.md )
install(FILES "${CMAKE_SOURCE_DIR}/release/Bugreprt.txt" DESTINATION "./")
install(FILES "${CMAKE_SOURCE_DIR}/release/ep.gif" DESTINATION "./")
install(FILES "${CMAKE_SOURCE_DIR}/release/readme.html" DESTINATION "./")
set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/release/readme.html")

install(FILES "${CMAKE_SOURCE_DIR}/bin/CurveFitTools/IceStorageCurveFitTool.xlsm" DESTINATION "PreProcess/HVACCurveFitTool/")
install(FILES "${CMAKE_SOURCE_DIR}/idd/V9-1-0-Energy+.idd" DESTINATION "PreProcess/IDFVersionUpdater/")
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Energy+.idd" DESTINATION "PreProcess/IDFVersionUpdater/" RENAME "V9-2-0-Energy+.idd" )

# Workflow stuff, takes about 40KB, so not worth it proposing to not install it
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/workflows/app_g_postprocess.py" DESTINATION "workflows/") # COMPONENT Workflows)
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/workflows/calc_soil_surface_temp.py" DESTINATION "workflows/") # COMPONENT Workflows)
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/workflows/coeff_check.py" DESTINATION "workflows/") # COMPONENT Workflows)
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/workflows/coeff_conv.py" DESTINATION "workflows/") # COMPONENT Workflows)
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/workflows/energyplus.py" DESTINATION "workflows/") # COMPONENT Workflows)
install(FILES "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/workflows/transition.py" DESTINATION "workflows/") # COMPONENT Workflows)


######################################################################################################################################################
#                                                         P L A T F O R M    S P E C I F I C                                                         #
######################################################################################################################################################

if( WIN32 )
  # calcsoilsurftemp is now built from source, just need to install the batch run script
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/CalcSoilSurfTemp/RunCalcSoilSurfTemp.bat" DESTINATION "PreProcess/CalcSoilSurfTemp/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Launch/EP-Launch.exe" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/scripts/Epl-run.bat" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/scripts/RunDirMulti.bat" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/release/RunEP.ico" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/scripts/RunEPlus.bat" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/scripts/RunReadESO.bat" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/release/Runep.pif" DESTINATION "./")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CSVProc/CSVproc.exe" DESTINATION "PostProcess/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/scripts/RunReadESO.bat" DESTINATION "PostProcess/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/CoeffCheck.exe" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/CoeffCheckExample.cci" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/CoeffConv.exe" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/CoeffConvExample.coi" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/EPL-Check.BAT" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/EPL-Conv.BAT" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CoeffConv/ReadMe.txt" DESTINATION "PreProcess/CoeffConv/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Basement/RunBasement.bat" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Slab/RunSlab.bat" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/CurveFitTools/CurveFitTool.xlsm" DESTINATION "PreProcess/HVACCurveFitTool/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFEditor/IDFEditor.exe" DESTINATION "PreProcess/IDFEditor/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/ParametricPreprocessor/RunParam.bat" DESTINATION "PreProcess/ParametricPreProcessor/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/ViewFactorCalculation/readme.txt" DESTINATION "PreProcess/ViewFactorCalculation/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/ViewFactorCalculation/View3D.exe" DESTINATION "PreProcess/ViewFactorCalculation/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/ViewFactorCalculation/View3D32.pdf" DESTINATION "PreProcess/ViewFactorCalculation/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/ViewFactorCalculation/ViewFactorInterface.xls" DESTINATION "PreProcess/ViewFactorCalculation/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/Abbreviations.csv" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/ASHRAE_2013_Monthly_DesignConditions.csv" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/ASHRAE_2013_OtherMonthly_DesignConditions.csv" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/ASHRAE_2013_Yearly_DesignConditions.csv" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/Cal Climate Zone Lat Long data.csv" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/CountryCodes.txt" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/EPlusWth.dll" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/libifcoremd.dll" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/libifportmd.dll" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/libmmd.dll" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/svml_dispmd.dll" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/TimeZoneCodes.txt" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/WBANLocations.csv" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/WeatherConverter/Weather.exe" DESTINATION "PreProcess/WeatherConverter/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare Libs/Appearance Pak.dll" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare Libs/EHInterfaces5001.dll" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare Libs/EHObjectArray5001.dll" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare Libs/EHObjectCollection5001.dll" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare Libs/EHTreeView4301.DLL" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare Libs/MBSChartDirector5Plugin16042.dll" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Win/EP-Compare.exe" DESTINATION "PostProcess/EP-Compare/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/GraphHints.csv" DESTINATION "PostProcess/EP-Compare/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/EPDrawGUI Libs/Appearance Pak.dll" DESTINATION "PreProcess/EPDraw/EPDrawGUI Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/EPDrawGUI Libs/Shell.dll" DESTINATION "PreProcess/EPDraw/EPDrawGUI Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/EPDrawGUI.exe" DESTINATION "PreProcess/EPDraw/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/EPlusDrw.dll" DESTINATION "PreProcess/EPDraw/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/libifcoremd.dll" DESTINATION "PreProcess/EPDraw/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/libifportmd.dll" DESTINATION "PreProcess/EPDraw/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/libmmd.dll" DESTINATION "PreProcess/EPDraw/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EPDraw/Run-Win/svml_dispmd.dll" DESTINATION "PreProcess/EPDraw/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Basement/basementexample.audit" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Basement/basementexample.csv" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Basement/BasementExample.idf" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Basement/basementexample.out" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Basement/basementexample_out.idf" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Slab/slabexample.ger" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Slab/slabexample.gtp" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/src/Slab/SlabExample.idf" DESTINATION "PreProcess/GrndTempCalc/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Win/IDFVersionUpdater Libs/Appearance Pak.dll" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Win/IDFVersionUpdater Libs/RBGUIFramework.dll" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Win/IDFVersionUpdater Libs/msvcp120.dll" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Win/IDFVersionUpdater Libs/msvcr120.dll" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Win/IDFVersionUpdater Libs/Shell.dll" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Win/IDFVersionUpdater.exe" DESTINATION "PreProcess/IDFVersionUpdater/")
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/EPMacro/Windows/EPMacro.exe" DESTINATION "./")

  # This copies system DLLs into a temp folder. It is later used by the install script of this specific component
  # to check if the dll isn't present on the target system, in which case it will copy it to the system folder (eg: C:\Windows\SysWOW64\)
  # and use the regsvr32.exe to register said DLL.
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/ComDlg32.OCX" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Dforrt.dll" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Graph32.ocx" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Gsw32.exe" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Gswdll32.dll" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/MSCOMCTL.OCX" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Msflxgrd.ocx" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/MSINET.OCX" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Msvcrtd.dll" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/System/Vsflex7L.ocx" DESTINATION "./temp/" COMPONENT CopyAndRegisterSystemDLLs)
endif()

# The group, which will be used to configure the root package
# set(CPACK_IFW_PACKAGE_GROUP "EnergyPlus")
#set(CPACK_IFW_PACKAGE_WIZARD_DEFAULT_WIDTH 640)
#set(CPACK_IFW_PACKAGE_WIZARD_DEFAULT_HEIGHT 480)
set(CPACK_IFW_PACKAGE_WINDOW_ICON "${CMAKE_SOURCE_DIR}/release/ep_nobg.png")


if( APPLE )
  set(CPACK_PACKAGE_DEFAULT_LOCATION "/Applications")
  set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
  set(CPACK_IFW_TARGET_DIRECTORY "/Applications/${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}-${CPACK_PACKAGE_VERSION_MINOR}-${CPACK_PACKAGE_VERSION_PATCH}")

  install(DIRECTORY "${CMAKE_SOURCE_DIR}/bin/EP-Launch-Lite/EP-Launch-Lite.app" DESTINATION "PreProcess")
  install(DIRECTORY "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Mac/IDFVersionUpdater.app" DESTINATION "PreProcess/IDFVersionUpdater")
  install(DIRECTORY "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Mac/EP-Compare.app" DESTINATION "PostProcess/EP-Compare")
  install(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/GraphHints.csv" DESTINATION "PostProcess/EP-Compare/")
  install(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/EPMacro/Mac/EPMacro" DESTINATION "./")

  configure_file(scripts/runenergyplus.in "${CMAKE_BINARY_DIR}/scripts/runenergyplus" @ONLY)
  install(PROGRAMS "${CMAKE_BINARY_DIR}/scripts/runenergyplus" DESTINATION "./")
  install(PROGRAMS scripts/runepmacro DESTINATION "./")
  install(PROGRAMS scripts/runreadvars DESTINATION "./")

  # You need at least one "install(..." command for it to be registered as a component
  install(CODE "MESSAGE(\"Creating symlinks.\")" COMPONENT Symlinks)

  # Custom installer icon. Has to be .icns on mac, .ico on windows, not supported on Unix
  set(CPACK_IFW_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/release/ep.icns")
elseif(WIN32)

  # TODO: TEMP
  set(CPACK_IFW_VERBOSE ON)

  # Will also set CPACK_IFW_PACKAGE_START_MENU_DIRECTORY (name of default program group in Windows start menu)
  set(CPACK_IFW_PACKAGE_NAME "EnergyPlusV${CPACK_PACKAGE_VERSION_MAJOR}-${CPACK_PACKAGE_VERSION_MINOR}-${CPACK_PACKAGE_VERSION_PATCH}")

  set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_IFW_PACKAGE_NAME}" )
  set(CPACK_IFW_TARGET_DIRECTORY "C:/${CPACK_PACKAGE_INSTALL_DIRECTORY}" )

    # Custom installer icon. Has to be .icns on mac, .ico on windows, not supported on Unix
  set(CPACK_IFW_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/release/ep.ico")

  # You need at least one "install(..." command for it to be registered as a component
  install(CODE "MESSAGE(\"Registering filetypes.\")" COMPONENT RegisterFileType)
  install(CODE "MESSAGE(\"Copying and Registering DLLs\")" COMPONENT CopyAndRegisterSystemDLLs)
  install(CODE "MESSAGE(\"Creating start menu.\")" COMPONENT CreateStartMenu)

endif()

if(UNIX)
  install(FILES doc/man/energyplus.1 DESTINATION "./")
endif()

if( UNIX AND NOT APPLE )
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare" DESTINATION "PostProcess/EP-Compare/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare Libs/EHInterfaces5001.so" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare Libs/EHObjectArray5001.so" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare Libs/EHObjectCollection5001.so" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare Libs/EHTreeView4301.so" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare Libs/libMBSChartDirector5Plugin16042.so" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/EP-Compare/Run-Linux/EP-Compare Libs/libRBAppearancePak.so" DESTINATION "PostProcess/EP-Compare/EP-Compare Libs/")

  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Linux/IDFVersionUpdater Libs/libRBAppearancePak.so" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Linux/IDFVersionUpdater Libs/libRBShell.so" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Linux/IDFVersionUpdater Libs/RBGUIFramework.so" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(FILES "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Linux/IDFVersionUpdater Libs/libc++.so.1" DESTINATION "PreProcess/IDFVersionUpdater/IDFVersionUpdater Libs/")
  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/IDFVersionUpdater/Run-Linux/IDFVersionUpdater" DESTINATION "PreProcess/IDFVersionUpdater/")

  INSTALL(PROGRAMS "${CMAKE_SOURCE_DIR}/bin/EPMacro/Linux/EPMacro" DESTINATION "./")

  configure_file(scripts/runenergyplus.in "${CMAKE_BINARY_DIR}/scripts/runenergyplus" @ONLY)
  install(PROGRAMS "${CMAKE_BINARY_DIR}/scripts/runenergyplus" DESTINATION "./")
  install(PROGRAMS scripts/runepmacro DESTINATION "./")
  install(PROGRAMS scripts/runreadvars DESTINATION "./")
endif()

# TODO: Unused now
configure_file("${CMAKE_SOURCE_DIR}/cmake/CMakeCPackOptions.cmake.in"
  "${CMAKE_BINARY_DIR}/CMakeCPackOptions.cmake" @ONLY)
set(CPACK_PROJECT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CMakeCPackOptions.cmake")

##########################################################   D O C U M E N T A T I O N   #############################################################

if ( BUILD_DOCS )
  # Call the build of target documentation explicitly here.
  # Note: This is because you can't do `add_dependencies(package documentation)` (https://gitlab.kitware.com/cmake/cmake/issues/8438)
  # Adding another custom target to be added to the "ALL" one (so it runs) and make it depend on the actual "documentation" target doesn't work
  # because it'll always run if you have enabled BUILD_DOCS, regardless of whether you are calling the target "package" or not
  #  add_custom_target(run_documentation ALL)
  #  add_dependencies(run_documentation documentation)
  #message(FATAL_ERROR "CMAKE_COMMAND=${CMAKE_COMMAND}")

  # +env will pass the current environment and will end up respecting the -j parameter
  #                                 this ↓↓↓ here -- https://stackoverflow.com/a/41268443/531179
  #install(CODE "execute_process(COMMAND +env \"${CMAKE_COMMAND}\" --build \"${CMAKE_BINARY_DIR}\" --target documentation)")
  # Except it doesn't work with install(execute_process...

  # Passing $(MAKE) doesn't work either, and isn't a great idea for cross platform support anyways
  # install(CODE "execute_process(COMMAND ${MAKE} ${DOC_BUILD_FLAGS} -C \"${CMAKE_BINARY_DIR}\" documentation)")

  # So instead, we just used the number of threads that are available. That's not ideal, since it ignores any "-j N" option passed by the user
  # But LaTeX should run quickly enough to not be a major inconvenience.
  # There no need to do that for Ninja for eg, so only do it for Make and MSVC

  # flag -j to cmake --build was added at 3.12 (VERSION_GREATER_EQUAL need cmake >= 3.7, we apparently support 2.8...)
  if(NOT(CMAKE_VERSION VERSION_LESS "3.12") AND ((CMAKE_GENERATOR MATCHES "Make") OR WIN32))
    include(ProcessorCount)
    ProcessorCount(N)
    if(NOT N EQUAL 0)
      set(DOC_BUILD_FLAGS "-j ${N}")
    endif()
  endif()
  if(WIN32)
    # Win32 is multi config, so you must specify a config when calling cmake.
    # Let's just use Release, it won't have any effect on LaTeX anyways.
    set(DOC_CONFIG_FLAG "--config Release")
  endif()

  # Getting these commands to work (especially with macro expansion) is tricky. Check the resulting `cmake_install.cmake` file in your build folder if need to debug this
  install(CODE "execute_process(COMMAND \"${CMAKE_COMMAND}\" --build \"${CMAKE_BINARY_DIR}\" ${DOC_CONFIG_FLAG} ${DOC_BUILD_FLAGS} --target documentation)"
          COMPONENT Documentation)

  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/Acknowledgments.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/AuxiliaryPrograms.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/EMSApplicationGuide.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/EngineeringReference.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/EnergyPlusEssentials.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/ExternalInterfacesApplicationGuide.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/GettingStarted.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/InputOutputReference.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/InterfaceDeveloper.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/ModuleDeveloper.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/OutputDetailsAndExamples.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/PlantApplicationGuide.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/TipsAndTricksUsingEnergyPlus.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
  install(FILES "${CMAKE_BINARY_DIR}/doc-pdf/UsingEnergyPlusForCompliance.pdf" DESTINATION "./Documentation" COMPONENT Documentation)
else()
  message(AUTHOR_WARNING "BUILD_DOCS isn't enabled, so package won't include the PDFs")
endif ()

##########################################################   S Y S T E M    L I B R A R I E S   ######################################################

# TODO: is this unecessary now? I had forgotten to actually create a Libraries via cpack_add_component but everything seemed fined
# At worse, try not to uncomment this as is, but place it inside an if(PLATFORM) statement
#SET(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
#INCLUDE(InstallRequiredSystemLibraries)
#INSTALL(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION "./" COMPONENT Libraries)

######################################################################################################################################################
#                                                    P A C K A G I N G   &   C O M P O N E N T S                                                     #
######################################################################################################################################################

# Careful: the position (and what you include) matters a lot!
include(CPack)
include(CPackIFW)
# include(CPackComponent)

#cpack_add_component(EnergyPlus
  #DISPLAY_NAME "EnergyPlus"
  #DESCRIPTION "The EnergyPlus program itself"
  #REQUIRED
#)

#cpack_add_component(AuxiliaryPrograms
  #DISPLAY_NAME "Auxiliary Programs"
  #DESCRIPTION "The suite of Fortran auxiliary programs such as ReadVarsESO, ExpandObjects, etc"
  #REQUIRED
#)

cpack_add_component(Documentation
  DISPLAY_NAME "Documentation"
  DESCRIPTION "EnergyPlus documentation in PDF format"
)

cpack_add_component(Datasets
  DISPLAY_NAME "Datasets"
  DESCRIPTION "Useful resources such as material and equipment performance data"
)

cpack_add_component(ExampleFiles
  DISPLAY_NAME "Example Files"
  DESCRIPTION "IDF Example Files"
)

cpack_add_component(WeatherData
  DISPLAY_NAME "Weather Data"
  DESCRIPTION "EPW Weather Files"
)

# This stuff actually requires admin privileges since touched system locations
cpack_add_component(Symlinks
  DISPLAY_NAME "Create Symlinks - requires admin"
  DESCRIPTION "This will symlink the executable to /usr/local/bin and copy the man page"
)

# Could add any upstream library license to this
cpack_add_component(Licenses
  DISPLAY_NAME "Licenses"
  DESCRIPTION "License files for EnergyPlus"
  REQUIRED)

# No need for system privileges for this
cpack_add_component(CreateStartMenu
  DISPLAY_NAME "Start Menu links"
  DESCRIPTION "Create Start Menu Links"
)

cpack_add_component(RegisterFileType
  DISPLAY_NAME "Associate with EP-Launch and IDFEditor"
  DESCRIPTION "Associate *.idf, *.imf, and *.epg files with EP-Launch, *.ddy and *.expidf with IDFEditor.exe"
)

cpack_add_component(CopyAndRegisterSystemDLLs
  DISPLAY_NAME "Copy and Register DLLs"
  DESCRIPTION "This will copy and register system DLLs such as Fortran if they don't already exist"
  REQUIRED
)

#cpack_add_component(Libraries
#  DISPLAY_NAME "Install required system libraries"
#  DESCRIPTION  "This is probably not required right now..."
#)

# Regular stuff, like chmod +x
cpack_ifw_configure_component(Unspecified
    SCRIPT cmake/qtifw/install_operations.qs
)

cpack_ifw_configure_component(Symlinks
    SCRIPT cmake/qtifw/install_mac_createsymlinks.qs
    REQUIRES_ADMIN_RIGHTS
)

cpack_ifw_configure_component(CreateStartMenu
    SCRIPT cmake/qtifw/install_win_createstartmenu.qs
)

cpack_ifw_configure_component(RegisterFileType
    SCRIPT cmake/qtifw/install_registerfiletype.qs
    REQUIRES_ADMIN_RIGHTS
)

cpack_ifw_configure_component(CopyAndRegisterSystemDLLs
    SCRIPT cmake/qtifw/install_win_copydll.qs
    REQUIRES_ADMIN_RIGHTS
)

cpack_ifw_configure_component(Licenses
  FORCED_INSTALLATION
  LICENSES
    "EnergyPlus" ${CPACK_RESOURCE_FILE_LICENSE}
)
