package QBit::Application::Model::DBManager::Filter::multistate;

use qbit;

use base qw(QBit::Application::Model::DBManager::Filter);

sub public_keys {return [qw(values)];}

sub pre_process {
    my ($self, $field, $field_name, %opts) = @_;

    throw gettext('Class "%s" must be descedant of "QBit::Application::Model::Multistate"', ref($self->{'db_manager'}))
      unless $self->{'db_manager'}->isa('QBit::Application::Model::Multistate');

    my @multistate_bits = grep {!$_->[2]{'private'}} @{$self->{'db_manager'}->get_multistates_bits()};

    if (exists($opts{multistate_groups}) && exists($opts{multistate_groups}{ref($self->{'db_manager'})})) {
        my @multistate_groups = @{$opts{multistate_groups}{ref($self->{'db_manager'})}};

        if (in_array('__EMPTY__', \@multistate_groups)) {
            @multistate_bits = map {clone($_)} @multistate_bits;

            $_->[2]{'multistate_groups'} //= ['__EMPTY__'] foreach @multistate_bits;
        }

        @multistate_bits = grep {
            exists($_->[2]{'multistate_groups'})
              && @{arrays_intersection($_->[2]{'multistate_groups'}, \@multistate_groups)}
        } @multistate_bits;
    }

    $field->{'values'} = {map {$_->[0] => ref($_->[1]) eq 'CODE' ? $_->[1]() : $_->[1]} @multistate_bits};

    return $field->{'values'};
}

sub tokens {
    my ($self, $field_name, $field) = @_;

    return {
        map {uc($_) => {re => '/\G(\Q' . uc($_) . '\E)/igc and return (' . uc($_) . ' => $1)', priority => length($_)}}
          keys(%{$field->{'values'}})
    };
}

sub nonterminals {
    my ($self, $field_name, $field, %opts) = @_;

    my $ns = lc(join('___', @{$opts{'ns'} || []}));

    return {($ns ? "${ns}___" : '')
          . "${field_name}___multistate" => join(" { \$_[1] }\n        |   ", map {uc($_)} keys(%{$field->{'values'}}))
          . " { \$_[1] }\n        ;"
    };
}

sub expressions {
    my ($self, $field_name, $field, %opts) = @_;

    my $uc_field_name = uc($field_name);
    my $ns = lc(join('___', @{$opts{'ns'} || []}));

    return [
        $uc_field_name 
          . " '='  "
          . ($ns ? "${ns}___" : '')
          . "${field_name}___multistate"
          . " { [$_[1] => '='  => \$_[3]] }",
        $uc_field_name 
          . " '<>' "
          . ($ns ? "${ns}___" : '')
          . "${field_name}___multistate"
          . " { [$_[1] => '<>' => \$_[3]] }"
    ];
}

sub check {
    throw gettext('Bad operation "%s"', $_[1]->[1])
      unless in_array($_[1]->[1], ['=', '<>']);
}

sub as_text {
    "$_[1]->[0] $_[1]->[1] $_[1]->[2]";
}

sub as_filter {
    [$_[1]->[0] => $_[1]->[1] => \$_[0]->{'db_manager'}->get_multistates_by_filter($_[1]->[2])];
}

TRUE;
