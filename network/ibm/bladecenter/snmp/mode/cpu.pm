#
# Copyright 2020 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package network::ibm::bladecenter::snmp::mode::cpu;

use base qw(centreon::plugins::templates::counter);

use strict;
use warnings;

sub set_counters {
    my ($self, %options) = @_;

    $self->{maps_counters_type} = [
        { name => 'cpu', type => 0, skipped_code => { -10 => 1 } },
    ];

    $self->{maps_counters}->{cpu} = [
        { label => 'average', nlabel => 'cpu.utilization.percentage', set => {
                key_values => [ { name => 'average' } ],
                output_template => '%.2f %%',
                perfdatas => [
                    { label => 'total_cpu_avg', value => 'average_absolute', template => '%.2f',
                      min => 0, max => 100, unit => '%' },
                ],
            }
        },
    ];
}

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;

    return $self;
}

sub manage_selection {
    my ($self, %options) = @_;

    my $oid_mpCpuStatsUtil1Minute = '.1.3.6.1.4.1.26543.2.5.1.2.2.3.0';
    my $result = $options{snmp}->get_leef(oids => [$oid_mpCpuStatsUtil1Minute], nothing_quit => 1);

    $self->{cpu} = {
        average => $result->{$oid_mpCpuStatsUtil1Minute},
    }
}

1;

__END__

=head1 MODE

Check CPU usage (over the last minute).

=over 8

=item B<--warning-average>

Warning threshold average CPU utilization. 

=item B<--critical-average>

Critical  threshold average CPU utilization. 

=back

=cut
