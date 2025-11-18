use strict;
use warnings;
use File::Find;
use File::Basename;
use IO::Handle;

print "Enter the file type (e.g. pdf, txt): ";
my $file_type = <STDIN>;
chomp $file_type;

print "Enter the target directory: ";
my $dir = <STDIN>;
chomp $dir;

print "Enter the file size to delete (in kilobytes): ";
my $size_kb = <STDIN>;
chomp $size_kb;
my $size_bytes = $size_kb * 1024; # Convert kilobytes to bytes

print "Choose the comparison (smaller, larger, equal): ";
my $comparison = <STDIN>;
chomp $comparison;
$comparison = lc $comparison;

print "Include subdirectories? (yes/no): ";
my $include_subdirs = <STDIN>;
chomp $include_subdirs;
$include_subdirs = lc($include_subdirs) eq 'yes';

# Array to store files matching criteria
my @files_to_delete;

find(sub {
    return if !$include_subdirs && $File::Find::dir ne $dir; # Skip subdirectories if not included

    my ($name, $path, $suffix) = fileparse($_, qr/\.[^.]*/);
    return unless -f and lc $suffix eq ".$file_type";

    my $file_size = -s $_;

    if (($comparison eq 'smaller' and $file_size < $size_bytes) or
        ($comparison eq 'larger' and $file_size > $size_bytes) or
        ($comparison eq 'equal' and abs($file_size - $size_bytes) <= 512)) {
        push @files_to_delete, $File::Find::name;
        print "Matching file found: $File::Find::name\n"; # Debug information
    }
}, $dir);

print scalar(@files_to_delete) . " file(s) will be deleted.\n";

if (@files_to_delete) {
    print "Do you want to continue? (yes/no): ";
    STDIN->flush(); # Flush any extra characters from input stream
    my $confirm = <STDIN>;
    chomp $confirm;

    if (lc($confirm) eq 'yes') {
        foreach my $file (@files_to_delete) {
            unlink $file or warn "Failed to delete $file: $!\n";
            print "Deleted $file\n";
        }
        print "Deletion complete.\n";
    } else {
        print "Deletion cancelled.\n";
    }
} else {
    print "No files found matching the criteria.\n";
}
