# Appcircle _Gradle Runner_ component

Runs a Gradle task

## Required Input Variables

- `AC_REPOSITORY_DIR`: Specifies the cloned repository path.
- `AC_MODULE`: Specifies the project module to be built.
- `AC_VARIANTS`: Specifies build variants. For example: `-configuration DEBUG`.
- `AC_GRADLE_OUTPUT_DIR`: Specifies the directory path for the generated app files.
- `AC_GRADLE_TASK`: Specifies Gradle task name.

## Optional Inputs Variables

- `AC_PROJECT_PATH`: Specifies the project path.
- `AC_GRADLE_TASK_EXTRA_PARAMETERS`: Extra command-line parameters for the task.

## Required Steps

-  Git Clone

## Preceding Steps

-  Activate SSH Key

## Following Steps

-  Export Build Artifacts

