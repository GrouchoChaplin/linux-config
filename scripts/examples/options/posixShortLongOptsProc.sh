#!/bin/sh
# POSIX

# Reset all variables that might be set
file=
verbose=0 # Variables to be evaluated as shell arithmetic should be initialized to a default or validated beforehand.

while :; do
    case $1 in
        -h|-\?|--help)   # Call a "show_help" function to display a synopsis, then exit.
            show_help
            exit
            ;;
        -f|--file)       # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                file=$2
                shift
            else
                printf 'ERROR: "--file" requires a non-empty option argument.\n' >&2
                exit 1
            fi
            ;;
        --file=?*)
            file=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --file=)         # Handle the case of an empty --file=
            printf 'ERROR: "--file" requires a non-empty option argument.\n' >&2
            exit 1
            ;;
        -v|--verbose)
            verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done

# if --file was provided, open it for writing, else duplicate stdout
if [ -n "$file" ]; then
    exec 3> "$file"
else
    exec 3>&1
fi

# Rest of the program here.
# If there are input files (for example) that follow the options, they
# will remain in the "$@" positional parameters.