**Step-by-Step Explanation:**

1. **Shebang and Pragmas:**
   - `#!/usr/bin/perl`: Specifies the Perl interpreter.
   - `use strict;` and `use warnings;`: Enable strict syntax checking and warning messages.

2. **Module Imports:**
   - `JSON`: For encoding Perl data structures to JSON text.
   - `File::Find`: For traversing directory trees.
   - `File::Basename`: For extracting the filename from a path.
   - `Term::ANSIColor`: For adding color to console output.
   - `IO::Handle`: For input/output handle operations.
   - `Data::Dumper`: For debugging purposes to print data structures.

3. **Constants Definition:**
   - `$JSONL_MAX_SIZE`: Maximum size for JSONL files (2GB).
   - `$output_dir`: Directory where output JSONL files are stored.
   - `$jsonl_file_base`: Base name for output JSONL files.

4. **Variables Initialization:**
   - `$total_files_enrolled`: Keeps track of the total number of files processed.
   - `$running`: Controls the main program loop.

5. **Subroutine: log_message()**
   - Prints messages to the console prefixed with "[INFO]" in cyan color.

6. **Subroutine: prompt()**
   - Displays a message in yellow color and reads a response from the user.

7. **Subroutine: process_directory()**
   - **Parameters:** `$target_dir` (directory to scan), `$recursive` (boolean for recursive scanning).
   - **Functionality:**
     - Logs the directory being scanned.
     - Uses `File::Find` if recursive, else uses `opendir` to list files.
     - Collects `.txt` files into `@files`.
     - (Debug) Dumps the list of files found using `Data::Dumper`.
     - Opens a JSONL file for writing.
     - Processes each `.txt` file:
       - Reads file content.
       - Creates metadata hash with filename, path, size, and modification time.
       - Creates a JSON object with metadata and content.
       - Encodes the JSON object and writes it to the JSONL file.
       - Checks and manages JSONL file size limit.
       - Logs each file processed.
     - Closes the JSONL file handle.
     - Updates the total file count.

8. **Subroutine: shutdown_handler()**
   - Handles shutdown signals (INT, TERM).
   - Logs a shutdown message and sets `$running` to 0.

9. **Signal Handlers Setup:**
   - Installs `shutdown_handler` for INT and TERM signals.

10. **Main Program Loop:**
    - Continuously prompts for a directory to scan.
    - Checks if the input is a valid directory.
    - Prompts whether to include subdirectories.
    - Ensures the output directory exists; creates it if not.
    - Calls `process_directory()` with the target directory and recursion flag.
    - Logs the number of files processed in the current run.
    - Asks if the user wants to process another directory.
    - Exits the loop if the user doesn't want to continue.

11. **Program Exit:**
    - Logs the total number of files enrolled during the entire program run.

**Summary:**

This Perl script scans specified directories for `.txt` files, collects their metadata and content, and outputs them into JSONL files. It manages file size by creating new JSONL files when the size limit is reached. The script handles interruptions gracefully and provides a user-friendly interface for input and feedback.
