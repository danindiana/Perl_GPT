
```
This repository contains a set of Perl scripts for calculating various statistical measures, including Shannon entropy and Kullback-Leibler (KL) and Jensen-Shannon (JS) divergences.
```

```
To use these scripts, you will need Perl installed on your system, as well as the following modules:

- File::Find
- Math::BaseCalc

These modules should be available through your preferred package manager, or you can install them using CPAN:

perl -MCPAN -e 'install File::Find Math::BaseCalc'

Once the modules are installed, you can run any of the scripts by navigating to the directory where they are stored and running the script with Perl:

perl filename.pl
```

```
This repository contains a set of Perl scripts for calculating various statistical measures, including Shannon entropy and Kullback-Leibler (KL) and Jensen-Shannon (JS) divergences.

1. Shannon Entropy Calculation: The `calculate_entropy` function in the `shannon_entropy.pl` script opens a file, counts the occurrences of each character, and then calculates the entropy based on these counts. The entropy is a measure of the uncertainty or randomness in the data.

2. Kullback-Leibler Divergence: The `kl_divergence` function in the `kl_divergence.pl` script calculates the KL divergence between two probability distributions. It's a measure of how one probability distribution diverges from a second, expected probability distribution.

3. Jensen-Shannon Divergence: The `jensen_shannon_divergence` function in the `js_divergence.pl` script calculates the JS divergence between two probability distributions. It's a symmetrized and finite version of the KL divergence.

4. File Selection: The `file_selector.pl` script uses `File::Find` to find all text files in a specified directory, and then presents these files to the user, numbered, allowing the user to select one or more files by number or range.

5. Example Usage: Here's an example usage section for the scripts:

```perl
# Calculate Shannon entropy of a file
perl shannon_entropy.pl filename.txt

# Calculate KL divergence between two distributions
perl kl_divergence.pl distribution1 distribution2

# Calculate JS divergence between two distributions
perl js_divergence.pl distribution1 distribution2
```

6. To use these scripts, you will need Perl installed on your system, as well as the following modules:

- File::Find
- Math::BaseCalc

These modules should be available through your preferred package manager, or you can install them using CPAN:

perl -MCPAN -e 'install File::Find Math::BaseCalc'

7. Once the modules are installed, you can run any of the scripts by navigating to the directory where they are stored and running the script with Perl:

perl filename.pl

8. Please note that the `parse_selection` function is defined twice in the scripts, which is not necessary and should be corrected. This has been fixed in the latest version of the scripts available on this repository.

9. These scripts are primarily designed to work with text files, and may not be suitable for large or binary files due to memory constraints. Additionally, the scripts assume that each line in the selected file contains only one character, which may not always be the case.

10. These scripts use `strict` and `warnings` to enforce good programming practices and catch potential errors, and they also make use of the `say` function, provided by the `feature 'say'` pragma, for more readable output. The scripts additionally define a custom `log2` function using the `Math::BaseCalc` module for use in entropy calculations.

erl --version

This is perl 5, version 34, subversion 0 (v5.34.0) built for x86_64-linux-gnu-thread-multi
(with 60 registered patches, see perl -V for more detail)

Copyright 1987-2021, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
