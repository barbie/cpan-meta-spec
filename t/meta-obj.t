use strict;
use warnings;
use Test::More 0.88;

use CPAN::Meta;

my $distmeta = {
  name     => 'Module-Build',
  abstract => 'Build and install Perl modules',
  description =>  "Module::Build is a system for building, testing, "
              .   "and installing Perl modules.  It is meant to be an "
              .   "alternative to ExtUtils::MakeMaker... blah blah blah",
  version  => '0.36',
  author   => [
    'Ken Williams <kwilliams@cpan.org>',
    'Module-Build List <module-build@perl.org>', # additional contact
  ],
  release_status => 'stable',
  license  => [ 'perl_5' ],
  prereqs => {
    runtime => {
      requires => {
        'perl'   => '5.006',
        'Config' => '0',
        'Cwd'    => '0',
        'Data::Dumper' => '0',
        'ExtUtils::Install' => '0',
        'File::Basename' => '0',
        'File::Compare'  => '0',
        'File::Copy' => '0',
        'File::Find' => '0',
        'File::Path' => '0',
        'File::Spec' => '0',
        'IO::File'   => '0',
      },
      recommends => {
        'Archive::Tar' => '1.00',
        'ExtUtils::Install' => '0.3',
        'ExtUtils::ParseXS' => '2.02',
        'Pod::Text' => '0',
        'YAML' => '0.35',
      },
    },
    build => {
      requires => {
        'Test::More' => '0',
      },
    }
  },
  resources => {
    license => ['http://dev.perl.org/licenses/'],
  },
  optional_features => {
    domination => {
      description => 'Take over the world',
      prereqs     => {
        develop => { requires => { 'Genius::Evil'     => '1.234' } },
        runtime => { requires => { 'Machine::Weather' => '2.0'   } },
      },
    },
  },
  dynamic_config => 1,
  keywords => [ qw/ toolchain cpan dual-life / ],
  'meta-spec' => {
    version => '2',
    url     => 'http://search.cpan.org/perldoc?CPAN::Meta::Spec',
  },
  generated_by => 'Module::Build version 0.36',
};

my $meta = CPAN::Meta->new($distmeta);

is($meta->name,     'Module-Build', '->name');
is($meta->abstract, 'Build and install Perl modules', '->abstract');

like($meta->description, qr/Module::Build.+blah blah blah/, '->description');

is($meta->version,   '0.36', '->version');

ok($meta->dynamic_config, "->dynamic_config");

is_deeply(
  [ $meta->author ],
  [
    'Ken Williams <kwilliams@cpan.org>',
    'Module-Build List <module-build@perl.org>',
  ],
  '->author',
);

is_deeply(
  [ $meta->authors ],
  [
    'Ken Williams <kwilliams@cpan.org>',
    'Module-Build List <module-build@perl.org>',
  ],
  '->authors',
);

is_deeply(
  [ $meta->license ],
  [ qw(perl_5) ],
  '->license',
);

is_deeply(
  [ $meta->licenses ],
  [ qw(perl_5) ],
  '->licenses',
);

is_deeply(
  [ $meta->keywords ],
  [ qw/ toolchain cpan dual-life / ],
  '->keywords',
);

is_deeply(
  $meta->resources,
  { license => [ 'http://dev.perl.org/licenses/' ] },
  '->resources',
);

is_deeply(
  $meta->meta_spec,
  {
    version => '2',
    url     => 'http://search.cpan.org/perldoc?CPAN::Meta::Spec',
  },
  '->meta_spec',
);

is($meta->meta_spec_version, '2', '->meta_spec_version');

is($meta->generated_by, 'Module::Build version 0.36', '->generated_by');

my $basic = $meta->effective_prereqs;

is_deeply(
  $basic->as_string_hash,
  $distmeta->{prereqs},
  "->effective_prereqs()"
);

my $with_features = $meta->effective_prereqs([ qw(domination) ]);

is_deeply(
  $with_features->as_string_hash,
  {
    develop => { requires => { 'Genius::Evil'     => '1.234' } },
    runtime => {
      requires => {
        'perl'   => '5.006',
        'Config' => '0',
        'Cwd'    => '0',
        'Data::Dumper' => '0',
        'ExtUtils::Install' => '0',
        'File::Basename' => '0',
        'File::Compare'  => '0',
        'File::Copy' => '0',
        'File::Find' => '0',
        'File::Path' => '0',
        'File::Spec' => '0',
        'IO::File'   => '0',
        'Machine::Weather' => '2.0',
      },
      recommends => {
        'Archive::Tar' => '1.00',
        'ExtUtils::Install' => '0.3',
        'ExtUtils::ParseXS' => '2.02',
        'Pod::Text' => '0',
        'YAML' => '0.35',
      },
    },
    build => {
      requires => {
        'Test::More' => '0',
      },
    }
  },
  "->effective_prereqs([ qw(domination) ])"
);

my $chk_feature = sub {
  my $feature = shift;

  isa_ok($feature, 'CPAN::Meta::Feature');

  is($feature->identifier,  'domination',          '$feature->identifier');
  is($feature->description, 'Take over the world', '$feature->description');

  is_deeply(
    $feature->prereqs->as_string_hash,
    {
      develop => { requires => { 'Genius::Evil'     => '1.234' } },
      runtime => { requires => { 'Machine::Weather' => '2.0'   } },
    },
    '$feature->prereqs',
  );
};

my @features = $meta->features;
is(@features, 1, "we got one feature");
$chk_feature->($features[0]);

$chk_feature->( $meta->feature('domination') );

done_testing;
