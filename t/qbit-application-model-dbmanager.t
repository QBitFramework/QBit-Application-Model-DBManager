#!/usr/bin/perl -w

use qbit;
use Test::More;
use Test::MockObject::Extends;

use TestApp;

my $app = new TestApp();

$app->{'timelog'} = Test::MockObject::Extends->new($app->{'timelog'});

$app->timelog->mock('start', sub { });

$app->timelog->mock('finish', sub { });

is_deeply(
    $app->model_2->get_all(fields => ['name']),
    [
        {'name' => 'caption 1'},
        {'name' => 'caption 2'},
        {'name' => 'caption 3'},
        {'name' => 'caption 4'},
        {'name' => 'caption 5'}
    ],
    'type: SCALAR'
);

is_deeply(
    $app->model_2->get_all(fields => ['name_array']),
    [
        {'name_array' => ['caption 1']},
        {'name_array' => ['caption 2']},
        {'name_array' => ['caption 3']},
        {'name_array' => ['caption 4']},
        {'name_array' => ['caption 5']}
    ],
    'type: ARRAY'
);

is_deeply(
    $app->model_2->get_all(fields => ['name_hash']),
    [
        {'name_hash' => {caption => 'caption 1'}},
        {'name_hash' => {caption => 'caption 2'}},
        {'name_hash' => {caption => 'caption 3'}},
        {'name_hash' => {caption => 'caption 4'}},
        {'name_hash' => {caption => 'caption 5'}}
    ],
    'type: HASH'
);

is_deeply(
    $app->model_2->get_all(fields => ['info']),
    [
        {
            'info' => {
                caption => 'caption 1',
                domain  => 'domain 1'
            }
        },
        {
            'info' => {
                caption => 'caption 2',
                domain  => 'domain 2'
            }
        },
        {
            'info' => {
                caption => 'caption 3',
                domain  => 'domain 3'
            }
        },
        {
            'info' => {
                caption => 'caption 4',
                domain  => 'domain 4'
            }
        },
        {
            'info' => {
                caption => 'caption 5',
                domain  => 'domain 5'
            }
        }
    ],
    'type: HASH with multiple keys'
);

is_deeply(
    $app->model_2->get_all(fields => ['f_id', 'ids_by_owner']),
    [
        {
            'f_id'         => 1,
            'ids_by_owner' => [1, 2]
        },
        {
            'f_id'         => 2,
            'ids_by_owner' => [3]
        },
        {
            'f_id'         => 3,
            'ids_by_owner' => [4, 5, 6]
        },
        {
            'f_id'         => 4,
            'ids_by_owner' => [7]
        },
        {
            'f_id'         => 5,
            'ids_by_owner' => [8, 9]
        },
    ],
    'type: ARRAY with multiple result'
);

is_deeply(
    $app->model_2->get_all(fields => ['f_id', 'ids_with_owner']),
    [
        {
            'f_id'           => 1,
            'ids_with_owner' => [
                {
                    id      => 1,
                    creator => 'owner 1'
                },
                {
                    id      => 2,
                    creator => 'owner 1'
                }
            ]
        },
        {
            'f_id'           => 2,
            'ids_with_owner' => [
                {
                    id      => 3,
                    creator => 'owner 2'
                }
            ]
        },
        {
            'f_id'           => 3,
            'ids_with_owner' => [
                {
                    id      => 4,
                    creator => 'owner 3'
                },
                {
                    id      => 5,
                    creator => 'owner 3'
                },
                {
                    id      => 6,
                    creator => 'owner 3'
                }
            ]
        },
        {
            'f_id'           => 4,
            'ids_with_owner' => [
                {
                    id      => 7,
                    creator => 'owner 4'
                }
            ]
        },
        {
            'f_id'           => 5,
            'ids_with_owner' => [
                {
                    id      => 8,
                    creator => 'owner 5'
                },
                {
                    id      => 9,
                    creator => 'owner 5'
                }
            ]
        },
    ],
    'type: ARRAY with hash items'
);

is_deeply(
    $app->model_2->get_all(fields => ['ids_string_by_owner']),
    [
        {'ids_string_by_owner' => '1, 2'},
        {'ids_string_by_owner' => '3'},
        {'ids_string_by_owner' => '4, 5, 6'},
        {'ids_string_by_owner' => '7'},
        {'ids_string_by_owner' => '8, 9'}
    ],
    'method get after getting data'
);

is_deeply(
    $app->model_2->get_all(fields => ['two_fk_fields']),
    [
       {
         'two_fk_fields' => 'domain 1'
       },
       {
         'two_fk_fields' => 'domain 2'
       },
       {
         'two_fk_fields' => 'domain 3'
       },
       {
         'two_fk_fields' => 'domain 4'
       },
       {
         'two_fk_fields' => 'domain 5'
       }
     ],
    'two fk_fields, type: SCALAR'
);

is_deeply(
    $app->model_2->get_all(fields => ['two_fk_fields_hash']),
    [
       {
         'two_fk_fields_hash' => {
                                   'domain' => 'domain 1',
                                   'creator' => 'owner 1'
                                 }
       },
       {
         'two_fk_fields_hash' => {
                                   'domain' => 'domain 2',
                                   'creator' => 'owner 2'
                                 }
       },
       {
         'two_fk_fields_hash' => {
                                   'domain' => 'domain 3',
                                   'creator' => 'owner 3'
                                 }
       },
       {
         'two_fk_fields_hash' => {
                                   'domain' => 'domain 4',
                                   'creator' => 'owner 4'
                                 }
       },
       {
         'two_fk_fields_hash' => {
                                   'domain' => 'domain 5',
                                   'creator' => 'owner 5'
                                 }
       }
     ],
    'two fk_fields, type: HASH'
);

is_deeply(
    $app->model_2->get_all(fields => ['two_fk_fields_array']),
    [
       {
         'two_fk_fields_array' => [
                                    1,
                                    2
                                  ]
       },
       {
         'two_fk_fields_array' => [
                                    3
                                  ]
       },
       {
         'two_fk_fields_array' => [
                                    4,
                                    5,
                                    6
                                  ]
       },
       {
         'two_fk_fields_array' => [
                                    7
                                  ]
       },
       {
         'two_fk_fields_array' => [
                                    8,
                                    9
                                  ]
       }
     ],
    'two fk_fields, type: ARRAY'
);

done_testing();
