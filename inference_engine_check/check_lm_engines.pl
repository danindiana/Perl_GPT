#!/usr/bin/perl
use strict;
use warnings;

# List of language model engines and corresponding executable names
my %lm_engines = (
    'llama.cpp'       => 'llama',
    'ollama'          => 'ollama',
    'transformers'    => 'transformers-cli',
    'GPT4All'         => 'gpt4all',
    'Langchain'       => 'langchain',
    'Cerebras-GPT'    => 'cerebras',
    'Alpaca-LoRA'     => 'alpaca-lora',
    'GPTQ'            => 'gptq',
);

# Subroutine to check if a program is installed
sub check_installed {
    my ($program) = @_;
    my $output = `which $program 2>/dev/null`;
    return ($output ne "") ? 1 : 0;
}

# Scan for installed engines and report status
print "Scanning for installed local language model inference engines...\n\n";

foreach my $engine (keys %lm_engines) {
    if (check_installed($lm_engines{$engine})) {
        print "✔ $engine is installed.\n";
    } else {
        print "✘ $engine is not installed. Consider installing it.\n";
    }
}

print "\nScan complete.\n";

# Optional: List of commands to install missing engines (if desired)
# You could extend this by outputting suggestions for package managers like apt, yum, or pip
