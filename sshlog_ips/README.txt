Explanation:

The program prompts the user for the input and output file names.
It opens the input file in read mode and the output file in write mode.
It iterates through each line of the input file.
For each line, it uses a regular expression to extract the IP address.
If an IP address is found, it writes it to the output file with a newline character.
Finally, it closes both files and informs the user about the successful extraction.
File names suggestion:

Input file: You can use the original file name provided by the user.
Output file: You can suggest a name like "extracted_ips.txt" or something more specific depending on the context (e.g., "failed_attempts_ips.txt" if the input file contains logs).
Note:

This program assumes that the IP addresses are formatted as "xxx.xxx.xxx.xxx". You might need to adapt the regular expression if the format varies in your file.
Make sure you have the "strict" and "warnings" modules installed on your system.
