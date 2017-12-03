use 5.022001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Replay::Test',
    VERSION_FROM      => 'lib/Replay/Test.pm', 
    PREREQ_PM         => {
        Test::More
    }, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Replay/Test.pm', # retrieve abstract from module
    AUTHOR            => 'David Ihnen <davidihnen@gmail.com>',
    LICENSE           => 'perl',
);
