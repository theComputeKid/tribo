# Ensure python set up for google benchmark comparison reports.
# Defines TRIBO_PYTHON_EXE

if(NOT TRIBO_ENABLE_BENCH)
  return()
endif()

# Install virtual env if globally detected python does not have all deps.
# Install deps in virtual env if needed.
find_package(Python3 REQUIRED COMPONENTS Interpreter)

execute_process(
  COMMAND "${Python3_EXECUTABLE}" -c "import numpy, scipy"
  RESULT_VARIABLE myPythonHasNeededDeps
  ERROR_QUIET
)

if(myPythonHasNeededDeps AND NOT myPythonHasNeededDeps EQUAL 0)
  message("Detected python env does not have all deps installed. A virtual env is needed.")
  set(TRIBO_PYTHON_EXE "${CMAKE_CURRENT_BINARY_DIR}/.venv/Scripts/python.exe")

  if(NOT EXISTS "${TRIBO_PYTHON_EXE}")
    message("Creating a virtual env.")
    execute_process(
      COMMAND "${Python3_EXECUTABLE}" -m venv "${CMAKE_CURRENT_BINARY_DIR}/.venv"
      COMMAND_ECHO STDOUT
      COMMAND_ERROR_IS_FATAL ANY
    )
  else()
    message("A virtual env was detected.")
  endif()

  execute_process(
    COMMAND "${TRIBO_PYTHON_EXE}" -c "import numpy, scipy"
    RESULT_VARIABLE myPythonHasNeededDeps
    ERROR_QUIET
  )

  if(myPythonHasNeededDeps AND NOT myPythonHasNeededDeps EQUAL 0)
    message("Virtual env needs deps to be installed.")
    execute_process(
      COMMAND ${TRIBO_PYTHON_EXE} -m pip install --upgrade pip numpy scipy
      COMMAND_ECHO STDOUT
      COMMAND_ERROR_IS_FATAL ANY
    )
  else()
    message("Virtual env has deps installed.")
  endif()
else()
  message("Detected python env has all deps installed.")
  set(TRIBO_PYTHON_EXE "${Python3_EXECUTABLE}")
endif()
