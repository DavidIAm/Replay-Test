# NAME

Replay::Test - Ability to test the Replay Rules

# SYNOPSIS

    use Replay::Test;
    use Replay::BusinessRule::MyRule;

    my $ruleChecker = Replay::Test->checker(new MyRule);
    # Assert the interface specs are met
    $ruleChecker->api_ok

    # test your input messages
    $ruleChecker->match_ok {message that should match}
    $ruleChecker->match_nok {message that should not match}

    # check how you form your atoms
    $ruleChecker->map_ok {message that matches},
                         [array of { IdKey, atom } ]

    # check your reducer
    $reduceChecker = $ruleChecker->reduceChecker
            { IdKey => , atoms => [atom list] }
    $reducerChecker->reduce_ok [ reduced atoms ]
    $reducerChecker->origin_ok [ origin emit message list ]
    $reducerChecker->derived_ok [ derived message list ]

    # check your reports
    # check your delivery
    my $dcheck = $ruleChecker->deliveryChecker $idkey,
            [ canonical atom list ]
    $dcheck->data_ok { data structure }
    $dcheck->format_ok "whatever formatted thing"
    $dcheck->format_like qr/regex for assertion/

    # check your summary
    my $scheck = $ruleChecker->summaryChecker $idkey,
            { key => {data out of delivery }, ... }
    $scheck->data_ok { data structure }
    $scheck->format_ok "whatever formatted thing"
    $scheck->format_like qr/regex for assertion/

    # check your globsummary
    my $scheck = $ruleChecker->globsummaryChecker $idkey,
            { window => { data out of summary } , ... }
    $gcheck->data_ok { data structure }
    $gcheck->format_ok "whatever formatted thing"
    $gcheck->format_like qr/regex for assertion/

# DESCRIPTION

Test your replay rule.  There are several things you need to know:

- Does it meet the api interface requirements
- does it match the proper messages
- does it map to the right key atom list
- does it reduce an ato list correctly
- does it emit origin events properly during reduce
- does it emit derived events properly during reduce
- does it structure the delivery data correctly
- does it format the delivery output correctly
- does it structure the summary data correctly
- does it format the summary output correctly
- does it structure the globsummary data correctly
- does it format the globsummary output correctly

# SEE ALSO

Replay

# AUTHOR

David Ihnen &lt;lt>davidihnen@gmail.com&lt;gt>

# COPYRIGHT AND LICENSE

Copyright (C) 2017 by David Ihnen

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.22.1 or,
at your option, any later version of Perl 5 you may have available.
