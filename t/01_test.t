use Test::Most;
use_ok Replay::Test;

package nomatch;
sub new {return bless {}, shift}
package noCompare;
sub new {return bless {}, shift}
sub match {}
package noWindow;
sub new {return bless {}, shift}
sub match {}
sub compare {}
package noKeyValueSet;
sub new {return bless {}, shift}
sub match {}
sub compare {}
sub window {}
package noReduce;
sub new {return bless {}, shift}
sub match {}
sub compare {}
sub window {}
sub key_value_set {}
package noDelivery;
sub new {return bless {}, shift}
sub match {}
sub compare {}
sub window {}
sub key_value_set {}
sub reduce {}
package noSummary;
sub new {return bless {}, shift}
sub match {}
sub compare {}
sub window {}
sub key_value_set {}
sub reduce {}
sub delivery {}
package noGlobSummary;
sub new {return bless {}, shift}
sub match {}
sub compare {}
sub window {}
sub key_value_set {}
sub reduce {}
sub delivery {}
sub summary {}
package all;
sub new {return bless {}, shift}
sub match {}
sub compare {}
sub window {}
sub key_value_set {}
sub reduce {}
sub delivery {}
sub summary {}
sub globsummary {}

package main;

Replay::Test->new(nomatch->new())->api_ok;

