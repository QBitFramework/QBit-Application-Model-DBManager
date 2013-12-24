package Models::Model2;

use qbit;
use base qw(QBit::Application::Model::DBManager);

use Test::MockObject::Extends;

__PACKAGE__->model_accessors(model_1 => 'Models::Model1',);

__PACKAGE__->model_fields(
    f_id => {
        default => TRUE,
        db      => TRUE,
        pk      => TRUE,
        label   => d_gettext('ID'),
    },
    owner => {
        default => TRUE,
        db      => TRUE,
        label   => d_gettext('Owner'),
    },
    short_caption => {
        default => TRUE,
        db      => TRUE,
        label   => d_gettext('Short caption'),
    },
    name => {
        depends_on     => ['f_id'],
        model_accessor => 'model_1',
        fk_fields      => ['f_id' => 'id'],
        fields         => ['caption'],
        result         => 'SCALAR',
    },
    name_array => {
        depends_on     => ['f_id'],
        model_accessor => 'model_1',
        fk_fields      => ['f_id' => 'id'],
        fields         => ['caption'],
        result         => 'ARRAY',
    },
    name_hash => {
        depends_on     => ['f_id'],
        model_accessor => 'model_1',
        fk_fields      => ['f_id' => 'id'],
        fields         => ['caption'],
        result         => 'HASH',
    },
    info => {
        depends_on     => ['f_id'],
        model_accessor => 'model_1',
        fk_fields      => ['f_id' => 'id'],
        fields         => ['caption', 'domain'],
        result         => 'HASH',
    },
    ids_by_owner => {
        depends_on     => ['owner'],
        model_accessor => 'model_1',
        fk_fields      => ['owner' => 'creator'],
        fields         => ['id'],
        result         => 'ARRAY',
    },
    ids_with_owner => {
        depends_on     => ['owner'],
        model_accessor => 'model_1',
        fk_fields      => ['owner' => 'creator'],
        fields         => ['id', 'creator'],
        result         => 'ARRAY',
    },
    ids_string_by_owner => {
        depends_on     => ['owner'],
        model_accessor => 'model_1',
        fk_fields      => ['owner' => 'creator'],
        fields         => ['id'],
        result         => 'ARRAY',
        get => sub {
            join(', ', @{$_[2]});
        }
    },
    two_fk_fields => {
        depends_on     => ['f_id', 'owner'],
        model_accessor => 'model_1',
        fk_fields      => ['f_id' => 'id', 'owner' => 'creator'],
        fields         => ['domain'],
        result         => 'SCALAR',
    },
    two_fk_fields_hash => {
        depends_on     => ['f_id', 'owner'],
        model_accessor => 'model_1',
        fk_fields      => ['f_id' => 'id', 'owner' => 'creator'],
        fields         => ['domain', 'creator'],
        result         => 'HASH',
    },
    two_fk_fields_array => {
        depends_on     => ['short_caption', 'owner'],
        model_accessor => 'model_1',
        fk_fields      => ['short_caption' => 'caption', 'owner' => 'creator'],
        fields         => ['id'],
        result         => 'ARRAY',
    },
);

sub query {
    my ($self, %opts) = @_;

    my $fields = $opts{'fields'}->get_db_fields();

    my $query = Test::MockObject::Extends->new();

    $query->mock(
        'get_all',
        sub {

            my @result = ();
            for my $count (1 .. 5) {
                my $var->{'f_id'} = $count;
                foreach my $field (grep {$_ ne 'f_id'} keys(%$fields)) {
                    $var->{$field} = "$field $count";
                }
                push (@result, $var);
            }
            return \@result;
        }
    );

    $query->mock('all_langs', sub {return $query});

    return $query;
}

TRUE;
