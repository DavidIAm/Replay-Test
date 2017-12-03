package Replay::Test;

use 5.022001;
use strict;
use warnings;
use Test::More;
use Digest::MD5;

our $VERSION = '0.01';

sub new {
  my ($class, $rule) = @_;
  my $self = bless { rule => $rule }, $class;
  return $self;
}

sub rule {
  my ($self) = @_;
  return $self->{rule};
}

sub api_ok {
  my ($self) = @_;
  ok $self->rule->can('match');
  ok $self->rule->can('compare');
  ok $self->rule->can('window');
  ok $self->rule->can('key_value_set');
  ok $self->rule->can('reduce');
  ok $self->rule->can('delivery');
  ok $self->rule->can('summary');
  ok $self->rule->can('globsummary');
}

sub match_ok {
  my ($self, $message) = @_;
  ok $self->rule->match($message);
}

sub match_nok {
  my ($self, $message) = @_;
  ok not $self->rule->match($message);
}

sub window_ok {
  my ($self, $message, $window) = @_;
  is $self->rule->window($message), $window;
}

sub map_nok {
  my ($self, $message) = @_;
  my $list = [ $self->rule->key_value_set($message) ];
  is_deeply $list, []
}

sub canon_hash {
  my ($self, $hash) = @_;
  my $out = '';
  foreach my $key (sort keys %{$hash}) {
    my $value = $self->canon_struct($hash->{$key});
    $key =~ s/:/\\:/g;
    $value =~ s/:/\\:/g;
    $out = join ',', $out, join ':', $key, $value;
  }
  return $out;
}

sub canon_struct {
  my ($self, $struct) = @_;
  return $self->canon_hash($struct) if "HASH" eq ref $struct;
  return $self->canon_array($struct) if "ARRAY" eq ref $struct;
  return ${$struct} if "SCALAR" eq ref $struct;
  return $struct;
}

sub canon_array {
  my ($self, $struct) = @_;
  return join ',', map { s/,/\\,/g } @{$struct};
}

sub hash_struct {
  my ($self, $struct) = @_;
  my $ctx = Digest::MD5->new;
  $ctx->add($self->canon_struct($ctx, $struct) );
  return $ctx->hexdigest;
}

sub map_ok {
  my ($self, $message, $result_set) = @_;
  my (@map_result) = $self->rule->key_value_set($message);
#  my $test_set = [ sort map { $self->hash_struct($_) } @map_result ];
#  my $assert_set = [ sort map { $self->hash_struct($_) } @{$result_set} ];
  is_deeply $test_set, $assert_set;
}


1;
__END__

=head1 NAME

Replay::Test - Ability to test the Replay Rules

=head1 SYNOPSIS

  use Replay::Test;
  use Replay::BusinessRule::MyRule;

  my $ruleChecker = Replay::Test->checker(new MyRule);
  # Assert the interface specs are met
  $ruleChecker->api_ok

  # test your input messages
  $ruleChecker->match_ok {message that should match}
  $ruleChecker->match_nok {message that should not match}

  # check how you window your keys
  $ruleChecker->window_ok {message that matches}, $window

  # check how you form your atoms
  $ruleChecker->map_ok {message that matches},
                       [array of { IdKey, atom } ]

  # check your ordering
  $ruleChecker->compare_ok earlier_atom, later_atom

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


=head1 DESCRIPTION

Test your replay rule.  There are several things you need to know:

=over 4

=item Does it meet the api interface requirements

=item does it match the proper messages

=item does it map to the right key atom list

=item does it reduce an ato list correctly

=item does it emit origin events properly during reduce

=item does it emit derived events properly during reduce

=item does it structure the delivery data correctly

=item does it format the delivery output correctly

=item does it structure the summary data correctly

=item does it format the summary output correctly

=item does it structure the globsummary data correctly

=item does it format the globsummary output correctly

=back

=head1 SEE ALSO

Replay

=head1 AUTHOR

David Ihnen <lt>davidihnen@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by David Ihnen

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.22.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
