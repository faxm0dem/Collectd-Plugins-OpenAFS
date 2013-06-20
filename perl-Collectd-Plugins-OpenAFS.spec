#------------------------------------------------------------------------------
# P A C K A G E  I N F O
#------------------------------------------------------------------------------

Summary: Collectd OpenAFS plugins
Name: perl-Collectd-Plugins-OpenAFS
Version: 0.1007
Release: 0
Group: Applications/System
Packager: Fabien Wernli
License: GPL+ or Artistic
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch: noarch
AutoReq: no
Source: http://search.cpan.org/CPAN/Collectd-Plugins-OpenAFS-%{version}.tar.gz

Requires: perl(Collectd)
Requires: perl(AFS::VOS)
Requires: perl(AFS::VLDB)
Requires: perl(Collectd)
Requires: perl >= 0:5.008002

Provides: perl(AFS::VOS)
Provides: perl(AFS::VLDB)

%description
This package contains the OpenAFS read plugins

%prep
%setup -q -n Collectd-Plugins-OpenAFS-%{version}

#------------------------------------------------------------------------------
# B U I L D
#------------------------------------------------------------------------------

%build
PERL_MM_USE_DEFAULT=1 %{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

#------------------------------------------------------------------------------
# I N S T A L L 
#------------------------------------------------------------------------------

%install
rm -rf %{buildroot}

make pure_install PERL_INSTALL_ROOT=%{buildroot}
find %{buildroot} -type f -name .packlist -exec rm -f {} ';'
find %{buildroot} -depth -type d -exec rmdir {} 2>/dev/null ';'

### %check
### make test

%clean
rm -rf %{buildroot}

#------------------------------------------------------------------------------
# F I L E S
#------------------------------------------------------------------------------

%files
%defattr(-,root,root,-)
%doc Changes README
%{perl_vendorlib}/*
%{_mandir}/man3/*.3*

%pre
# TODO: add config to /etc/smurf/client.rc

%post
#/sbin/service smurf-client reload

%preun
# TODO: remove config from /etc/smurf/client.rc

%postun
#/sbin/service smurf-client reload

%changelog
# output by: date +"* \%a \%b \%d \%Y $USER"
* Thu Dec 29 2011 fwernli 0.1001-0
- release

