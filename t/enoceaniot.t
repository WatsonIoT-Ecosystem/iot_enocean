# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl enoceaniot.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('enoceaniot') };


my $fail = 0;
foreach my $constname (qw(
	CONFIG_FILE_ERROR MISSING_INPUT_PARAM QUICKSTART_NOT_SUPPORTED)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined enoceaniot macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

