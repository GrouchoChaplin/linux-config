#!/bin/bash

# create_flutter_lib_folder.sh
# Usage: ./create_flutter_lib_folder.sh /path/to/flutter/project

# Exit on error
set -e

# Check if PROJECT_ROOT argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/flutter/project"
  exit 1
fi

PROJECT_ROOT=$1
LIB_DIR="$PROJECT_ROOT/lib"

# Create base lib/ folder
mkdir -p "$LIB_DIR"

# Core Layer
mkdir -p "$LIB_DIR/core/constants"
mkdir -p "$LIB_DIR/core/services"
mkdir -p "$LIB_DIR/core/utils"

# Data Layer
mkdir -p "$LIB_DIR/data/models"
mkdir -p "$LIB_DIR/data/api"
mkdir -p "$LIB_DIR/data/repositories"

# Domain Layer (optional clean arch)
mkdir -p "$LIB_DIR/domain/entities"
mkdir -p "$LIB_DIR/domain/usecases"
mkdir -p "$LIB_DIR/domain/repositories"

# Presentation Layer
mkdir -p "$LIB_DIR/presentation/screens"
mkdir -p "$LIB_DIR/presentation/widgets"
mkdir -p "$LIB_DIR/presentation/state"

# Main entry points
touch "$LIB_DIR/main.dart"
touch "$LIB_DIR/app.dart"

echo "✅ Flutter lib folder structure created at: $LIB_DIR"
