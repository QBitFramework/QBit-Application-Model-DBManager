package Models::Model1;

use qbit;
use base qw(QBit::Application::Model::DBManager);    #QBit::Application

__PACKAGE__->model_fields(
    id => {
        default => TRUE,
        db      => TRUE,
        pk      => TRUE,
        label   => d_gettext('ID'),
    },
    domain => {
        default => TRUE,
        db      => TRUE,
        label   => d_gettext('Domain'),
    },
    caption => {
        db    => TRUE,
        label => d_gettext('Caption'),
    }
);

sub get_all {
    my ($self, %opts) = @_;

    my %fields = map {$_ => TRUE} @{$opts{'fields'}};

    foreach (@{$opts{'fields'}}) {
        return [
            {creator => "owner 1", id => 1, caption => 'short_caption 1'},
            {creator => "owner 1", id => 2, caption => 'short_caption 1'},
            {creator => "owner 2", id => 3, caption => 'short_caption 2'},
            {creator => "owner 3", id => 4, caption => 'short_caption 3'},
            {creator => "owner 3", id => 5, caption => 'short_caption 3'},
            {creator => "owner 3", id => 6, caption => 'short_caption 3'},
            {creator => "owner 4", id => 7, caption => 'short_caption 4'},
            {creator => "owner 5", id => 8, caption => 'short_caption 5'},
            {creator => "owner 5", id => 9, caption => 'short_caption 5'},
        ] if $_ eq 'creator' && !$fields{'domain'};
    }

    my $result = [
        map {
            my $value = $_;
            {
                id => $value,
                map {$_ => "$_ $value"} grep {$_ ne 'id'} @{$opts{'fields'}}
            }
          } (1 .. 5)
    ];

    foreach (@$result) {
        $_->{'creator'} =~ s/creator/owner/ if $_->{'creator'};
    };

    return $result;
}

TRUE;
