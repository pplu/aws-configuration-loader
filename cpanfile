requires 'Paws', '>= 0.34';

on develop => sub {
  requires 'Pod::Markdown';

  requires 'Dist::Zilla';
  requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile';
  requires 'Dist::Zilla::Plugin::VersionFromModule';
  requires 'Dist::Zilla::PluginBundle::Git';
};
