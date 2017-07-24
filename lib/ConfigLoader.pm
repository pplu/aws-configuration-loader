package ConfigLoader;
  use Moose;
  use Paws;

  #ABSTRACT: Use SSM Parameter service to retrieve configs for an application
  our $VERSION = '0.01';

  has app => (
    is => 'ro',
    isa => 'Str',
    required => 1,
  );

  has environment => (
    is => 'ro',
    isa => 'Str',
    required => 1,
  );

  has region => (
    is => 'ro',
    isa => 'Str',
    required => 1
  );

  has _ssm => (
    is => 'ro',
    isa => 'Paws::SSM',
    lazy => 1,
    builder => '_ssm_builder'
  );

  has parameters => (
    is => 'ro',
    isa => 'ArrayRef[Paws::SSM::Parameter]',
    lazy => 1,
    builder => '_build_parameters',
    traits => [ 'Array' ],
    handles => {
      num_of_parameters => 'count',
    }
  );

  has _ssm_prefix => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
      my $self = shift;
      return sprintf "/%s/%s/", $self->app, $self->environment;
    }
  );

  sub _ssm_builder {
    my $self = shift;
    return Paws->service('SSM', region => $self->region);
  }

  sub _build_parameters {
    my $self = shift;
    my @parameters;

    my $result = $self->_ssm->GetParametersByPath(
      MaxResults => 10,
      Path => $self->_ssm_prefix,
      WithDecryption => 1,
    );
    push @parameters, @{ $result->Parameters };

    while (my $nt = $result->NextToken) {
      $result = $self->_ssm->GetParametersByPath(
        MaxResults => 10,
        Path => $self->_ssm_prefix,
        WithDecryption => 1,
        NextToken => $nt,
      );
      push @parameters, @{ $result->Parameters };
    }
    return \@parameters;
  }

1;
